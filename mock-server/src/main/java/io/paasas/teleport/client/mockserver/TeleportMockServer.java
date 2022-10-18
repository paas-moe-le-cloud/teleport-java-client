package io.paasas.teleport.client.mockserver;

import java.io.Closeable;
import java.io.IOException;

import io.grpc.Server;
import io.grpc.ServerBuilder;
import io.paasas.teleport.client.mockserver.grpc.AuthService;
import lombok.extern.slf4j.Slf4j;

@Slf4j
public class TeleportMockServer implements Closeable {
	private static final AuthService AUTH_SERVICE = new AuthService();

	private final TeleportMockServerConfiguration configuration;
	private final Server server;

	public TeleportMockServer(TeleportMockServerConfiguration configuration) {
		this.configuration = configuration;

		server = ServerBuilder.forPort(configuration.getPort())
				.addService(AUTH_SERVICE)
				.build();

		try {
			server.start();

			log.info("Started Teleport Mock Server on port {}", configuration.getPort());
		} catch (IOException e) {
			throw new RuntimeException(e);
		}
	}

	@Override
	public void close() throws IOException {
		log.info("Shutting down Teleport Mock Server on port {}", configuration.getPort());

		server.shutdown();
		try {
			server.awaitTermination();

			log.info("Teleport Mock Server on port {} has been shutdown", configuration.getPort());
		} catch (InterruptedException e) {
			throw new RuntimeException(e);
		}
	}
}
