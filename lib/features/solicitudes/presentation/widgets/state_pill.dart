import 'package:flutter/material.dart';
import '../../domain/estado.dart';

class EstadoPill extends StatelessWidget {
  const EstadoPill({super.key, required this.estado});
  final Estado estado;

  @override
  Widget build(BuildContext context) {
    final (text, bg, border, txtColor) = switch (estado) {
      Estado.pendiente =>
        ('PENDIENTE', const Color(0xFFFFF3E0), const Color(0xFFFFCC80), const Color(0xFFB26A00)),
      Estado.enProceso =>
        ('EN PROCESO', const Color(0xFFE3F2FD), const Color(0xFF90CAF9), const Color(0xFF0D47A1)),
      Estado.finalizada =>
        ('FINALIZADA', const Color(0xFFE8F5E9), const Color(0xFFA5D6A7), const Color(0xFF1B5E20)),
      Estado.cancelada =>
        ('CANCELADA', const Color(0xFFFFEBEE), const Color(0xFFEF9A9A), const Color(0xFFB71C1C)),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      width: 115,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
      ),
      child: Center(heightFactor: 1.1,child: Text(text, style: TextStyle(fontWeight: FontWeight.w600, color: txtColor))),
    );
  }
}
