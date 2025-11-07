import 'package:flutter/material.dart';
import 'package:proyecto_solicitudes/core/theme/app_colors.dart';
import 'package:proyecto_solicitudes/features/auth/presentation/widgets/login_form.dart';
import 'package:proyecto_solicitudes/features/auth/presentation/widgets/login_header.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScaffoldLight,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              color: Colors.white,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 28, vertical: 28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    LoginHeader(),
                    SizedBox(height: 24),
                    LoginForm(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
