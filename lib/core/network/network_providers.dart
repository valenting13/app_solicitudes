import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dio_client.dart';
import '../storage/token_storage.dart';
import '../../features/auth/application/auth_state.dart';
import '../../shared/app_providers.dart';

// Si quieres, mantén el baseUrl aquí
const String apiBaseUrl =
    String.fromEnvironment('API_BASE_URL', defaultValue: 'https://backend-ins.onrender.com');

final tokenStorageProvider = Provider((_) => TokenStorage());

// Estos imports son para notificar logout y quitar admin en 401:


final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient(
    apiBaseUrl,
    onUnauthorized: () async {
      ref.read(isLoggedInProvider.notifier).setLoggedIn(false);
      ref.read(isAdminProvider.notifier).set(false);
    },
  );
});
