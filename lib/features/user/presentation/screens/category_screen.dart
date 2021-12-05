import 'package:ecommerce/features/user/data/model/category_model.dart';
import 'package:ecommerce/features/user/presentation/logic/category_controller.dart';
import 'package:ecommerce/features/user/presentation/widgets/item_widget.dart';
import 'package:ecommerce/features/user/repository/main_repository.dart';
import 'package:ecommerce/utility/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryScreen extends StatelessWidget {
  final CategoryModel category;

  late final CategoryController _controller;

  CategoryScreen(
      {Key? key,
      required this.category})
      : super(key: key) {
    _controller = Get.put(CategoryController(catId: category.id!));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Get.delete<CategoryController>();
        return Future.value(true);
      },
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: primaryColor,
            leading: const BackButton(
              color: Colors.white,
            ),
            title: Text(
              category.name,
              style: Get.textTheme.headline6!
                  .copyWith(color: Colors.white, fontSize: 16),
            ),
          ),
          body: Obx(
            () => _controller.isLoading.value
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : GridView.builder(
                    itemCount: _controller.items.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, mainAxisExtent: 290),
                    itemBuilder: (_, index) => Hero(
                        tag: _controller.items[index].hashCode,
                        child: ItemWidget(item: _controller.items[index])),
                  ),
          )),
    );
  }
}
