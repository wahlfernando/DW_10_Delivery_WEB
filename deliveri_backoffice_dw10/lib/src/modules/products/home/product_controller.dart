import 'dart:developer';

import 'package:mobx/mobx.dart';

import '../../../models/product_model.dart';
import '../../../repositories/products/product_repository.dart';
part 'product_controller.g.dart';

enum ProductStateStatus {
  initial,
  loading,
  loaded,
  error,
  addOrUpdateProduct,
}

class ProductController = ProductControllerBase with _$ProductController;

abstract class ProductControllerBase with Store {
  final ProductRepository _productRepository;

  ProductControllerBase(this._productRepository);

  @readonly
  var _status = ProductStateStatus.initial;

  @readonly
  var _products = <ProductModel>[];

  @readonly
  String? _filterName;

  @readonly
  ProductModel? _producSelected;

  @action
  Future<void> loadProducts() async {
    try {
      _status = ProductStateStatus.loading;
      _products = await _productRepository.findAll(_filterName);
      _status = ProductStateStatus.loaded;
    } catch (e, s) {
      log('Erro ao buscar produtos', error: e, stackTrace: s);
      _status = ProductStateStatus.error;
    }
  }

  Future<void> filterByName(String name) async {
    _filterName = name;
    await loadProducts();
  }

  Future<void> addProduct() async {
    _status = ProductStateStatus.loading;
    await Future.delayed(Duration.zero);
    _producSelected = null;
    _status = ProductStateStatus.addOrUpdateProduct;
  }

  Future<void> editProduct(ProductModel productModel) async {
    _status = ProductStateStatus.loading;
    await Future.delayed(Duration.zero);
    _producSelected = productModel;
    _status = ProductStateStatus.addOrUpdateProduct;
  }
}
