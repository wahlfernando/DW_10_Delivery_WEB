import 'package:flutter/material.dart';

import '../../../core/ui/widgets/base_header.dart';
import '../payment_type_controller.dart';

class PaymentTypeHeader extends StatelessWidget {

  final PaymentTypeController controller;

  const PaymentTypeHeader({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseHeader(
      title: 'ADMINISTRAR FORMA DE PAGAMENTO',
      buttonLabel: 'ADICIONAR',
      buttonPressed: () {
        controller.addPayment();
      },
      filterWidget: DropdownButton<bool?>(
        value: null,
        items: const [
          DropdownMenuItem(
            value: null,
            child: Text('Todos'),
          ),
          DropdownMenuItem(
            value: true,
            child: Text('Ativos'),
          ),
          DropdownMenuItem(
            value: false,
            child: Text('Inativos'),
          ),
        ],
        onChanged: (value) {
          
        },
      ),
    );
  }
}
