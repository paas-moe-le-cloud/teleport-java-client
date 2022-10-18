package io.paasas.teleport.client.reactor;

import java.io.ByteArrayInputStream;
import java.util.concurrent.Executor;
import java.util.concurrent.Executors;
import java.util.function.Function;

import javax.net.ssl.SSLException;

import com.google.common.util.concurrent.Futures;
import com.google.common.util.concurrent.ListenableFuture;

import io.grpc.netty.shaded.io.grpc.netty.GrpcSslContexts;
import io.grpc.netty.shaded.io.grpc.netty.NegotiationType;
import io.grpc.netty.shaded.io.grpc.netty.NettyChannelBuilder;
import io.grpc.netty.shaded.io.netty.handler.ssl.SslContext;
import io.grpc.netty.shaded.io.netty.handler.ssl.SslContextBuilder;
import io.paasas.teleport.client.reactor.util.MonoFutureCallback;
import lombok.AccessLevel;
import lombok.experimental.FieldDefaults;
import proto.AuthServiceGrpc;
import proto.AuthServiceGrpc.AuthServiceFutureStub;
import proto.Authservice.GenerateTokenRequest;
import proto.Authservice.GenerateTokenResponse;
import reactor.core.publisher.Mono;
import reactor.core.publisher.MonoSink;

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
		return Mono.<GenerateTokenResponse>create(this::generateKubernetesToken)
				.map(response -> response.getToken());
	}

	private void generateKubernetesToken(MonoSink<GenerateTokenResponse> sink) {
		createFuture(
				authService -> authService
						.generateToken(GenerateTokenRequest.newBuilder()
								.addRoles("Kube")
								.build()),
				sink);
	}

	private <T> void createFuture(
			Function<AuthServiceFutureStub, ListenableFuture<T>> futureSupplier,
			MonoSink<T> sink) {
		var channelBuilder = NettyChannelBuilder.forAddress(teleportConfiguration.getHost(), teleportConfiguration.getPort());

		if (teleportConfiguration.isTlsEnabled()) {
			channelBuilder = channelBuilder.negotiationType(NegotiationType.TLS)
					.sslContext(buildSslContext());
		} else {
			channelBuilder = channelBuilder.usePlaintext();
		}

		Futures.<T>addCallback(
				futureSupplier.apply(AuthServiceGrpc.newFutureStub(channelBuilder.build())),
				new MonoFutureCallback<T>(sink),
				EXECUTOR);
	}
}
