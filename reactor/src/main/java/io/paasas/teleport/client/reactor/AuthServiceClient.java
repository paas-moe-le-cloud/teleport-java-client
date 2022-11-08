package io.paasas.teleport.client.reactor;

import java.io.ByteArrayInputStream;
import java.util.concurrent.Executor;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;
import java.util.function.Function;

import javax.net.ssl.SSLException;

import com.google.common.util.concurrent.Futures;
import com.google.common.util.concurrent.ListenableFuture;

import io.grpc.ManagedChannel;
import io.grpc.netty.shaded.io.grpc.netty.GrpcSslContexts;
import io.grpc.netty.shaded.io.grpc.netty.NegotiationType;
import io.grpc.netty.shaded.io.grpc.netty.NettyChannelBuilder;
import io.grpc.netty.shaded.io.netty.handler.ssl.SslContext;
import io.grpc.netty.shaded.io.netty.handler.ssl.SslContextBuilder;
import io.paasas.teleport.client.reactor.util.ChannelContext;
import io.paasas.teleport.client.reactor.util.MonoFutureCallback;
import lombok.AccessLevel;
import lombok.experimental.FieldDefaults;
import proto.AuthServiceGrpc;
import proto.AuthServiceGrpc.AuthServiceFutureStub;
import proto.Authservice.GenerateTokenRequest;
import proto.Authservice.GenerateTokenResponse;
import reactor.core.publisher.Mono;
import reactor.core.publisher.MonoSink;
import reactor.core.scheduler.Schedulers;

@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class AuthServiceClient {
	private static final Executor EXECUTOR = Executors.newCachedThreadPool();

	TeleportConfiguration teleportConfiguration;

	public AuthServiceClient(TeleportConfiguration teleportConfiguration) {
		if (teleportConfiguration.isTlsEnabled()) {
			if (teleportConfiguration.getCertificate() == null || teleportConfiguration.getCertificate().isBlank()) {
				throw new IllegalArgumentException("a certificate is required when tls is enabled");
			}

			if (teleportConfiguration.getKey() == null || teleportConfiguration.getKey().isBlank()) {
				throw new IllegalArgumentException("a private key is required when tls is enabled");
			}
		}
		this.teleportConfiguration = teleportConfiguration;
	}

	private SslContext buildSslContext() {
		SslContextBuilder builder = GrpcSslContexts.forClient();

		if (teleportConfiguration.getCa() != null && !teleportConfiguration.getCa().isEmpty()) {
			builder.trustManager(new ByteArrayInputStream(teleportConfiguration.getCa().getBytes()));
		}
		if (teleportConfiguration.getCertificate() != null && !teleportConfiguration.getCertificate().isEmpty() &&
				teleportConfiguration.getKey() != null && !teleportConfiguration.getKey().isEmpty()) {
			builder.keyManager(
					new ByteArrayInputStream(teleportConfiguration.getCertificate().getBytes()),
					new ByteArrayInputStream(teleportConfiguration.getKey().getBytes()));
		}
		try {
			return builder.build();
		} catch (SSLException e) {
			throw new RuntimeException(e);
		}
	}

	public Mono<String> generateKubernetesToken() {
		return AuthServiceClient
				.<GenerateTokenResponse>handleChannel(sink -> generateKubernetesToken(sink))
				.map(response -> response.getToken());
	}

	private static <T> Mono<T> handleChannel(Function<MonoSink<T>, ManagedChannel> command) {
		var context = new ChannelContext();

		return Mono.<T>create(sink -> context.setManagedChannel(command.apply(sink)))
				.doOnTerminate(() -> shutdown(context))
				.subscribeOn(Schedulers.boundedElastic());
	}

	private static void shutdown(ChannelContext context) {
		if (context.getManagedChannel() == null) {
			return;
		}

		try {
			if (!context.getManagedChannel().shutdown().awaitTermination(5, TimeUnit.SECONDS)) {
				throw new RuntimeException("Channel " + context.getManagedChannel() + " could not be closed");
			}
		} catch (InterruptedException e) {
			throw new RuntimeException(e);
		}
	}

	private ManagedChannel generateKubernetesToken(
			MonoSink<GenerateTokenResponse> sink) {
		return handleFuture(
				authService -> authService
						.generateToken(GenerateTokenRequest.newBuilder()
								.addRoles("Kube")
								.build()),
				sink);
	}

	private <T> ManagedChannel handleFuture(
			Function<AuthServiceFutureStub, ListenableFuture<T>> futureSupplier,
			MonoSink<T> sink) {
		return createFuture(
				authService -> futureSupplier.apply(authService),
				sink);
	}

	private <T> ManagedChannel createFuture(
			Function<AuthServiceFutureStub, ListenableFuture<T>> futureSupplier,
			MonoSink<T> sink) {
		var channelBuilder = NettyChannelBuilder.forAddress(teleportConfiguration.getHost(),
				teleportConfiguration.getPort());

		if (teleportConfiguration.isTlsEnabled()) {
			channelBuilder = channelBuilder.negotiationType(NegotiationType.TLS)
					.sslContext(buildSslContext());
		} else {
			channelBuilder = channelBuilder.usePlaintext();
		}

		var channel = channelBuilder.build();

		Futures.<T>addCallback(
				futureSupplier.apply(AuthServiceGrpc.newFutureStub(channel)),
				new MonoFutureCallback<T>(sink),
				EXECUTOR);

		return channel;
	}
}
