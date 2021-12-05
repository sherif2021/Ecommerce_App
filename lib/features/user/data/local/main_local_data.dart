import 'package:ecommerce/features/user/data/model/cart_model.dart';
import 'package:ecommerce/features/user/data/model/item_model.dart';
import 'package:ecommerce/features/user/data/model/shopping_address_model.dart';
import 'package:get_storage/get_storage.dart';

class MainLocalData {
  final _box = GetStorage('user');

  List<ItemModel> loadFavoriteData() {
    return !_box.hasData('favorite')
        ? []
        : (_box.read('favorite') as List)
            .map((e) => ItemModel.fromMap(e['id'], e))
            .toList();
  }

  void saveFavoriteData(List<ItemModel> items) {
    _box.write('favorite', items.map((e) => e.toMap(addId: true)).toList());
  }

  List<CartModel> loadCartData() {
    return !_box.hasData('cart')
        ? []
        : (_box.read('cart') as List).map((e) => CartModel.fromMap(e)).toList();
  }

  void saveCartData(List<CartModel> cartItems) {
    _box.write('cart', cartItems.map((e) => e.toMap()).toList());
  }

  List<ShoppingAddressModel> loadShoppingAddresses() {
    return !_box.hasData('addresses')
        ? []
        : (_box.read('addresses') as List)
            .map((e) => ShoppingAddressModel.fromMap(e))
            .toList();
  }

  void saveShoppingAddresses(List<ShoppingAddressModel> addresses) {
    _box.write('addresses', addresses.map((e) => e.toMap()).toList());
  }
}
