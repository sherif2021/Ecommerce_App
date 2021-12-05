import 'package:ecommerce/features/admin/repository/admin_repository.dart';
import 'package:ecommerce/features/user/data/model/item_model.dart';
import 'package:get/get.dart';

class ItemsController extends GetxController {
  final _adminRepository = Get.put(AdminRepository());

  final items = RxList<ItemModel>();

  final searchingItems = RxList<ItemModel>();

  final item = Rx<ItemModel?>(null);

  final selectedCategory = Rx<String?>('all');

  final isLoading = false.obs;

  final isSearching = false.obs;

  Future<bool> addOrEditItem() async {
    return await _adminRepository.addOrEditItem(item.value!);
  }

  Future<bool> removeItem(ItemModel item) async {
    final result = await _adminRepository.removeItem(item.id!);
    if (result) {
      _adminRepository
          .deleteImagesFromFirebase(item.pics.map((e) => e.url!).toList());
    }
    return result;
  }

  Future<bool> uploadImages() async {
    return await _adminRepository
        .uploadImages([...item.value!.pics, ...item.value!.colors]);
  }

  void getItems() async {
    items.value = await _adminRepository.getItemsByCat(
        selectedCategory.value == null || selectedCategory.value == 'all'
            ? null
            : selectedCategory.value);
  }

  void search(String value) async {
    searchingItems.value = await _adminRepository.searchItems(value);
  }

  @override
  void onInit() {
    super.onInit();
    getItems();
  }
}
