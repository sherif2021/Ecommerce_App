import 'package:ecommerce/features/user/presentation/logic/home_controller.dart';
import 'package:ecommerce/features/user/presentation/widgets/category_widget.dart';
import 'package:ecommerce/utility/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoriesWidget extends StatelessWidget {
  CategoriesWidget({Key? key}) : super(key: key);

  final _controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height,
      width: Get.width,
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildTopWidget(context),
            _buildCategories(),
          ],
        ),
      ),
    );
  }


  Widget _buildTopWidget(BuildContext context) {
    return Container(
      width: Get.width,
      height: 90,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryColor, secondColor],
          begin: Alignment.center,
          end: Alignment.topRight,
        ),
      ),
      child: Center(
        child: Text(
          'Categories',
          style: Get.textTheme.headline6!
              .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildCategories() {
    return Obx(
      () {
        if (_controller.isLoading.value) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: Get.height * .3),
            child: const CircularProgressIndicator(),
          );
        }

        final categories = _controller.categories.where((e) => e.type == 0).toList()..sort((a, b) => a.index.compareTo(b.index));

        return ListView.builder(
          shrinkWrap: true,
          itemCount: categories.length,
          itemBuilder: (_, index) =>
              CategoryWidget(category: categories[index]),
        );
      },
    );
  }
}
