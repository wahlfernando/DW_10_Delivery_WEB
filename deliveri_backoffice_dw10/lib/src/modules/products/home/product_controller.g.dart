// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ProductController on ProductControllerBase, Store {
  late final _$_statusAtom =
      Atom(name: 'ProductControllerBase._status', context: context);

  ProductStateStatus get status {
    _$_statusAtom.reportRead();
    return super._status;
  }

  @override
  ProductStateStatus get _status => status;

  @override
  set _status(ProductStateStatus value) {
    _$_statusAtom.reportWrite(value, super._status, () {
      super._status = value;
    });
  }

  late final _$_productsAtom =
      Atom(name: 'ProductControllerBase._products', context: context);

  List<ProductModel> get products {
    _$_productsAtom.reportRead();
    return super._products;
  }

  @override
  List<ProductModel> get _products => products;

  @override
  set _products(List<ProductModel> value) {
    _$_productsAtom.reportWrite(value, super._products, () {
      super._products = value;
    });
  }

  late final _$_filterNameAtom =
      Atom(name: 'ProductControllerBase._filterName', context: context);

  String? get filterName {
    _$_filterNameAtom.reportRead();
    return super._filterName;
  }

  @override
  String? get _filterName => filterName;

  @override
  set _filterName(String? value) {
    _$_filterNameAtom.reportWrite(value, super._filterName, () {
      super._filterName = value;
    });
  }

  late final _$_producSelectedAtom =
      Atom(name: 'ProductControllerBase._producSelected', context: context);

  ProductModel? get producSelected {
    _$_producSelectedAtom.reportRead();
    return super._producSelected;
  }

  @override
  ProductModel? get _producSelected => producSelected;

  @override
  set _producSelected(ProductModel? value) {
    _$_producSelectedAtom.reportWrite(value, super._producSelected, () {
      super._producSelected = value;
    });
  }

  late final _$loadProductsAsyncAction =
      AsyncAction('ProductControllerBase.loadProducts', context: context);

  @override
  Future<void> loadProducts() {
    return _$loadProductsAsyncAction.run(() => super.loadProducts());
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
