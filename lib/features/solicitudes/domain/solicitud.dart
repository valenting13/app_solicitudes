import 'estado.dart';

class Solicitud {
  final int id;
  final String titulo;
  final String descripcion;
  final Estado estado;
  final String? categoria;
  final DateTime creado;

  const Solicitud({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.estado,
    required this.categoria,
    required this.creado,
  });
}
