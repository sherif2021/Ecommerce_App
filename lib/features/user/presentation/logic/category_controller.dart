import 'package:ecommerce/features/user/data/model/item_model.dart';
import 'package:ecommerce/features/user/repository/main_repository.dart';
import 'package:get/get.dart';

class CategoryController extends GetxController {
  final mainRepository = Get.put(MainRepository());
  final String catId;
  final List<ItemModel> items = [];
  final isLoading = Rx(true);

  CategoryController({required this.catId});

  void getItems() async {
    items.clear();
    items.addAll(await mainRepository.getItemsByCat(catId));
    isLoading.value = false;
  }

  @override
  void onInit() {
    super.onInit();
    getItems();
  }
}
