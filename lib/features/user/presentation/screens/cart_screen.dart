import 'package:ecommerce/features/user/presentation/logic/home_controller.dart';
import 'package:ecommerce/features/user/presentation/logic/payment_controller.dart';
import 'package:ecommerce/features/user/presentation/widgets/cart_item_widget.dart';
import 'package:ecommerce/utility/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartScreen extends StatelessWidget {
  final _controller = Get.put(PaymentController());

  CartScreen({Key? key}) : super(key: key);

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
              'Cart',
              style: Get.textTheme.headline6!
                  .copyWith(color: Colors.white, fontSize: 16),
            ),
            actions: [
              if (_controller.cartItems.isNotEmpty)
                TextButton(
                  child: const Text('Clear'),
                  onPressed: _controller.clearCart,
                )
            ],
          ),
          bottomNavigationBar: _buildBottomWidget(),
          body: Obx(
            () => ListView.builder(
                itemCount: _controller.cartItems.length,
                itemBuilder: (_, index) {
                  final cartItem = _controller.cartItems[index];
                  return Dismissible(
                      key: UniqueKey(),
                      direction: DismissDirection.horizontal,
                      onDismissed: (direction) =>
                          _controller.removeCartItem(cartItem),
                      background: Container(
                          alignment: AlignmentDirectional.centerEnd,
                          color: Colors.red,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.fromLTRB(
                                    0.0, 0.0, Get.width * 0.02, 0.0),
                                child: const Icon(Icons.delete_outline),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(
                                    0.0, 0.0, Get.width * 0.05, 0.0),
                                child: const Text(
                                  "DELETE",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          )),
                      child: Card(
                        child: cartItem.item == null
                            ? const SizedBox()
                            : CartItemWidget(
                                item: cartItem.item!,
                                count: cartItem.count,
                                onIncrease: () {
                                  cartItem.count++;
                                  _controller.updateCartItem(cartItem);
                                },
                                onDecrease: () {
                                  if (cartItem.count > 1) {
                                    cartItem.count--;
                                    _controller.updateCartItem(cartItem);
                                  }
                                },
                              ),
                      ));
                }),
          )),
    );
  }

  Widget _buildBottomWidget() {
    return Container(
      width: Get.width,
      height: 120,
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
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total : ',
                  style: Get.textTheme.headline5!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                Obx(() => Text(
                      '\$${_controller.calcCart()}',
                      style: Get.textTheme.headline5!
                          .copyWith(fontWeight: FontWeight.bold),
                    )),
              ],
            ),
          ),
          SizedBox(
            width: Get.width,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: MaterialButton(
                onPressed: !_controller.isLogin()
                    ? _showMustLoginDialog
                    : _controller.calcCart() > 0
                        ? () => Get.toNamed(checkoutScreen)
                        : null,
                color: buttonColor,
                disabledColor: Colors.grey,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: const Text(
                  'Check Out',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showMustLoginDialog() {
    Get.defaultDialog(
        title: 'Login Required!',
        middleText: 'You must login to check out.',
        textConfirm: 'Ok',
        confirmTextColor: Colors.white,
        onConfirm: () {
          Get.toNamed(loginScreen);
          Get.delete<HomeController>();
        },
        textCancel: 'Not Now');
  }
}
