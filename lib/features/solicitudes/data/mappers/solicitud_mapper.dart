import 'package:proyecto_solicitudes/features/solicitudes/domain/estado.dart';
import 'package:proyecto_solicitudes/features/solicitudes/domain/solicitud.dart';


Solicitud mapSolicitudFromJson(Map<String, dynamic> m) {
  return Solicitud(
    id: m['id'] as int,
    titulo: m['titulo'] as String,
    descripcion: m['descripcion'] as String,
    estado: estadoFromApi(m['estado'] as String),
    categoria: m['categoria'] as String?,
    creado: DateTime.parse(m['fecha_creacion'] as String),
  );
}
