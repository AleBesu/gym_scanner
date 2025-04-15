import 'package:flutter_riverpod/flutter_riverpod.dart';

final yearSelectedIndexProvider = StateProvider.autoDispose<int>(
  (ref) {
    return 0;
  },
);
