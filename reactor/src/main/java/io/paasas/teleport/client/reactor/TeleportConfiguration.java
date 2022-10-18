package io.paasas.teleport.client.reactor;

import javax.validation.constraints.Min;
import javax.validation.constraints.NotEmpty;

import lombok.AccessLevel;
import lombok.Data;
import lombok.experimental.FieldDefaults;

@Data
@FieldDefaults(level = AccessLevel.PRIVATE)
public class TeleportConfiguration {
	@NotEmpty
	String host;
	@Min(value = 1)
	int port;
	String ca;
	String certificate;
	String key;
	boolean tlsEnabled;
}
