import 'package:ecommerce/features/admin/repository/admin_repository.dart';
import 'package:ecommerce/features/user/data/model/category_model.dart';
import 'package:get/get.dart';

class CategoriesController extends GetxController {
  final _adminRepository = Get.put(AdminRepository());

  final category = Rx<CategoryModel?>(null);

  final selectedCategoryType = Rx(0);

  final currentCategories = RxList<CategoryModel>();

  final isLoading = Rx(false);

  final isUpdatingIndexes = Rx(false);


  Future<bool> updateCategoriesIndexes() async {
    for (int i = 0; i < currentCategories.length; i++) {
      currentCategories[i].index = i;
    }

    final result = await _adminRepository.setCategories(currentCategories);

    if (result) {
      isUpdatingIndexes.value = false;
    }
    return result;
  }

  Future<bool> uploadImage() async {
    return await _adminRepository.uploadImages([category.value!.pic]);
  }

  Future<bool> setCategories(bool isAdding, List<CategoryModel> categories) async {

    final allCats = [...categories];
    if (isAdding) allCats.add(category.value!);

    for (int i = 0; i < allCats.length; i++) {
      allCats[i].index = i;
    }

    return await _adminRepository.setCategories(allCats);
  }

  Future<bool> removeCategory(CategoryModel category) async {
    final result = await _adminRepository.removeCategory(category.id!);
    if (result && category.pic.url != null) {
      _adminRepository.deleteImagesFromFirebase([category.pic.url!]);
    }
    return result;
  }
}
