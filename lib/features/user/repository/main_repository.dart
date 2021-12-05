import 'package:ecommerce/features/auth/data/local/auth_local_storage.dart';
import 'package:ecommerce/features/auth/data/model/user_model.dart';
import 'package:ecommerce/features/auth/data/remote/auth_remote_storage.dart';
import 'package:ecommerce/features/user/data/local/main_local_data.dart';
import 'package:ecommerce/features/user/data/model/cart_model.dart';
import 'package:ecommerce/features/user/data/model/category_model.dart';
import 'package:ecommerce/features/user/data/model/item_model.dart';
import 'package:ecommerce/features/user/data/model/order_model.dart';
import 'package:ecommerce/features/user/data/model/payment_request_model.dart';
import 'package:ecommerce/features/user/data/model/payout_info_model.dart';
import 'package:ecommerce/features/user/data/model/shopping_address_model.dart';
import 'package:ecommerce/features/user/data/remote/main_remote_storage.dart';
import 'package:get/get.dart';

class MainRepository {
  final _mainRemoteData = MainRemoteStorage();
  final _mainLocalData = MainLocalData();

  final _authRemoteStorage = Get.put(AuthRemoteStorage());
  final _authLocalStorage = Get.put(AuthLocalStorage());

  Stream<List<CategoryModel>?> getCategories() {
    return _mainRemoteData.getCategories();
  }

  Stream<List<ItemModel>?> getItemsWithStream(List<String> itemsId) {
    return _mainRemoteData.getItemsWithStream(itemsId);
  }

  Future<List<ItemModel>?> getItems(List<String> itemsId) async {
    return await _mainRemoteData.getItems(itemsId);
  }

  Future<List<ItemModel>> getItemsByCat(String catId) async{
    return await _mainRemoteData.getItemsByCat(catId);
  }

  List<ItemModel> loadFavoriteData() {
    return _mainLocalData.loadFavoriteData();
  }

  void saveFavoriteData(List<ItemModel> items) {
    _mainLocalData.saveFavoriteData(items);
  }

  List<CartModel> loadCarteData() {
    return _mainLocalData.loadCartData();
  }

  void saveCartData(List<CartModel> cartItems) {
    _mainLocalData.saveCartData(cartItems);
  }

  List<ShoppingAddressModel> loadShoppingAddresses() {
    return _mainLocalData.loadShoppingAddresses();
  }

  void saveShoppingAddresses(List<ShoppingAddressModel> addresses) {
    _mainLocalData.saveShoppingAddresses(addresses);
  }

  Stream<UserModel?> getUserData() {
    return _authRemoteStorage
        .getStreamUserData(_authLocalStorage.getUserUID()!);
  }

  Future<bool> editUserInfo(UserModel user) async {
    return await _authRemoteStorage.editUserInfo(user);
  }

  Future<String?> uploadImage(String path) async {
    return await _authRemoteStorage.uploadImage(path);
  }

  Future<bool?> deleteImage(String url) async {
    return await _authRemoteStorage.deleteImage(url);
  }

  Future<PayoutInfoModel?> getPayoutInfo() async {
    return await _mainRemoteData.getPayoutInfo();
  }

  Future<PaymentRequestModel?> makePayout(
      {required double amount,
      required ShoppingAddressModel shoppingAddress,
      required double exchangeRate,
      required PayoutInfoModel payoutInfo}) async {
    return await _mainRemoteData.makePayout(
        amount: amount,
        shoppingAddress: shoppingAddress,
        exchangeRate: exchangeRate,
        payoutInfo: payoutInfo);
  }

  Future<bool> checkPayoutStatus(
      String tranRef, PayoutInfoModel payoutInfo) async {
    return await _mainRemoteData.checkPayoutStatus(tranRef, payoutInfo);
  }

  Future<bool> sendOrder(OrderModel order) async {
    return await _mainRemoteData.sendOrder(order);
  }

  Stream<List<OrderModel>?> getOrders(String uid) {
    return _mainRemoteData.getOrders(uid);
  }
}
