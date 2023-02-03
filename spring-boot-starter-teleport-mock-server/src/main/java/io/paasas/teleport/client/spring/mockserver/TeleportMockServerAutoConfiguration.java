package io.paasas.teleport.client.spring.mockserver;

import org.springframework.boot.autoconfigure.AutoConfiguration;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.PropertySource;
import org.springframework.validation.annotation.Validated;

import io.paasas.teleport.client.mockserver.TeleportMockServer;
import io.paasas.teleport.client.mockserver.TeleportMockServerConfiguration;

@AutoConfiguration
@ConditionalOnProperty(name = "paasas.teleport.mock.enabled", havingValue = "true", matchIfMissing = false)
public class TeleportMockServerAutoConfiguration {

	@Configuration
	@PropertySource("classpath:teleport-mock-server-defaults.properties")
	class ConfigurationConfig {
		@Bean
		@Validated
		@ConfigurationProperties(prefix = "paasas.teleport.mock")
		public TeleportMockServerConfiguration teleportMockServerConfiguration() {
			return new TeleportMockServerConfiguration();
		}
	}

	@Bean
	public TeleportMockServer teleportMockServer(TeleportMockServerConfiguration teleportMockServerConfiguration) {
		return new TeleportMockServer(teleportMockServerConfiguration);
	}
}