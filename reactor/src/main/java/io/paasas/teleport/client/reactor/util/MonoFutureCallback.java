package io.paasas.teleport.client.reactor.util;

import com.google.common.util.concurrent.FutureCallback;

import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.experimental.FieldDefaults;
import reactor.core.publisher.MonoSink;

@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class MonoFutureCallback<T> implements FutureCallback<T> {
	MonoSink<T> sink;

	@Override
	public void onSuccess(T result) {
		sink.success(result);
	}

	@Override
	public void onFailure(Throwable t) {
		sink.error(t);
	}
}
