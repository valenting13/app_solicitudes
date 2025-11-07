import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Si quieres navegar manualmente, puedes usar go_router:
// import 'package:go_router/go_router.dart';

import '../../application/auth_providers.dart';
import 'package:proyecto_solicitudes/core/theme/input_theme.dart';
import 'package:proyecto_solicitudes/core/theme/widgets/primary_button.dart';
import 'package:proyecto_solicitudes/core/theme/app_colors.dart';

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});
  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginControllerProvider);
    final loading = state.isLoading;

    // Mostrar errores de LoginController automáticamente (opcional)
    ref.listen(loginControllerProvider, (prev, next) {
      next.whenOrNull(
        error: (err, _) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(_mapError(err.toString()))),
          );
        },
      );
    });

    return Theme(
      data: Theme.of(context).copyWith(inputDecorationTheme: buildLoginInputTheme()),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Email
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              autofillHints: const [AutofillHints.email],
              style: const TextStyle(color: kTextPrimary),
              decoration: const InputDecoration(
                labelText: 'Correo electrónico',
                hintText: 'tu@correo.com',
                prefixIcon: Icon(Icons.mail_outline),
              ),
              validator: (v) {
                      if( !EmailValidator.validate(v ?? '') ) return 'Email no válido';

                      return null;
                    },
              onFieldSubmitted: (_) => _submit(loading),
            ),
            const SizedBox(height: 14),

            // Password
            TextFormField(
              controller: _passwordController,
              obscureText: _obscure,
              autofillHints: const [AutofillHints.password],
              style: const TextStyle(color: kTextPrimary),
              decoration: InputDecoration(
                labelText: 'Contraseña',
                hintText: '••••••••',
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  onPressed: () => setState(() => _obscure = !_obscure),
                  tooltip: _obscure ? 'Mostrar' : 'Ocultar',
                  icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
                ),
              ),
              validator: (v) => (v == null || v.isEmpty) ? 'Requerido' : null,
              onFieldSubmitted: (_) => _submit(loading),
            ),
            const SizedBox(height: 18),

            // Botón principal
            PrimaryButton(
              onPressed: loading ? null : () => _submit(loading),
              label: loading ? 'Ingresando…' : 'Iniciar sesión',
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit(bool loading) async {
    if (loading) return;
    if (!_formKey.currentState!.validate()) return;

    final ok = await ref.read(loginControllerProvider.notifier).login(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (!mounted) return;

    if (!ok) {
      final err = ref.read(loginControllerProvider).whenOrNull(error: (e, _) => e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_mapError(err ?? 'Error al iniciar sesión'))),
      );
      return;
    }
  }

  String _mapError(String msg) {
    if (msg.contains('401')) return 'Correo o contraseña inválidos';
    if (msg.contains('423')) return 'Cuenta inactiva. Contacta al administrador.';
    if (msg.contains('429')) return 'Demasiados intentos. Intenta más tarde.';
    return 'No se pudo iniciar sesión';
  }
}
