abstract class AuthState {}

class AuthInitial extends AuthState {}

class Authenticated extends AuthState {
  final Map<String, dynamic> watchmanData;

  Authenticated(this.watchmanData);
}

class Unauthenticated extends AuthState {}

class AuthLoading extends AuthState {}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}
