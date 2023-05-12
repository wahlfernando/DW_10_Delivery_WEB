import 'dart:developer';

import 'package:mobx/mobx.dart';

import '../../models/payment_type_model.dart';
import '../../repositories/payment_type/payment_type_repository.dart';
part 'payment_type_controller.g.dart';

enum PaymentTypeStatus {
  initial,
  loading,
  loaded,
  error,
  addOrUpdatePayment,
}

class PaymentTypeController = PaymentTypeControllerBase
    with _$PaymentTypeController;

abstract class PaymentTypeControllerBase with Store {
  final PaymentTypeRepository _paymentTypeRepository;

  @readonly
  var _status = PaymentTypeStatus.initial;

  @readonly
  var _paymentTypes = <PaymentTypeModel>[];

  @readonly
  String? _errorMessage;

  PaymentTypeModel? _paymentTypeSelected;

  PaymentTypeControllerBase(this._paymentTypeRepository);

  @action
  Future<void> loadPayments() async {
    try {
      _status = PaymentTypeStatus.loading;
      _paymentTypes = await _paymentTypeRepository.findAll(null);
      _status = PaymentTypeStatus.loaded;
    } catch (e, s) {
      log('Erro ao carregar as formas de pagaento!', error: e, stackTrace: s);
      _status = PaymentTypeStatus.error;
      _errorMessage = 'Erro ao carregar as formas de pagaento!';
    }
  }

  @action
  void addPayment() async {
    _status = PaymentTypeStatus.loading;
    await Future.delayed(Duration.zero);
    _paymentTypeSelected = null;
     _status = PaymentTypeStatus.addOrUpdatePayment;
  }

  @action
  void editPayment(PaymentTypeModel paymanet) async {
    _status = PaymentTypeStatus.loading;
    await Future.delayed(Duration.zero);
    _paymentTypeSelected = paymanet;
     _status = PaymentTypeStatus.addOrUpdatePayment;
  }
}
