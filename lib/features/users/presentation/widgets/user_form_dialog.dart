// lib/features/users/presentation/widgets/user_form_dialog.dart
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_solicitudes/core/theme/app_colors.dart';
import 'package:proyecto_solicitudes/core/theme/input_theme.dart';

const rolesFijos = ['ADMIN', 'AGENTE', 'COLABORADOR'];

class UserFormResult {
  final String email;
  final String nombre;
  final String? password;
  final String rol;
  final bool activo;

  UserFormResult({
    required this.email,
    required this.nombre,
    required this.password,
    required this.rol,
    required this.activo,
  });
}

class UserFormDialog extends StatefulWidget {
  const UserFormDialog({
    super.key,
    this.userId,
    this.emailInicial,
    this.nombreInicial,
    this.rolInicial,
    this.activoInicial,
  });

  final String? userId;
  final String? emailInicial;
  final String? nombreInicial;
  final String? rolInicial;
  final bool? activoInicial;

  bool get esEdicion => userId != null;

  @override
  State<UserFormDialog> createState() => _UserFormDialogState();
}

class _UserFormDialogState extends State<UserFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _emailCtrl;
  late final TextEditingController _nombreCtrl;
  late final TextEditingController _passwordCtrl;

  late String _rol;
  late bool _activo;

  @override
  void initState() {
    super.initState();
    _emailCtrl = TextEditingController(text: widget.emailInicial ?? '');
    _nombreCtrl = TextEditingController(text: widget.nombreInicial ?? '');
    _passwordCtrl = TextEditingController();

    _rol = widget.rolInicial ?? 'COLABORADOR';
    _activo = widget.activoInicial ?? true;
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _nombreCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text(widget.esEdicion ? 'Editar usuario' : 'Nuevo usuario',
      style: TextStyle(
        fontWeight: FontWeight.bold
      ),
      ),
      content: Theme(
        data: Theme.of(context).copyWith(inputDecorationTheme: buildLoginInputTheme()),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: _formKey,
            child: SizedBox(
              width: 500,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _emailCtrl,
                    decoration: const InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) {
                      if( !EmailValidator.validate(v ?? '') ) return 'Email no válido';

                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _nombreCtrl,
                    decoration: const InputDecoration(labelText: 'Nombre'),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'El nombre es requerido' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _passwordCtrl,
                    decoration: InputDecoration(
                      labelText:
                          widget.esEdicion ? 'Contraseña (opcional)' : 'Contraseña',
                      hintText: widget.esEdicion
                          ? 'Deja en blanco para no cambiarla'
                          : null,
                    ),
                    obscureText: true,
                    validator: (v) {
                      if (!widget.esEdicion) {
                        if (v == null || v.trim().isEmpty) {
                          return 'La contraseña es requerida';
                        }
                        if (v.length < 6) {
                          return 'Debe tener al menos 6 caracteres';
                        }
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: _rol,
                    isExpanded: true,
                    dropdownColor: Colors.white,
                    items: rolesFijos
                        .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                        .toList(),
                    decoration: const InputDecoration(labelText: 'Rol'),
                    onChanged: (v) => setState(() => _rol = v ?? 'COLABORADOR'),
                  ),
                  const SizedBox(height: 12),
                  SwitchListTile(
                    activeThumbColor: kPrimaryColor,
                    title: const Text('Activo'),
                    contentPadding: EdgeInsets.zero,
                    value: _activo,
                    onChanged: (v) => setState(() => _activo = v),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () {
            if (!_formKey.currentState!.validate()) return;

            final passText = _passwordCtrl.text.trim();
            final password =
                (widget.esEdicion && passText.isEmpty) ? null : passText;

            final result = UserFormResult(
              email: _emailCtrl.text.trim(),
              nombre: _nombreCtrl.text.trim(),
              password: password,
              rol: _rol,
              activo: _activo,
            );

            Navigator.pop(context, result);
          },
          
          style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(kPrimaryColor)),
          child: Text(widget.esEdicion ? 'Guardar cambios' : 'Crear'),
        ),
      ],
    );
  }
}
