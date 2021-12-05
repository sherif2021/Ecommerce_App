import 'dart:async';
import 'package:ecommerce/features/admin/repository/admin_repository.dart';
import 'package:ecommerce/features/auth/data/model/user_model.dart';
import 'package:ecommerce/features/user/data/model/order_model.dart';
import 'package:get/get.dart';

class OrdersController extends GetxController {
  final _adminRepository = Get.put(AdminRepository());

  final orders = RxList<OrderModel>();

  final currentOrdersStatus = Rx(1);

  final selectedOrderStatus = Rx(0);

  final selectedOrderUser = Rx<UserModel?>(null);

  StreamSubscription<List<OrderModel>?>? _ordersSubscription;

  void _getOrders() {
    _ordersSubscription?.cancel();

    _ordersSubscription = _adminRepository
        .getOrders(
            currentOrdersStatus.value != 0 ? currentOrdersStatus.value : null)
        .listen((data) {
      if (data != null) orders.value = data;
    });
  }

  void changeOrderStatus(OrderModel order) {
    order.status = selectedOrderStatus.value;
    _adminRepository.changeOrderStatus(order);
  }

  void getUserData(String uid) async {
    selectedOrderUser.value = await _adminRepository.getUserData(uid);
  }

  @override
  void onInit() {
    super.onInit();
    _getOrders();
    currentOrdersStatus.listen((e) {
      _getOrders();
    });
  }

  @override
  void onClose() {
    super.onClose();
    _ordersSubscription?.cancel();
  }
}
