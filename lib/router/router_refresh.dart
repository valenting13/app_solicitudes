import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/auth/application/auth_state.dart';

/// Notifica a GoRouter cuando cambia el estado de login.
class RouterNotifier extends ChangeNotifier {
  RouterNotifier(this.ref) {
    _sub = ref.listen<bool>(
      isLoggedInProvider,
      (prev, next) => notifyListeners(),
      fireImmediately: false,
    );
  }

  final Ref ref;
  late final ProviderSubscription<bool> _sub;

  @override
  void dispose() {
    _sub.close();
    super.dispose();
  }
}

final routerNotifierProvider = Provider<RouterNotifier>((ref) {
  final rn = RouterNotifier(ref);
  ref.onDispose(rn.dispose);
  return rn;
});
