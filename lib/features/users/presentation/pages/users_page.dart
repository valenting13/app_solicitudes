// lib/features/users/presentation/pages/users_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyecto_solicitudes/core/theme/app_colors.dart';
import 'package:proyecto_solicitudes/features/users/data/mappers/usuario_mapper.dart';
import 'package:proyecto_solicitudes/features/users/domain/user.dart';
import 'package:proyecto_solicitudes/features/users/presentation/tables/users_table_source.dart';

import '../../application/users_providers.dart';
import '../widgets/user_form_dialog.dart';

class UsersPage extends ConsumerStatefulWidget {
  const UsersPage({super.key});

  @override
  ConsumerState<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends ConsumerState<UsersPage> {
  late final UsersDataSource _source = UsersDataSource(
    users: const [],
    onEdit: (_) {},
    onDelete: (_) {},
  );

  int _sortColumnIndex = 0;

  void _sort<T extends Comparable>(
    Comparable<T> Function(User u) getField,
    int columnIndex,
    bool ascending,
  ) {
    _source.sort<T>(getField, ascending);
    setState(() => _sortColumnIndex = columnIndex);
  }

  @override
  Widget build(BuildContext context) {
    final usersAsync = ref.watch(usersProvider);
    final actions = ref.read(usersActionsProvider.notifier);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Header
          Row(
            children: [
              const Text('Usuarios',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
              const Spacer(),
              FilledButton.icon(
                onPressed: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  final result = await showDialog<UserFormResult>(
                    context: context,
                    useRootNavigator: false,
                    barrierDismissible: false,
                    builder: (dialogCtx) => const UserFormDialog(),
                  );

                  if (result != null) {
                    try {
                      await actions.crear(
                        email: result.email,
                        nombre: result.nombre,
                        password: result.password!,
                        rol: result.rol,
                        activo: result.activo,
                      );
                      messenger.showSnackBar(
                        const SnackBar(content: Text('Usuario creado')),
                      );
                    } catch (e) {
                      messenger.showSnackBar(
                        SnackBar(content: Text('Error al crear: $e')),
                      );
                    }
                  }
                },
                style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(kPrimaryColor)),
                icon: const Icon(Icons.add),
                label: const Text('Nuevo usuario'),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Expanded(
            child: usersAsync.when(
              data: (list) {
                final items = list.map(mapUser).toList();

                _source.setRows(items);
                _source.setHandlers(
                  onEdit: (u) async {
                    final messenger = ScaffoldMessenger.of(context);
                    final result = await showDialog<UserFormResult>(
                      context: context,
                      useRootNavigator: false,
                      barrierDismissible: false,
                      builder: (dialogCtx) => UserFormDialog(
                        userId: u.id,
                        emailInicial: u.email,
                        nombreInicial: u.nombre,
                        rolInicial: u.rol,
                        activoInicial: u.activo,
                      ),
                    );

                    if (result != null) {
                      try {
                        await actions.actualizar(
                          u.id,
                          email: result.email,
                          nombre: result.nombre,
                          password: result.password,
                          rol: result.rol,
                          activo: result.activo,
                        );
                        messenger.showSnackBar(
                          const SnackBar(content: Text('Usuario actualizado')),
                        );
                      } catch (e) {
                        messenger.showSnackBar(
                          SnackBar(content: Text('Error al actualizar: $e')),
                        );
                      }
                    }
                  },
                  onDelete: (u) async {
                    final messenger = ScaffoldMessenger.of(context);
                    final ok = await showDialog<bool>(
                      context: context,
                      useRootNavigator: false,
                      builder: (dialogCtx) => AlertDialog(
                        title: const Text('Eliminar usuario'),
                        content: Text(
                            '¿Seguro que deseas eliminar al usuario "${u.email}"?'),
                        actions: [
                          TextButton(
                            onPressed: () =>
                                Navigator.pop(dialogCtx, false),
                            child: const Text('Cancelar'),
                          ),
                          FilledButton.tonal(
                            onPressed: () =>
                                Navigator.pop(dialogCtx, true),
                            child: const Text('Eliminar'),
                          ),
                        ],
                      ),
                    );

                    if (ok == true) {
                      try {
                        await actions.eliminar(u.id);
                        messenger.showSnackBar(
                          const SnackBar(content: Text('Usuario eliminado')),
                        );
                      } catch (e) {
                        messenger.showSnackBar(
                          SnackBar(content: Text('Error al eliminar: $e')),
                        );
                      }
                    }
                  },
                );

              return Theme(
              data: Theme.of(context).copyWith(
                // Color de la "tarjeta" que envuelve al PaginatedDataTable
                cardColor: Colors.white,
                cardTheme: const CardThemeData(
                  color: Colors.white,
                  surfaceTintColor: Colors.white, // para Material 3, quita el tinte
                ),

                // Estilo de la DataTable (encabezados, filas, etc.)
                dataTableTheme: DataTableThemeData(
                  headingRowColor: WidgetStateProperty.resolveWith<Color?>(
                    (states) => kPrimaryColor, // tu azul del header
                  ),
                  dataRowColor: WidgetStateProperty.resolveWith<Color?>(
                    (states) {
                      if (states.contains(WidgetState.selected)) {
                        return kBorderColor; // fila seleccionada
                      }
                      return Colors.white;
                    },
                  ),
                  headingTextStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  dataTextStyle: const TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              child: SizedBox(
                width: double.infinity,
                child: PaginatedDataTable(
                  header: const Text(
                    '',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  showFirstLastButtons: true,
                  rowsPerPage: 5,
                  dataRowMinHeight: 36,
                  sortColumnIndex: _sortColumnIndex,
                  columns: [
                    DataColumn(
                      label: const Text('Email'),
                      onSort: (i, asc) =>
                          _sort<String>((u) => u.email.toLowerCase(), i, asc),
                    ),
                    DataColumn(
                      label: const Text('Nombre'),
                      onSort: (i, asc) =>
                          _sort<String>((u) => u.nombre.toLowerCase(), i, asc),
                    ),
                    DataColumn(
                      label: const Text('Rol'),
                      onSort: (i, asc) =>
                          _sort<String>((u) => u.rol.toLowerCase(), i, asc),
                    ),
                    const DataColumn(label: Text('Activo')),
                    const DataColumn(label: Text('Acciones')),
                  ],
                  source: _source,
                ),
                )
                );
              },
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }
}



