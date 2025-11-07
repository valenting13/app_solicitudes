class AuthUser {
  final String id;
  final String email;
  final String nombre;
  final String rol;
  final bool activo;

  AuthUser({required this.id, required this.email, required this.nombre, required this.rol, required this.activo});

  factory AuthUser.fromJson(Map<String, dynamic> j) => AuthUser(
    id: j['id'] as String,
    email: j['email'] as String,
    nombre: j['nombre'] as String,
    rol: j['rol'] as String,
    activo: j['activo'] as bool,
  );
}
