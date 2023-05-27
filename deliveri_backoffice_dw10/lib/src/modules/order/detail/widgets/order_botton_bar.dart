import 'package:flutter/material.dart';

import '../../../../core/ui/styles/text_styles.dart';
import '../../../../dto/order/order_dto.dart';
import '../../../../models/orders/order_status.dart';
import '../../widget/order_controller.dart';

class OrderBottonBar extends StatelessWidget {
  final OrderController controller;
  final OrderDto order;

  const OrderBottonBar({
    super.key,
    required this.controller,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        OrderBottonBarButton(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(14),
            bottomLeft: Radius.circular(14),
          ),
          buttonColor: Colors.blue,
          image: 'assets/images/icons/finish_order_white_ico.png',
          buttonLabel: 'Finalizar',
          onPressed: order.status == OrderStatus.confirmado
              ? () {
                  controller.changeStatus(OrderStatus.finalizado);
                }
              : null,
        ),
        OrderBottonBarButton(
          borderRadius: BorderRadius.zero,
          buttonColor: Colors.green,
          image: 'assets/images/icons/confirm_order_white_icon.png',
          buttonLabel: 'Confirmar',
          onPressed: order.status == OrderStatus.pendende
              ? () {
                  controller.changeStatus(OrderStatus.confirmado);
                }
              : null,
        ),
        OrderBottonBarButton(
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(14),
            bottomRight: Radius.circular(14),
          ),
          buttonColor: Colors.red,
          image: 'assets/images/icons/cancel_order_white_icon.png',
          buttonLabel: 'Cancelar',
          onPressed: order.status != OrderStatus.cancelado &&
                  order.status != OrderStatus.finalizado
              ? () {
                  controller.changeStatus(OrderStatus.cancelado);
                }
              : null,
        ),
      ],
    );
  }
}

class OrderBottonBarButton extends StatelessWidget {
  final BorderRadius borderRadius;
  final Color buttonColor;
  final String image;
  final String buttonLabel;
  final VoidCallback? onPressed;

  const OrderBottonBarButton({
    Key? key,
    required this.borderRadius,
    required this.buttonColor,
    required this.image,
    required this.buttonLabel,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      fit: FlexFit.tight,
      child: SizedBox(
        height: 60,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: borderRadius,
            ),
            side: BorderSide(
              color: onPressed !=  null ? buttonColor : Colors.transparent,
            ),
            backgroundColor: buttonColor,
          ),
          onPressed: onPressed,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(image),
              const SizedBox(
                width: 10,
              ),
              Text(
                buttonLabel,
                style: context.textStyles.textBold.copyWith(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
