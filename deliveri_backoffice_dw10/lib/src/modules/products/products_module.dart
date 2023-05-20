import 'package:flutter_modular/flutter_modular.dart';
import 'details/product_detail_controller.dart';
import 'details/product_detail_page.dart';
import 'home/product_controller.dart';
import 'home/products_page.dart';

class ProductsModule extends Module {
  @override
  List<Bind> get binds => [
        Bind.lazySingleton<ProductController>(
          (i) => ProductController(i()),
        ),
        Bind.lazySingleton<ProductDetailController>(
          (i) => ProductDetailController(i()),
        ),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(
          '/',
          child: (context, args) => const ProductsPage(),
        ),
        ChildRoute(
          '/detail',
          child: (context, args) => const ProductDetailPage(productId: null),
        ),
      ];
}
