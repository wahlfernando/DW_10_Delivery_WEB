import 'package:flutter_modular/flutter_modular.dart';

import '../../core/rest_client/custon_dio.dart';
import '../../core/storage/session_storage.dart';
import '../../core/storage/storage.dart';

class CoreModule extends Module {
  @override
  List<Bind> get binds => [
        Bind.lazySingleton<Storage>((i) => SessionStorage(), export: true),
        Bind.lazySingleton<CustonDio>((i) => CustonDio(), export: true),
      ];
}
