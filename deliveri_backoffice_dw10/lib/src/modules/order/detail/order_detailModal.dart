import 'package:flutter/material.dart';

import '../../../core/extensions/format_extensions.dart';
import '../../../core/ui/helpers/size_extensions.dart';
import '../../../core/ui/styles/text_styles.dart';
import '../../../dto/order/order_dto.dart';
import '../widget/order_controller.dart';
import 'widgets/order_botton_bar.dart';
import 'widgets/order_info_title.dart';
import 'widgets/order_product_item.dart';

class OrderDetailModal extends StatefulWidget {
  final OrderController controller;
  final OrderDto order;
  const OrderDetailModal({
    super.key,
    required this.controller,
    required this.order,
  });

  @override
  State<OrderDetailModal> createState() => _OrderDetailModalState();
}

class _OrderDetailModalState extends State<OrderDetailModal> {
  void _closeModal() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final sreenWidth = context.screenWidth;
    return Material(
      color: Colors.black26,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: Colors.white,
        elevation: 10,
        child: Container(
          width: sreenWidth * (sreenWidth > 1200 ? .5 : .7),
          padding: const EdgeInsets.all(30),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Detalhe do Pedido',
                        style: context.textStyles.textTitle,
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        onPressed: _closeModal,
                        icon: const Icon(Icons.close),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Nome do Cliente: ',
                      style: context.textStyles.textBold,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      widget.order.user.name,
                      style: context.textStyles.textRegular,
                    ),
                  ],
                ),
                const Divider(),
                ...widget.order.orderProducts
                    .map(
                      (op) => OrderProductItem(
                        orderProduct: op,
                      ),
                    )
                    .toList(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total de Pedido',
                        style: context.textStyles.textExtraBold
                            .copyWith(fontSize: 18),
                      ),
                      Text(
                        widget.order.orderProducts
                            .fold<double>(
                              0.0,
                              (previousValue, p) =>
                                  previousValue + p.totalPrice,
                            )
                            .currencyPTBR,
                        style: context.textStyles.textExtraBold
                            .copyWith(fontSize: 18),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                OrderInfoTitle(
                  label: 'Endereço de entrega:',
                  info: widget.order.address,
                ),
                const Divider(),
                OrderInfoTitle(
                  label: 'Forma de pagamento:',
                  info: widget.order.paymentTypeModel.name,
                ),
                const SizedBox(
                  height: 10,
                ),
                OrderBottonBar(
                  controller: widget.controller,
                  order: widget.order,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
