package io.paasas.teleport.client.reactor.util;

import io.grpc.ManagedChannel;
import lombok.AccessLevel;
import lombok.Data;
import lombok.experimental.FieldDefaults;

@Data
@FieldDefaults(level = AccessLevel.PRIVATE)
public class ChannelContext {
	ManagedChannel managedChannel;
}
