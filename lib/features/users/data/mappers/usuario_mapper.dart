

import 'package:proyecto_solicitudes/features/users/domain/user.dart';

User mapUser(Map<String, dynamic> m) {
  return User(
    id: m['id'] as String,
    email: m['email'] as String,
    nombre: m['nombre'] as String,
    rol: m['rol'] as String,
    activo: m['activo'] as bool,
  );
}
