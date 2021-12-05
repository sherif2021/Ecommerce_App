import 'package:ecommerce/features/user/data/model/order_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'info_widget.dart';

class OrderWidget extends StatelessWidget {
  final OrderModel order;
  final bool? isAdmin;

  const OrderWidget({Key? key, required this.order, this.isAdmin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ...infoWidget('ID', order.id!),
            ...infoWidget('Payment ID', order.tranRef),
            ...infoWidget('Items Count', order.items.length.toString()),
            ...infoWidget('Amount', order.cost.toString()),
            ...infoWidget('Shipping By', order.deliveryCompanyName),
            ...infoWidget('Shipping Cost', order.deliveryCost.toString()),
            ...infoWidget('Order On', order.time.toLocal().toString()),
            ...infoWidget('Status', orderStatus(), last: true),
          ],
        ),
      ),
    );
  }

  String orderStatus() {
    return order.status == 1
        ? 'Waiting for ${isAdmin != null ? 'You' : 'Admin'} Confirm'
        : order.status == 2
            ? 'Waiting for Shipment'
            : order.status == 3
                ? 'Shipped on the way to ${isAdmin != null ? 'Customer' : 'You'}'
                : 'Sent';
  }
}
