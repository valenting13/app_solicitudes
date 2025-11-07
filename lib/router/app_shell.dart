import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyecto_solicitudes/core/theme/app_colors.dart';
import 'models/nav_item.dart';
import 'widgets/side_menu.dart';
import 'widgets/side_drawer.dart';
import '../shared/app_providers.dart';

class AppShell extends ConsumerWidget {
  const AppShell({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAdmin = ref.watch(isAdminProvider);

    final items = <NavItem>[
      const NavItem('Solicitudes', Icons.description_outlined, '/solicitudes'),
      if (isAdmin) NavItem('Usuarios', Icons.group_outlined, '/usuarios'),
    ];

    final width = MediaQuery.sizeOf(context).width;
    final wide = width >= 1000;

    if (!wide) {
      return Scaffold(
        appBar: AppBar(backgroundColor: Colors.white),
        drawer: SideDrawer(items: items),
        body: child,
      );
    } else {
      return Scaffold(
        body: Row(
          children: [
            Container(
              width: 240,
              decoration: const BoxDecoration(color: kPrimaryColor),
              child: SideMenu(items: items),
            ),
            Expanded(child: child),
          ],
        ),
      );
    }
  }
}
