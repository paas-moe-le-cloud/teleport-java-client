package io.paasas.teleport.client.mockserver.grpc;

import java.util.HashSet;
import java.util.Set;
import java.util.UUID;

import io.grpc.Status;
import io.grpc.StatusRuntimeException;
import io.grpc.stub.StreamObserver;
import proto.AuthServiceGrpc.AuthServiceImplBase;
import proto.Authservice.GenerateTokenRequest;
import proto.Authservice.GenerateTokenResponse;

public class AuthService extends AuthServiceImplBase {
	private static final Set<String> GENERATED_TOKENS = new HashSet<>();

	@Override
	public void generateToken(GenerateTokenRequest request, StreamObserver<GenerateTokenResponse> responseObserver) {
		if (request.getRolesList().stream().filter(role -> role.equals("Kube")).findAny().isEmpty()) {
			responseObserver.onError(
					new StatusRuntimeException(Status.INVALID_ARGUMENT.withDescription("role kube is not registered")));
		}

		String token = UUID.randomUUID().toString();

		GENERATED_TOKENS.add(token);

		responseObserver.onNext(GenerateTokenResponse.newBuilder().setToken(token).build());
		responseObserver.onCompleted();
	}
}
