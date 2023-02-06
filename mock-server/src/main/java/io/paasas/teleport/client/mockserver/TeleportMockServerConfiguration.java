package io.paasas.teleport.client.mockserver;

import jakarta.validation.constraints.Min;
import lombok.AccessLevel;
import lombok.Data;
import lombok.experimental.FieldDefaults;

@Data
@FieldDefaults(level = AccessLevel.PRIVATE)
public class TeleportMockServerConfiguration {
	@Min(value = 1)
	int port;
}
