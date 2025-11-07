import 'package:flutter/material.dart';
import 'package:proyecto_solicitudes/features/users/domain/user.dart';


class UsersDataSource extends DataTableSource {
  UsersDataSource({
    required List<User> users,
    required this.onEdit,
    required this.onDelete,
  }) : _rows = List<User>.from(users);

  List<User> _rows;
  void Function(User) onEdit;
  void Function(User) onDelete;

  void setRows(List<User> rows) {
    _rows = List<User>.from(rows);
    notifyListeners();
  }

  void setHandlers({
    required void Function(User) onEdit,
    required void Function(User) onDelete,
  }) {
    this.onEdit = onEdit;
    this.onDelete = onDelete;
  }

  void sort<T extends Comparable>(
      Comparable<T> Function(User u) getField, bool ascending) {
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
    final u = _rows[index];

    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text(u.email)),
        DataCell(Text(u.nombre)),
        DataCell(Text(u.rol)),
        DataCell(Icon(
          u.activo ? Icons.check_circle : Icons.cancel,
          size: 18,
        )),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                tooltip: 'Editar',
                icon: const Icon(Icons.edit_outlined),
                onPressed: () => onEdit(u),
              ),
              IconButton(
                tooltip: 'Eliminar',
                icon: const Icon(Icons.delete_outline),
                onPressed: () => onDelete(u),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _rows.length;

  @override
  int get selectedRowCount => 0;
}