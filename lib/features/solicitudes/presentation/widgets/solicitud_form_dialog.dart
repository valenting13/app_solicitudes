import 'package:flutter/material.dart';
import 'package:proyecto_solicitudes/core/theme/app_colors.dart';
import 'package:proyecto_solicitudes/core/theme/input_theme.dart';

const categoriasFijas = ['TI','Mantenimiento','Recursos Humanos','Infraestructura','Compras'];
const estados = ['PENDIENTE','EN_PROCESO','FINALIZADA','CANCELADA'];

class SolicitudFormResult {
  final String titulo;
  final String descripcion;
  final String? categoria;
  final String? estado;
  SolicitudFormResult({
    required this.titulo,
    required this.descripcion,
    this.categoria,
    this.estado,
  });
}

class SolicitudFormDialog extends StatefulWidget {
  const SolicitudFormDialog({
    super.key,
    this.solicitudId,
    this.tituloInicial,
    this.descripcionInicial,
    this.categoriaInicial,
    this.estadoInicial,
  });

  final int? solicitudId;
  final String? tituloInicial;
  final String? descripcionInicial;
  final String? categoriaInicial;
  final String? estadoInicial;

  bool get esEdicion => solicitudId != null;

  @override
  State<SolicitudFormDialog> createState() => _SolicitudFormDialogState();
}

class _SolicitudFormDialogState extends State<SolicitudFormDialog> {
  final _form = GlobalKey<FormState>();
  late final TextEditingController _tituloCtrl;
  late final TextEditingController _descCtrl;
  String? _categoria;
  String _estado = 'PENDIENTE';

  @override
  void initState() {
    super.initState();
    _tituloCtrl = TextEditingController(text: widget.tituloInicial ?? '');
    _descCtrl   = TextEditingController(text: widget.descripcionInicial ?? '');
    _categoria  = widget.categoriaInicial;
    _estado     = widget.estadoInicial ?? 'PENDIENTE';
  }

  @override
  void dispose() {
    _tituloCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text(widget.esEdicion ? 'Editar solicitud' : 'Nueva solicitud',
      style: TextStyle(
        fontWeight: FontWeight.bold

      ),
      ),
      content: Theme(
        data: Theme.of(context).copyWith(inputDecorationTheme: buildLoginInputTheme()),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: _form,
            child: SizedBox(
              width: 500,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _tituloCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Título',
                      hintText: 'Ej. Impresora no imprime',
                      counterText: '',
                    ),
                    maxLength: 50,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Este campo es requerido';
                      } else if (v.length > 50) {
                        return 'Máximo 50 caracteres';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _descCtrl,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'Descripción',
                      hintText: 'Describe el problema o solicitud...',
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Este campo es requerido'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String?>(
                    initialValue: _categoria,
                    dropdownColor: Colors.white,
                    isExpanded: true,
                    items: [
                      const DropdownMenuItem<String?>(value: null, child: Text('Sin categoría')),
                      ...categoriasFijas.map((c) => DropdownMenuItem<String?>(value: c, child: Text(c))),
                    ],
                    decoration: const InputDecoration(labelText: 'Categoría'),
                    onChanged: (v) => setState(() => _categoria = v),
                  ),
                  const SizedBox(height: 12),
          
        
                  if (widget.esEdicion)
                    DropdownButtonFormField<String>(
                      initialValue: _estado,
                      isExpanded: true,
                      dropdownColor: Colors.white,
                      items: estados
                          .map((e) => DropdownMenuItem<String>(value: e, child: Text(e)))
                          .toList(),
                      decoration: const InputDecoration(labelText: 'Estado'),
                      onChanged: (v) => setState(() => _estado = v ?? 'PENDIENTE'),
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
            if (!_form.currentState!.validate()) return;

            final result = SolicitudFormResult(
              titulo: _tituloCtrl.text.trim(),
              descripcion: _descCtrl.text.trim(),
              categoria: _categoria,
              // Si es creación, no usamos estado (backend fija PENDIENTE)
              estado: widget.esEdicion ? _estado : null,
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
