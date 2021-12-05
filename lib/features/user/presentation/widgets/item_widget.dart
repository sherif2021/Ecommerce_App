import 'package:ecommerce/features/user/data/model/item_model.dart';
import 'package:ecommerce/features/user/presentation/logic/home_controller.dart';
import 'package:ecommerce/features/user/presentation/widgets/image_widget.dart';
import 'package:ecommerce/utility/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:collection/collection.dart';

class ItemWidget extends StatelessWidget {
  final ItemModel item;
  final Function? onClick;

  ItemWidget({Key? key, required this.item, this.onClick}) : super(key: key);
  final _controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onClick != null
          ? onClick!()
          : Get.toNamed(itemDetailsScreen, arguments: item.id),
      child: SizedBox(
        height: 280,
        width: Get.width * .42,
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: ImageWidget(
                      height: 200,
                      width: Get.width,
                      image: item.pics.first,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: RatingBar.builder(
                      initialRating: item.rating,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemSize: 12,
                      itemPadding:
                          const EdgeInsets.symmetric(horizontal: 0.3),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.orange,
                      ),
                      maxRating: 5,
                      ignoreGestures: true,
                      updateOnDrag: false,
                      tapOnlyMode: false,
                      glow: false,
                      onRatingUpdate: (v) {},
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      item.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Get.textTheme.headline6!.copyWith(
                          fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        if (item.discount > 0)
                          Text(
                            '\$${item.discount.toStringAsFixed(item.discount.toString().endsWith('.0') ? 0 : 1)}',
                            style: Get.textTheme.bodyText2!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: item.discount > 0
                                    ? const Color(0xffBE4A3A)
                                    : Colors.black),
                          ),
                        if (item.discount > 0)
                          const SizedBox(
                            width: 10,
                          ),
                        Text(
                          '\$${item.price.toStringAsFixed(item.price.toString().endsWith('.0') ? 0 : 1)}',
                          style: Get.textTheme.bodyText2!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: item.discount > 0
                                  ? Colors.grey
                                  : Colors.black,
                              decoration: item.discount > 0
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                child: IconButton(
                  icon: Container(
                    child: Obx(
                      () => Icon(_controller.favorites
                                  .firstWhereOrNull((e) => e.id == item.id) !=
                              null
                          ? Icons.favorite
                          : Icons.favorite_border),
                    ),
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black12,
                              offset: Offset(0, 5),
                              blurRadius: 5)
                        ]),
                  ),
                  color: buttonColor,
                  iconSize: 16,
                  splashRadius: 15,
                  onPressed: () => _controller.favorites
                              .firstWhereOrNull((e) => e.id == item.id) !=
                          null
                      ? _controller.removeFavoriteItem(item.id!)
                      : _controller.addFavoriteItem(item),
                ),
                top: 175,
                right: 5,
              ),
              if (item.discount > 0)
                Positioned(
                  left: 0,
                  top: 10,
                  child: Container(
                    height: 22.5,
                    width: 50,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xffBE4A3A),
                          const Color(0xffBE4A3A).withOpacity(.4)
                        ],
                        begin: Alignment.center,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '${((item.price - item.discount) / item.price * 100).floor()}%',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
