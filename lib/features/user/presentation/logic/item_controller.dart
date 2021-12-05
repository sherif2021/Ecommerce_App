import 'dart:async';

import 'package:ecommerce/features/user/data/model/image_model.dart';
import 'package:ecommerce/features/user/data/model/item_model.dart';
import 'package:ecommerce/features/user/repository/main_repository.dart';
import 'package:get/get.dart';

class ItemController extends GetxController {
  final _mainRepository = Get.put(MainRepository());

  StreamSubscription<List<ItemModel>?>? _itemSubscription;

  final String itemId;

  final item = Rx<ItemModel?>(null);

  final isLoading = Rx(true);

  final selectedImageIndex = Rx(0);

  final itemCount = Rx(1);

  final selectedColor = Rx<ImageModel?>(null);

  final selectedSize = Rx<String?>(null);

  ItemController(this.itemId);

  @override
  void onInit() {
    super.onInit();
    _getItemData();
  }

  @override
  void onClose() {
    _itemSubscription?.cancel();
    super.onClose();
  }

  void _getItemData() {
    _itemSubscription = _mainRepository.getItemsWithStream([itemId]).listen((data) {

      if (isLoading.isTrue) isLoading.value = false;
      if (data != null && data.isNotEmpty) {
        item.value = data.first;
      }
    });
  }
}
