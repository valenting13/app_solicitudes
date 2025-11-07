import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Estado global de autenticación (true = logueado)
class AuthState extends Notifier<bool> {
  @override
  bool build() => false;
  void setLoggedIn(bool v) => state = v;
}

final isLoggedInProvider = NotifierProvider<AuthState, bool>(AuthState.new);
