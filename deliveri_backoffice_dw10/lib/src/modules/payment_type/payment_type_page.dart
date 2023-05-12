import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

import '../../core/ui/helpers/loader.dart';
import '../../core/ui/helpers/messages.dart';
import 'payment_type_controller.dart';
import 'widgets/payment_type_header.dart';
import 'widgets/payment_type_item.dart';

class PaymentTypePage extends StatefulWidget {
  const PaymentTypePage({Key? key}) : super(key: key);

  @override
  State<PaymentTypePage> createState() => _PaymentTypePageState();
}

class _PaymentTypePageState extends State<PaymentTypePage>
    with Loader, Messages {
  final controller = Modular.get<PaymentTypeController>();

  final disposers = <ReactionDisposer>[];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final statusDisposer = reaction(
        (_) => controller.status,
        (status) {
          switch (status) {
            case PaymentTypeStatus.initial:
              break;
            case PaymentTypeStatus.loading:
              showLoader();
              break;
            case PaymentTypeStatus.loaded:
              hideLoader();
              break;
            case PaymentTypeStatus.error:
              hideLoader();
              showError(
                controller.errorMessage ?? 'Erro ao buscar formas de pagamento',
              );
              break;
            case PaymentTypeStatus.addOrUpdatePayment:
              hideLoader();
              shoeAddAlllUpdatePayment();
              break;
          }
        },
      );
      disposers.addAll([statusDisposer]);
      controller.loadPayments();
    });
  }

  void shoeAddAlllUpdatePayment() {
    showDialog(
      context: context,
      builder: (context) {
        return Material(
          color: Colors.black26,
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: Colors.white,
            elevation: 10,
            child: Text('Modal X'),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[50],
      padding: const EdgeInsets.only(left: 40, top: 40, right: 40),
      child: Column(
        children: [
          PaymentTypeHeader(controller: controller),
          const SizedBox(
            height: 50,
          ),
          Expanded(child: Observer(
            builder: (_) {
              return GridView.builder(
                itemCount: controller.paymentTypes.length,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 680,
                  crossAxisSpacing: 10,
                  mainAxisExtent: 120,
                  mainAxisSpacing: 20,
                ),
                itemBuilder: (context, index) {
                  final paymentTypeModel = controller.paymentTypes[index];
                  return PaymentTypeItem(
                    controller: controller,
                    payment: paymentTypeModel,
                  );
                },
              );
            },
          )),
        ],
      ),
    );
  }
}
