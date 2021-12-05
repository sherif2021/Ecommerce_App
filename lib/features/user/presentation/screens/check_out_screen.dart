import 'package:ecommerce/features/user/data/model/delivery_method_model.dart';
import 'package:ecommerce/features/user/presentation/logic/payment_controller.dart';
import 'package:ecommerce/features/user/presentation/logic/home_controller.dart';
import 'package:ecommerce/features/user/presentation/widgets/shopping_address_widget.dart';
import 'package:ecommerce/utility/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckOutScreen extends StatelessWidget {
  final _homeController = Get.put(HomeController());

  final _controller = Get.put(PaymentController());

  final _deliveryMethods = [
    DeliveryMethodModel(
        name: 'DHL',
        logoPath: 'assets/icons/dhl_logo.png',
        cost: 15,
        time: '1-2'),
    DeliveryMethodModel(
        name: 'FEDEX',
        logoPath: 'assets/icons/fedex_logo.png',
        cost: 18,
        time: '1-2'),
    DeliveryMethodModel(
        name: 'USPS',
        logoPath: 'assets/icons/usps_logo.png',
        cost: 20,
        time: '1-2'),
  ];

  CheckOutScreen({Key? key}) : super(key: key) {
    if (_controller.currentShoppingAddress.value == null &&
        _homeController.shoppingAddresses.isNotEmpty) {
      _controller.currentShoppingAddress.value =
          _homeController.shoppingAddresses.first;
    }
  }

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
            'Check Out',
            style: Get.textTheme.headline6!
                .copyWith(color: Colors.white, fontSize: 16),
          ),
        ),
        bottomNavigationBar: _buildBottomWidget(),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 20, left: 10, right: 10, bottom: 5),
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      color: primaryColor,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Shipping Address',
                      style: Get.textTheme.headline6!
                          .copyWith(color: primaryColor),
                    )
                  ],
                ),
              ),
              Obx(() => _controller.currentShoppingAddress.value == null
                  ? TextButton(
                      onPressed: () {
                        Get.offAndToNamed(homeScreen);
                        _homeController.bottomNavBarIndex.value = 3;
                      },
                      child: const Text(
                        'You don`t have any Shopping Address, \n Click Here to Add',
                        textAlign: TextAlign.center,
                      ))
                  : SizedBox(
                      width: Get.width,
                      child: Card(
                          child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: ShoppingAddressWidget(
                          shoppingAddress:
                              _controller.currentShoppingAddress.value!,
                          onOnChangeClicked: _openShoppingAddressBottomSheet,
                        ),
                      )),
                    )),
              Padding(
                padding: const EdgeInsets.only(
                    top: 30, left: 10, right: 10, bottom: 5),
                child: Row(
                  children: [
                    const Icon(
                      Icons.local_shipping_outlined,
                      color: primaryColor,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Delivery Method',
                      style: Get.textTheme.headline6!
                          .copyWith(color: primaryColor),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 140,
                child: ListView.builder(
                    itemCount: _deliveryMethods.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (_, index) =>
                        _buildDeliveryMethodWidget(_deliveryMethods[index])),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        )),
      ),
    );
  }

  void _openShoppingAddressBottomSheet() {
    Get.bottomSheet(
        FractionallySizedBox(
          heightFactor: 0.75,
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: ListView.builder(
              itemCount: _homeController.shoppingAddresses.length,
              itemBuilder: (_, index) => GestureDetector(
                onTap: () {
                  _controller.currentShoppingAddress.value =
                      _homeController.shoppingAddresses[index];
                  Get.back();
                },
                child: SizedBox(
                  width: Get.width,
                  child: Card(
                      child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: ShoppingAddressWidget(
                      shoppingAddress: _homeController.shoppingAddresses[index],
                    ),
                  )),
                ),
              ),
            ),
          ),
        ),
        isScrollControlled: true,
        backgroundColor: Get.theme.scaffoldBackgroundColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular((20))),
        ));
  }

  Widget _buildDeliveryMethodWidget(DeliveryMethodModel deliveryMethod) {
    return GestureDetector(
      onTap: () {
        if (deliveryMethod != _controller.currentDeliveryMethod.value) {
          _controller.currentDeliveryMethod.value = deliveryMethod;
        }
      },
      child: Obx(
        () => Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                    color: deliveryMethod.name ==
                            _controller.currentDeliveryMethod.value?.name
                        ? buttonColor
                        : Colors.transparent,
                    width: 3)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Image.asset(
                    deliveryMethod.logoPath,
                    width: 70,
                    height: 50,
                    fit: BoxFit.fill,
                  ),
                  Text(
                    '\$${deliveryMethod.cost}',
                    style: Get.textTheme.headline6!.copyWith(fontSize: 15),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    '${deliveryMethod.time} days',
                    style: Get.textTheme.caption!.copyWith(fontSize: 13),
                  ),
                ],
              ),
            )),
      ),
    );
  }

  Widget _buildBottomWidget() {
    return Container(
      width: Get.width,
      height: 180,
      decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black54, offset: Offset(0, 2), blurRadius: 5)
          ],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          )),
      child: Obx(() => Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Items : ',
                      style: Get.textTheme.bodyText1!.copyWith(
                          fontWeight: FontWeight.bold, color: Colors.grey),
                    ),
                    Obx(() => Text(
                          '\$${_controller.calcCart()}',
                          style: Get.textTheme.bodyText1!.copyWith(
                              fontWeight: FontWeight.bold, color: Colors.grey),
                        )),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Delivery',
                      style: Get.textTheme.bodyText1!.copyWith(
                          fontWeight: FontWeight.bold, color: Colors.grey),
                    ),
                    Text(
                      '\$${(_controller.currentDeliveryMethod.value?.cost ?? 0)}',
                      style: Get.textTheme.bodyText1!.copyWith(
                          fontWeight: FontWeight.bold, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total : ',
                      style: Get.textTheme.headline5!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    Obx(() => Text(
                          '\$${_controller.calcCart() + (_controller.currentDeliveryMethod.value?.cost ?? 0)}',
                          style: Get.textTheme.headline5!
                              .copyWith(fontWeight: FontWeight.bold),
                        )),
                  ],
                ),
              ),
              SizedBox(
                width: Get.width,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Obx(() => MaterialButton(
                        onPressed: (_controller.isLoading.value) ? null : _pay,
                        color: buttonColor,
                        disabledColor: Colors.grey,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        child: const Text(
                          'Pay',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                      )),
                ),
              ),
            ],
          )),
    );
  }

  void _pay() async {
    if (_controller.currentDeliveryMethod.value == null ||
        _controller.currentShoppingAddress.value == null) {
      Get.defaultDialog(
          title: 'Requirement Methods',
          middleText:
              'Please select ${_controller.currentShoppingAddress.value == null ? 'Shopping Address Method' : 'Delivery Method'}',
          textConfirm: 'Ok',
          confirmTextColor: Colors.white,
          onConfirm: () => Get.back());
    } else {
      _controller.isLoading.value = true;

      final result = await _controller.makePayout();
      if (result != null) {
        await Get.toNamed(payoutWebViewScreen, arguments: result.redirectUrl);
        final payoutResult =
            await _controller.checkPayoutStatus(result.tranRef);

        if (payoutResult) {
          await _controller.sendOrder(
              cartId: result.cartId,
              tranRef: result.tranRef,
              user: _homeController.user.value!);
          _controller.clearCart();
        }
        Get.dialog(
            WillPopScope(
              onWillPop: () => Future.value(!payoutResult),
              child: AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                contentPadding: const EdgeInsets.all(0),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        height: 140,
                        width: Get.width,
                        decoration: const BoxDecoration(
                            color: primaryColor,
                            gradient: LinearGradient(
                              colors: [primaryColor, secondColor],
                              begin: Alignment.center,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(300),
                              bottomRight: Radius.circular(300),
                            )),
                        child: Center(
                            child: Icon(
                          payoutResult
                              ? Icons.check_circle_outline
                              : Icons.clear,
                          color: Colors.white,
                          size: 60,
                        ))),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      payoutResult ? 'Success' : 'Filed',
                      style: Get.textTheme.headline6,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      payoutResult
                          ? 'Your order will be delivered soon. \n it can be tracked in the "Orders" section.'
                          : 'Failed to Payout! \n Please try again.',
                      style: Get.textTheme.caption!.copyWith(fontSize: 13),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    if (payoutResult)
                      SizedBox(
                        width: Get.width,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 5),
                          child: MaterialButton(
                            onPressed: () {
                              _homeController.bottomNavBarIndex.value = 0;
                              Get.offAllNamed(homeScreen);
                            },
                            color: buttonColor,
                            disabledColor: Colors.grey,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            child: const Text(
                              'Continue Shopping',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                          ),
                        ),
                      ),
                    TextButton(
                        onPressed: () {
                          if (payoutResult) {
                            Get.offAllNamed(homeScreen);
                            Get.toNamed(ordersScreen);
                          } else {
                            Get.back();
                          }
                        },
                        child: Text(payoutResult ? 'Go to Orders' : 'Ok')),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
            barrierDismissible: !payoutResult);
      } else {
        Get.defaultDialog(
            title: 'Error',
            middleText: 'Error while making payout, \n please try again later.',
            textCancel: 'Ok');
      }
    }
    _controller.isLoading.value = false;
  }
}
