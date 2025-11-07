import 'package:flutter/material.dart';
import 'package:proyecto_solicitudes/core/theme/app_colors.dart';
import '../models/nav_item.dart';
import 'side_menu.dart';

class SideDrawer extends StatelessWidget {
  const SideDrawer({super.key, required this.items});
  final List<NavItem> items;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: kPrimaryColor,
      child: SafeArea(child: SideMenu(items: items)),
    );
  }
}
