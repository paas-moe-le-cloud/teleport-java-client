package io.paasas.teleport.client.spring.mockserver;

import java.util.Optional;

import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import io.paasas.teleport.client.mockserver.TeleportMockServer;
import io.paasas.teleport.client.spring.mockserver.test.PaasasTeleportMockServerTestApplication;

@SpringBootTest(classes = PaasasTeleportMockServerTestApplication.class)
public class DisabledMockServerTest {
	@Autowired
	private Optional<TeleportMockServer> server;

	@Test
	public void assertNotAutoConfigured() {
		Assertions.assertTrue(server.isEmpty());
	}
}