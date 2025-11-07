import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyecto_solicitudes/core/theme/app_colors.dart';
import 'package:proyecto_solicitudes/features/solicitudes/domain/estado.dart';

import '../../application/solicitudes_providers.dart';
import '../../data/mappers/solicitud_mapper.dart';
import '../tables/solicitudes_table_source.dart';
import '../widgets/solicitud_form_dialog.dart';

class SolicitudesPage extends ConsumerStatefulWidget {
  const SolicitudesPage({super.key});
  @override
  ConsumerState<SolicitudesPage> createState() => _SolicitudesPageState();
}

class _SolicitudesPageState extends ConsumerState<SolicitudesPage> {
  // Una sola instancia del DataTableSource
  late final SolicitudesDataSource _source = SolicitudesDataSource(
    solicitudes: const [],
    onEdit: (_) {},
    onDelete: (_) {},
  );

  @override
  Widget build(BuildContext context) {
    final listAsync = ref.watch(solicitudesProvider);
    final actions = ref.read(solicitudesActionsProvider.notifier);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Header
          Row(
            children: [
              const Text('Solicitudes', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
              const Spacer(),
              FilledButton.icon(
                onPressed: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  final result = await showDialog<SolicitudFormResult>(
                    context: context,
                    useRootNavigator: false,
                    barrierDismissible: false,
                    builder: (_) => const SolicitudFormDialog(),
                  );
                  if (result != null) {
                    await actions.crear(
                      titulo: result.titulo,
                      descripcion: result.descripcion,
                      categoria: result.categoria,
                    );
                    messenger.showSnackBar(const SnackBar(content: Text('Solicitud creada')));
                  }
                },
                style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(kPrimaryColor)),
                icon: const Icon(Icons.add),
                label: const Text('Nueva solicitud'),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Tabla
          Expanded(
            child: listAsync.when(
              data: (list) {
                final items = list.map(mapSolicitudFromJson).toList();

                _source.setRows(items);
                _source.setHandlers(
                    onEdit: (s) async {
                      final messenger = ScaffoldMessenger.of(context);
                      final updated = await showDialog<SolicitudFormResult>(
                        context: context,
                        useRootNavigator: false,
                        barrierDismissible: false,
                        builder: (_) => SolicitudFormDialog(
                          solicitudId: s.id,
                          tituloInicial: s.titulo,
                          descripcionInicial: s.descripcion,
                          categoriaInicial: s.categoria,
                          estadoInicial: s.estado.nameApi,
                        ),
                      );
                      if (updated != null) {
                        await actions.actualizar(
                          s.id,
                          titulo: updated.titulo,
                          descripcion: updated.descripcion,
                          categoria: updated.categoria,
                          estado: updated.estado ?? s.estado.nameApi,
                        );
                        messenger.showSnackBar(const SnackBar(content: Text('Solicitud actualizada')));
                      }
                    },
                    onDelete: (s) async {
                      final messenger = ScaffoldMessenger.of(context);
                      final ok = await showDialog<bool>(
                        context: context,
                        useRootNavigator: false,
                        builder: (dialogContext) => AlertDialog(
                          title: const Text('Eliminar solicitud'),
                          content: const Text('¿Seguro que deseas eliminar esta solicitud?'),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('Cancelar')),
                            FilledButton.tonal(onPressed: () => Navigator.pop(dialogContext, true), child: const Text('Eliminar')),
                          ],
                        ),
                      );
                      if (ok == true) {
                        try {
                          await actions.eliminar(s.id);
                          messenger.showSnackBar(const SnackBar(content: Text('Solicitud eliminada')));
                        } catch (e) {
                          messenger.showSnackBar(SnackBar(content: Text('No se pudo eliminar: $e')));
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
      columns: const [
        DataColumn(label: Text('Título')),
        DataColumn(label: Text('Estado')),
        DataColumn(label: Text('Categoría')),
        DataColumn(label: Text('Creado')),
        DataColumn(label: Text('Acciones')),
      ],
      source: _source,
    ),
  ),
);

              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }
}
