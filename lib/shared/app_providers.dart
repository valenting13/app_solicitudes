import 'package:flutter_riverpod/flutter_riverpod.dart';

class _AdminFlag extends Notifier<bool> {
  @override
  bool build() => false;
  void set(bool v) => state = v;
}

final isAdminProvider = NotifierProvider<_AdminFlag, bool>(_AdminFlag.new);
