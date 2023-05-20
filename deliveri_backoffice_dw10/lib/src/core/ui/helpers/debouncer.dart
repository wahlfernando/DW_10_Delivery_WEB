import 'dart:async';

import 'package:flutter/cupertino.dart';

class Debouncer {
  final int milisseconds;
  Timer? _timer;

  Debouncer({
    required this.milisseconds,
  });

  void call(VoidCallback callback) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milisseconds), callback);
  }
}
