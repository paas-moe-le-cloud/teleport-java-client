package io.paasas.teleport.client.spring;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import io.paasas.teleport.client.reactor.AuthServiceClient;
import io.paasas.teleport.client.spring.test.SpringBootStarterTeleportClientTestApplication;

@SpringBootTest(classes = SpringBootStarterTeleportClientTestApplication.class)
public class AuthServiceClientAutoConfigTest {
	@Autowired
	private AuthServiceClient authServiceClient;

	@Test
	public void shouldGenerateKubernetesToken() {
		authServiceClient.generateKubernetesToken().block();
	}
}