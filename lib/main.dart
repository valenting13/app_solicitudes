import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'router/app_router.dart';
import 'package:flutter_web_plugins/url_strategy.dart';


import 'package:proyecto_solicitudes/core/theme/app_colors.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setUrlStrategy(PathUrlStrategy());
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = createRouter(ref);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Web – Proyecto Demo',
      routerConfig: router,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: kScaffoldLight,
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
    );
  }
}
