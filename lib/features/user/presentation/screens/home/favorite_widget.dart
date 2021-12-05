import 'package:ecommerce/features/user/presentation/logic/home_controller.dart';
import 'package:ecommerce/features/user/presentation/widgets/item_widget.dart';
import 'package:ecommerce/utility/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FavoriteWidget extends StatelessWidget {
  FavoriteWidget({Key? key}) : super(key: key);

  final _controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height,
      width: Get.width,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopWidget(context),
            Obx(() => Wrap(
                  spacing: Get.width * .02,
                  alignment: WrapAlignment.spaceBetween,
                  children: _controller.favorites
                      .map((e) => SizedBox(
                          width: Get.width * .48, child: ItemWidget(item: e)))
                      .toList(),
                )),
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
          'Favorite',
          style: Get.textTheme.headline6!
              .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
