package io.paasas.teleport.client.spring.mockserver;

import java.util.Optional;

import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import io.paasas.teleport.client.mockserver.TeleportMockServer;
import io.paasas.teleport.client.spring.mockserver.test.PaasasTeleportMockServerTestApplication;

@SpringBootTest(classes = PaasasTeleportMockServerTestApplication.class, properties = "paasas.teleport.mock.enabled=true")
public class EnabledMockServerTest {
	@Autowired
	private Optional<TeleportMockServer> server;

	@Test
	public void assertIsAutoConfigured() {
		Assertions.assertTrue(server.isPresent());
	}
}