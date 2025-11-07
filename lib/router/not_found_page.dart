// lib/router/not_found_page.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:proyecto_solicitudes/core/theme/app_colors.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key, required this.location});

  final String location;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off, size: 64),
            const SizedBox(height: 16),
            const Text(
              'Página no encontrada',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'La ruta que intentaste abrir no existe:',
            ),
            const SizedBox(height: 4),
            Text(
              location,
              style: const TextStyle(
                fontFamily: 'monospace',
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => context.go('/solicitudes'),
              style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(kPrimaryColor)),
              child: const Text('Volver a Solicitudes'),
              
            ),
          ],
        ),
      ),
    );
  }
}
