import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'not_found_page.dart';
import 'package:proyecto_solicitudes/features/auth/presentation/pages/login_page.dart';
import 'package:proyecto_solicitudes/shared/app_providers.dart';

import '../features/auth/application/auth_providers.dart';
import '../features/auth/application/auth_state.dart';
import 'router_refresh.dart';
import 'app_shell.dart';
import '../features/solicitudes/presentation/pages/solicitudes_page.dart';
import '../features/users/presentation/pages/users_page.dart';

GoRouter createRouter(WidgetRef ref) {
  ref.watch(authInitProvider);

  return GoRouter(
    initialLocation: '/login',
    refreshListenable: ref.read(routerNotifierProvider),
    redirect: (ctx, state) {
      final logged = ref.read(isLoggedInProvider);
      final loggingIn = state.matchedLocation == '/login';
      if (!logged && !loggingIn) return '/login';
      if (logged && loggingIn) return '/solicitudes';
      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (_, __) => const LoginPage()),
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            name: 'solicitudes',
            path: '/solicitudes',
            pageBuilder: (_, __) => const NoTransitionPage(child: SolicitudesPage()),
          ),
          GoRoute(
            name: '/usuarios',
            path: '/usuarios',
            redirect: (ctx, state) {
              // Guardia: si no es admin, reenvía a /solicitudes
              final isAdmin = ref.read(isAdminProvider);
              return isAdmin ? null : '/solicitudes';
            },
            pageBuilder: (_, __) => const NoTransitionPage(child: UsersPage()),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) {
      final loc = state.uri.toString();
      // Lo mostramos dentro del mismo shell (panel con menú)
      return AppShell(
        child: NotFoundPage(location: loc),
      );
    },
  );
}
