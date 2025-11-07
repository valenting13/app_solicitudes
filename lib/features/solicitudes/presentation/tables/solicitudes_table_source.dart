import 'package:flutter/material.dart';
import 'package:proyecto_solicitudes/features/solicitudes/presentation/widgets/state_pill.dart';
import '../../domain/solicitud.dart';
import '../utils/date_format.dart';

typedef SolicitudHandler = void Function(Solicitud s);

class SolicitudesDataSource extends DataTableSource {
  SolicitudesDataSource({
    required List<Solicitud> solicitudes,
    required this.onEdit,
    required this.onDelete,
  }) : _rows = List<Solicitud>.from(solicitudes);

  List<Solicitud> _rows;
  SolicitudHandler onEdit;
  SolicitudHandler onDelete;

  void setRows(List<Solicitud> rows) {
    _rows = List<Solicitud>.from(rows);
    notifyListeners();
  }

  void setHandlers({required SolicitudHandler onEdit, required SolicitudHandler onDelete}) {
    this.onEdit = onEdit;
    this.onDelete = onDelete;
  }

  void sort<T extends Comparable>(Comparable<T> Function(Solicitud s) getField, bool ascending) {
    _rows.sort((a, b) {
      final aVal = getField(a);
      final bVal = getField(b);
      final result = Comparable.compare(aVal, bVal);
      return ascending ? result : -result;
    });
    notifyListeners();
  }

  @override
  DataRow? getRow(int index) {
    if (index >= _rows.length) return null;
    final s = _rows[index];

    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text(s.titulo)),
        DataCell(EstadoPill(estado: s.estado)),
        DataCell(Text(s.categoria ?? '—')),
        DataCell(Text(formatDateTime(s.creado))),
        DataCell(Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(tooltip: 'Editar', onPressed: () => onEdit(s), icon: const Icon(Icons.edit_outlined)),
            IconButton(tooltip: 'Eliminar', onPressed: () => onDelete(s), icon: const Icon(Icons.delete_outline)),
          ],
        )),
      ],
    );
  }

  @override bool get isRowCountApproximate => false;
  @override int get rowCount => _rows.length;
  @override int get selectedRowCount => 0;
}
