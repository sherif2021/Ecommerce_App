import 'package:ecommerce/features/user/data/model/order_model.dart';
import 'package:ecommerce/features/user/presentation/logic/home_controller.dart';
import 'package:ecommerce/features/user/presentation/logic/payment_controller.dart';
import 'package:ecommerce/features/user/presentation/widgets/cart_item_widget.dart';
import 'package:ecommerce/features/user/presentation/widgets/order_details_widget.dart';
import 'package:ecommerce/features/user/presentation/widgets/order_widget.dart';
import 'package:ecommerce/utility/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final _controller = Get.put(PaymentController());
  final _homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          leading: const BackButton(
            color: Colors.white,
          ),
          title: Text(
            'Orders',
            style: Get.textTheme.headline6!
                .copyWith(color: Colors.white, fontSize: 16),
          ),
        ),
        body: Obx(
          () => ListView.builder(
            itemCount: _controller.orders.length,
            itemBuilder: (_, index) => GestureDetector(
                onTap: () => _showOrderDetails(_controller.orders[index]),
                child: OrderWidget(order: _controller.orders[index])),
          ),
        ),
      ),
    );
  }

  void _showOrderDetails(OrderModel order) {
    Get.bottomSheet(
        FractionallySizedBox(
          heightFactor: 0.8,
          child: ListView.builder(
            itemCount: order.items.length,
            itemBuilder: (_, index) =>
                OrderDetailsWidget(cart: order.items[index]),
          ),
        ),
        isScrollControlled: true,
        backgroundColor: Get.theme.scaffoldBackgroundColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular((20))),
        ),);
  }

  @override
  void initState() {
    super.initState();
    if (_homeController.user.value != null) {
      _controller.getOrders(_homeController.user.value!.uid);
    }
  }

  @override
  void dispose() {
    _controller.stopOrdersStream();
    super.dispose();
  }
}
