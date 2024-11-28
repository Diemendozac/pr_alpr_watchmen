abstract class AuthEvent {}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  LoginRequested(this.email, this.password);
}

class LogoutRequested extends AuthEvent {}

class FetchWatchmanData extends AuthEvent {}

class CheckTokenValidity extends AuthEvent {}
