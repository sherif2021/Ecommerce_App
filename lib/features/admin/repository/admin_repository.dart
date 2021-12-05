import 'package:ecommerce/features/auth/data/model/user_model.dart';
import 'package:ecommerce/features/user/data/model/image_model.dart';
import 'package:ecommerce/features/admin/data/remote/admin_remote_storage.dart';
import 'package:ecommerce/features/auth/data/remote/auth_remote_storage.dart';
import 'package:ecommerce/features/user/data/model/category_model.dart';
import 'package:ecommerce/features/user/data/model/item_model.dart';
import 'package:ecommerce/features/user/data/model/order_model.dart';
import 'package:get/get.dart';
import 'package:collection/collection.dart';

class AdminRepository {
  final _adminRemoteStorage = AdminRemoteStorage();

  final _authRemoteStorage = Get.put(AuthRemoteStorage());

  Future<bool> addOrEditItem(ItemModel item) async {
    return await _adminRemoteStorage.addOrEditItem(item);
  }

  Future<bool> removeItem(String itemId) async {
    return await _adminRemoteStorage.removeItem(itemId);
  }

  Future<bool> uploadImages(List<ImageModel> images) async {
    for (var image in images) {
      while (image.url == null) {
        image.url = await _authRemoteStorage.uploadImage(image.path!);
      }
    }
    return images.firstWhereOrNull((e) => e.url != null && e.url!.isNotEmpty) !=
        null;
  }

  Future<List<ItemModel>> getItemsByCat(String? categoryId) async {
    return _adminRemoteStorage.getItemsByCat(categoryId);
  }

  Future<List<ItemModel>> getItems(List<String> ids) async {
    return _adminRemoteStorage.getItems(ids);
  }

  Future<List<ItemModel>> searchItems(String value) async {
    return await _adminRemoteStorage.searchItems(value);
  }

  Future<bool> setCategories(List<CategoryModel> categories) async {
    return await _adminRemoteStorage.updateCategories(categories);
  }

  Future<bool> removeCategory(String categoryId) async {
    return await _adminRemoteStorage.removeCategory(categoryId);
  }

  void deleteImagesFromFirebase(List<String> images) {
    for (var image in images) {
      _authRemoteStorage.deleteImage(image);
    }
  }

  Stream<List<OrderModel>?> getOrders(int? status) {
    return _adminRemoteStorage.getOrders(status);
  }

  Future<bool> changeOrderStatus(OrderModel order) async {
    return _adminRemoteStorage.changeOrderStatus(order);
  }

  Future<UserModel?> getUserData(String uid) async {
    return await _adminRemoteStorage.getUserData(uid);
  }
}
