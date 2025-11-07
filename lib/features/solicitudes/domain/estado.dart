enum Estado { pendiente, enProceso, finalizada, cancelada }

extension EstadoApi on Estado {
  String get nameApi => switch (this) {
        Estado.pendiente => 'PENDIENTE',
        Estado.enProceso => 'EN_PROCESO',
        Estado.finalizada => 'FINALIZADA',
        Estado.cancelada => 'CANCELADA',
      };
}

Estado estadoFromApi(String v) {
  switch (v) {
    case 'PENDIENTE':
      return Estado.pendiente;
    case 'EN_PROCESO':
      return Estado.enProceso;
    case 'FINALIZADA':
      return Estado.finalizada;
    case 'CANCELADA':
      return Estado.cancelada;
    default:
      return Estado.pendiente;
  }
}
