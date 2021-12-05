import 'dart:async';
import 'package:ecommerce/features/auth/data/model/user_model.dart';
import 'package:ecommerce/features/auth/repository/auth_repository.dart';
import 'package:ecommerce/features/user/data/model/category_model.dart';
import 'package:ecommerce/features/user/data/model/item_model.dart';
import 'package:ecommerce/features/user/data/model/shopping_address_model.dart';
import 'package:ecommerce/features/user/repository/main_repository.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final _mainRepository = Get.put(MainRepository());

  final _authRepository = Get.put(AuthRepository());

  StreamSubscription<List<CategoryModel>?>? _catsSubscription;
  StreamSubscription<UserModel?>? _userSubscription;

  final sliderIndex = Rx(0);

  final bottomNavBarIndex = Rx(0);

  final isLoading = Rx(true);

  final categories = RxList<CategoryModel>();

  final favorites = RxList<ItemModel>();

  final shoppingAddresses = RxList<ShoppingAddressModel>();

  final addingShoppingAddress = Rx<ShoppingAddressModel?>(null);

  final user = Rx<UserModel?>(null);

  @override
  void onInit() {
    super.onInit();
    _getData();
    _loadData();
  }

  void _getData() async {
    _userSubscription?.cancel();
    _catsSubscription?.cancel();

    if (_authRepository.isLogin()) {
      _userSubscription = _mainRepository.getUserData().listen(user);
    }

    _catsSubscription = _mainRepository.getCategories().listen((data) {
      if (data != null) {
        categories.value = data;
        getSubCatsData();
        if (isLoading.isTrue) isLoading.value = false;
      }
    });
  }

  void getSubCatsData() async {
    final subCategories = categories.where((e) => e.type == 2);

    if (subCategories.isNotEmpty) {
      for (var cat in subCategories) {
        cat.items = await _mainRepository.getItemsByCat(cat.id!);
      }
      categories.refresh();
    }
  }

  void _loadData() {
    try {
      favorites.value = _mainRepository.loadFavoriteData();
      shoppingAddresses.value = _mainRepository.loadShoppingAddresses();
    } catch (e) {
      _mainRepository.saveFavoriteData([]);
      _mainRepository.saveShoppingAddresses([]);
    }
  }

  void addFavoriteItem(ItemModel item) {
    favorites.add(item);
    _mainRepository.saveFavoriteData(favorites);
  }

  void removeFavoriteItem(String itemId) {
    favorites.removeWhere((e) => e.id == itemId);
    _mainRepository.saveFavoriteData(favorites);
  }

  void addShoppingAddress(ShoppingAddressModel shoppingAddress) {
    shoppingAddresses.add(shoppingAddress);
    _mainRepository.saveShoppingAddresses(shoppingAddresses);
  }

  void removeShoppingAddress(ShoppingAddressModel shoppingAddress) {
    shoppingAddresses.remove(shoppingAddress);
    _mainRepository.saveShoppingAddresses(shoppingAddresses);
  }

  Future<bool> editUserInfo() async {
    if (user.value != null) {
      return await _mainRepository.editUserInfo(user.value!);
    }
    return false;
  }

  Future<bool> updateUserPicture(String path) async {
    if (user.value != null) {
      final uploadResult = await _mainRepository.uploadImage(path);
      if (uploadResult != null) {
        final oldImage = user.value!.pic;
        user.value!.pic = uploadResult;
        final editResult = await editUserInfo();
        if (editResult) {
          if (oldImage != null && oldImage.startsWith('http')) {
            _mainRepository.deleteImage(oldImage);
          }
          return true;
        }
      }
    }
    return false;
  }
  void logout(){
    _authRepository.logout();
  }

  bool isLogin() => _authRepository.isLogin();

  @override
  void onClose() async {
    super.onClose();

    _userSubscription?.cancel();
    _catsSubscription?.cancel();
  }
}
