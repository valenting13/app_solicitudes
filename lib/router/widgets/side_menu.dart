import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:proyecto_solicitudes/features/auth/application/auth_providers.dart';
import '../models/nav_item.dart';

class SideMenu extends ConsumerWidget {
  const SideMenu({super.key, required this.items});
  final List<NavItem> items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = GoRouter.of(context);
    final location = router.routeInformationProvider.value.uri.path;
    final controller = ref.watch(loginControllerProvider.notifier);

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 12),
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Panel INS',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        for (final it in items)
          ListTile(
            leading: Icon(it.icon, color: Colors.white),
            title: Text(it.label, style: const TextStyle(color: Colors.white)),
            selected: location.startsWith(it.path),
            onTap: () {
              Navigator.of(context).maybePop();
              context.go(it.path);
            },
          ),
        IconButton(
          tooltip: 'Cerrar sesión',
          icon: const Icon(Icons.logout),
          color: Colors.white,
          onPressed: () async{await controller.logout();}) ,
        
      ],
    );
  }
}
