import 'dart:async';

import 'package:ecommerce/features/auth/data/model/user_model.dart';
import 'package:ecommerce/features/auth/repository/auth_repository.dart';
import 'package:ecommerce/features/user/data/model/cart_model.dart';
import 'package:ecommerce/features/user/data/model/delivery_method_model.dart';
import 'package:ecommerce/features/user/data/model/item_model.dart';
import 'package:ecommerce/features/user/data/model/order_model.dart';
import 'package:ecommerce/features/user/data/model/payment_request_model.dart';
import 'package:ecommerce/features/user/data/model/payout_info_model.dart';
import 'package:ecommerce/features/user/data/model/shopping_address_model.dart';
import 'package:ecommerce/features/user/repository/main_repository.dart';
import 'package:get/get.dart';
import 'package:collection/collection.dart';

class PaymentController extends GetxController {
  final _mainRepository = Get.put(MainRepository());
  final _authRepository = Get.put(AuthRepository());

  StreamSubscription<List<ItemModel>?>? _cartItemsSubscription;

  StreamSubscription<List<OrderModel>?>? _ordersSubscription;

  final currentShoppingAddress = Rx<ShoppingAddressModel?>(null);

  final currentDeliveryMethod = Rx<DeliveryMethodModel?>(null);

  final cartItems = RxList<CartModel>();

  final isLoading = Rx(false);

  final orders = RxList<OrderModel>();

  PayoutInfoModel? payoutInfo;

  void _getCartItems() {
    try {
      if (cartItems.isEmpty) {
        cartItems.value = _mainRepository.loadCarteData();
      }

      _cartItemsSubscription?.cancel();

      if (cartItems.isNotEmpty) {
        _cartItemsSubscription = _mainRepository
            .getItemsWithStream(cartItems.map((e) => e.itemId).toSet().toList())
            .listen((data) {
          if (data != null) {
            for (var cart in cartItems) {
              final item = data.firstWhereOrNull((e) => e.id == cart.itemId);
              if (item != null) {
                cart.item = item;
              } else {
                cartItems.remove(cart);
                _mainRepository.saveCartData(cartItems);
              }
            }
            cartItems.refresh();
          }
        });
      }
    } catch (e) {
      _mainRepository.saveCartData([]);
    }
  }

  void addCartItem(CartModel cartItem) {
    cartItems.add(cartItem);
    _mainRepository.saveCartData(cartItems);
    _getCartItems();
  }

  void removeCartItem(CartModel cartItem) {
    cartItems.remove(cartItem);
    _mainRepository.saveCartData(cartItems);
    _getCartItems();
  }

  void clearCart() {
    cartItems.clear();
    _mainRepository.saveCartData([]);
  }

  void updateCartItem(CartModel cartModel) {
    cartItems.refresh();
    _mainRepository.saveCartData(cartItems);
  }

  double calcCart() {
    double price = 0;
    for (var cartItem in cartItems) {
      if (cartItem.item != null && cartItem.item!.inStock) {
        price += (cartItem.item!.discount > 0
                ? cartItem.item!.discount
                : cartItem.item!.price) *
            cartItem.count;
      }
    }
    return price;
  }

  Future<PaymentRequestModel?> makePayout() async {
    while (payoutInfo == null) {
      payoutInfo = await _mainRepository.getPayoutInfo();
    }

    return _mainRepository.makePayout(
        amount: calcCart() + currentDeliveryMethod.value!.cost,
        shoppingAddress: currentShoppingAddress.value!,
        exchangeRate: 15.5,
        payoutInfo: payoutInfo!);
  }

  Future<bool> checkPayoutStatus(String tranRef) async {
    return await _mainRepository.checkPayoutStatus(tranRef, payoutInfo!);
  }

  Future<bool> sendOrder(
      {required String cartId,
      required String tranRef,
      required UserModel user}) async {
    final order = OrderModel(
        cartId: cartId,
        tranRef: tranRef,
        status: 1,
        userUID: user.uid,
        shoppingAddress: currentShoppingAddress.value!,
        deliveryCompanyName: currentDeliveryMethod.value!.name,
        deliveryCost: currentDeliveryMethod.value!.cost,
        cost: calcCart(),
        items: cartItems.where((e) => e.item!.inStock).toList(),
        time: DateTime.now());
    return await _mainRepository.sendOrder(order);
  }

  void getOrders(String uid) {
    _ordersSubscription?.cancel();
    _ordersSubscription = _mainRepository.getOrders(uid).listen(orders);
  }

  void stopOrdersStream() {
    _ordersSubscription?.cancel();
    orders.clear();
  }

  bool isLogin() => _authRepository.isLogin();

  @override
  void onInit() {
    super.onInit();
    _getCartItems();
  }

  @override
  void onClose() {
    _cartItemsSubscription?.cancel();
    super.onClose();
  }
}
