package io.paasas.teleport.client.spring;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.validation.annotation.Validated;

import io.paasas.teleport.client.reactor.AuthServiceClient;
import io.paasas.teleport.client.reactor.TeleportConfiguration;

@Configuration
public class TeleportAutoConfiguration {

	@Bean
	@Validated
	@ConfigurationProperties(prefix = "paasas.teleport")
	public TeleportConfiguration teleportConfiguration() {
		return new TeleportConfiguration();
	}

	@Bean
	public AuthServiceClient authServiceClient(TeleportConfiguration teleportConfiguration) {
		return new AuthServiceClient(teleportConfiguration);
	}
}