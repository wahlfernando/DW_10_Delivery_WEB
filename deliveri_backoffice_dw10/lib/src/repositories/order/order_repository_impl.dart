import 'dart:developer';

import 'package:dio/dio.dart';

import '../../core/exceptions/repository_exception.dart';
import '../../core/rest_client/custon_dio.dart';
import '../../models/orders/order_status.dart';
import '../../models/orders/order_model.dart';
import './order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  final CustonDio _dio;

  OrderRepositoryImpl(this._dio);

  @override
  Future<void> changeStatus(int id, OrderStatus status) async {
    try {
      await _dio.auth().put(
        '/orders/$id',
        data: {
          'status': status.acronym,
        },
      );
    } on DioError catch (e, s) {
      log(
        'Erro ao laterar status do pedido para ${status.acronym}',
        error: e,
        stackTrace: s,
      );
      throw RepositoryException(
        message: 'Erro ao laterar status do pedido para ${status.acronym}',
      );
    }
  }

  @override
  Future<List<OrderModel>> findAllOrders(
    DateTime date, [
    OrderStatus? status,
  ]) async {
    try {
      final orderResposnse = await _dio.auth().get(
        '/orders',
        queryParameters: {
          'date': date.toIso8601String(),
          if (status != null) 'status': status.acronym,
        },
      );
      return orderResposnse.data.map<OrderModel>((o) => OrderModel.fromMap(o)).toList();
    } on DioError catch (e, s) {
      log(
        'Erro ao buscar pedidos',
        error: e,
        stackTrace: s,
      );
      throw RepositoryException(
        message: 'Erro ao buscar pedidos',
      );
    }
  }

  @override
  Future<OrderModel> getById(int id) async {
    try {
      final orderResposnse = await _dio.auth().get(
            '/orders/$id',
          );
      return OrderModel.fromMap(orderResposnse.data);
    } on DioError catch (e, s) {
      log(
        'Erro ao buscar pedido',
        error: e,
        stackTrace: s,
      );
      throw RepositoryException(
        message: 'Erro ao buscar pedido',
      );
    }
  }
}
