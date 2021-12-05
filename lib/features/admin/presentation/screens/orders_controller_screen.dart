import 'package:ecommerce/features/admin/presentation/logic/orders_controller.dart';
import 'package:ecommerce/features/user/data/model/image_model.dart';
import 'package:ecommerce/features/user/data/model/order_model.dart';
import 'package:ecommerce/features/user/presentation/widgets/image_widget.dart';
import 'package:ecommerce/features/user/presentation/widgets/info_widget.dart';
import 'package:ecommerce/features/user/presentation/widgets/order_details_widget.dart';
import 'package:ecommerce/features/user/presentation/widgets/order_widget.dart';
import 'package:ecommerce/utility/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrdersControllerScreen extends StatelessWidget {
  OrdersControllerScreen({Key? key}) : super(key: key);

  final _controller = Get.put(OrdersController());

  final statusList = [
    'All',
    'Waiting Confirm',
    'Waiting Shipment',
    'Shipped',
    'Sent'
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Get.delete<OrdersController>();
        return Future.value(true);
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: primaryColor,
            leading: const BackButton(
              color: Colors.white,
            ),
            title: const Text(
              'Orders Controller',
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Obx(() => DropdownButton(
                      isExpanded: true,
                      value: _controller.currentOrdersStatus.value,
                      onChanged: (v) {
                        _controller.currentOrdersStatus.value = v as int;
                      },
                      items: statusList
                          .map((e) => DropdownMenuItem(
                                child: Text(e),
                                value: statusList.indexOf(e),
                              ))
                          .toList(),
                    )),
              ),
              Expanded(
                child: Obx(
                  () => ListView.builder(
                    itemCount: _controller.orders.length,
                    itemBuilder: (_, index) => GestureDetector(
                      child: OrderWidget(
                        order: _controller.orders[index],
                        isAdmin: true,
                      ),
                      onTap: () => _showOptions(_controller.orders[index]),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showOptions(OrderModel order) {
    Get.bottomSheet(
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    onPressed: () => _showItemDetails(order),
                    child: const Text('Show Item Details'),
                  ),
                  TextButton(
                    onPressed: () => _showShippingDetails(order),
                    child: const Text('Show Shipping Details'),
                  ),
                  TextButton(
                    onPressed: () => _showUserDetails(order),
                    child: const Text('Show User Details'),
                  ),
                  TextButton(
                    onPressed: () => _changeStatus(order),
                    child: const Text('Change Status'),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ),
        ),
        isScrollControlled: true,
        backgroundColor: Get.theme.scaffoldBackgroundColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30),
            topLeft: Radius.circular(
              (30),
            ),
          ),
        ));
  }

  void _showItemDetails(OrderModel order) {
    Get.back();

    Get.bottomSheet(
      FractionallySizedBox(
        heightFactor: 0.8,
        child: ListView.builder(
          itemCount: order.items.length,
          itemBuilder: (_, index) => OrderDetailsWidget(
            cart: order.items[index],
            isAdmin: true,
          ),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(20), topLeft: Radius.circular((20))),
      ),
    );
  }

  void _showShippingDetails(OrderModel order) {
    Get.back();
    Get.bottomSheet(
      FractionallySizedBox(
        heightFactor: 0.6,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ...infoWidget('Name', order.shoppingAddress.name),
                ...infoWidget('Country', order.shoppingAddress.country),
                ...infoWidget('City', order.shoppingAddress.city),
                ...infoWidget('State', order.shoppingAddress.state),
                ...infoWidget('Street', order.shoppingAddress.street),
                ...infoWidget(
                    'PostalCode', order.shoppingAddress.postalCode.toString()),
                ...infoWidget('Email', order.shoppingAddress.email),
                ...infoWidget('Phone Number', order.shoppingAddress.phoneNumber,
                    last: true),
              ],
            ),
          ),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          topLeft: Radius.circular(
            (30),
          ),
        ),
      ),
    );
  }

  void _showUserDetails(OrderModel order) {
    Get.back();

    _controller.selectedOrderUser.value = null;
    _controller.getUserData(order.userUID);

    Get.bottomSheet(
      FractionallySizedBox(
        heightFactor: 0.6,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
            child: Obx(
              () => _controller.selectedOrderUser.value == null
                  ? const SizedBox()
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: ImageWidget(
                                image: ImageModel(
                                    url: _controller
                                        .selectedOrderUser.value!.pic),
                                width: 100,
                                height: 100)),
                        const SizedBox(
                          height: 50,
                        ),
                        ...infoWidget(
                            'UID', _controller.selectedOrderUser.value!.uid),
                        ...infoWidget(
                            'Name', _controller.selectedOrderUser.value!.name),
                        ...infoWidget('Phone Number',
                            _controller.selectedOrderUser.value!.phoneNumber),
                        ...infoWidget('Email',
                            _controller.selectedOrderUser.value!.email),
                        ...infoWidget('Provider',
                            _controller.selectedOrderUser.value!.provider),
                        ...infoWidget(
                            'is Admin',
                            _controller.selectedOrderUser.value!.isAdmin
                                ? 'Yes'
                                : 'No',
                            last: true),
                        const SizedBox(
                          height: 50,
                        )
                      ],
                    ),
            ),
          ),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          topLeft: Radius.circular(
            (30),
          ),
        ),
      ),
    );
  }

  void _changeStatus(OrderModel order) {
    Get.back();

    _controller.selectedOrderStatus.value = order.status;

    Get.defaultDialog(
        title: 'Change Order Status',
        middleText: '',
        titlePadding: const EdgeInsets.symmetric(vertical: 20),
        content: Obx(
          () => DropdownButton(
              value: _controller.selectedOrderStatus.value,
              onChanged: (v) =>
                  _controller.selectedOrderStatus.value = v as int,
              items: statusList
                  .sublist(1)
                  .map(
                    (e) => DropdownMenuItem(
                      child: Text(e),
                      value: statusList.indexOf(e),
                    ),
                  )
                  .toList()),
        ),
        onConfirm: () {
          _controller.changeOrderStatus(order);
          Get.back();
        },
        textConfirm: 'Set',
        textCancel: 'Cancel',
        confirmTextColor: Colors.white);
  }
}
