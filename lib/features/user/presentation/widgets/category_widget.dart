import 'package:ecommerce/features/user/data/model/category_model.dart';
import 'package:ecommerce/features/user/presentation/widgets/image_widget.dart';
import 'package:ecommerce/utility/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({Key? key, required this.category, this.onClick})
      : super(key: key);

  final CategoryModel category;
  final Function? onClick;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onClick != null
          ? onClick!()
          : Get.toNamed(categoryScreen, arguments: category),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Text(
                category.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Get.textTheme.headline5!
                    .copyWith(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: ImageWidget(
                  image: category.pic,
                  height: 100,
                  width: 100,
                ))
          ],
        ),
      ),
    );
  }
}
