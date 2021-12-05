import 'package:ecommerce/features/user/data/model/item_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'image_widget.dart';

class CartItemWidget extends StatelessWidget {
  final ItemModel item;
  final int count;
  final Function onIncrease;
  final Function onDecrease;

  const CartItemWidget({
    Key? key,
    required this.item,
    required this.count,
    required this.onIncrease,
    required this.onDecrease,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          child: Column(
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: ImageWidget(
                      image: item.pics.first, width: 80, height: 100)),
              if (!item.inStock)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    'Out Stock',
                    style: Get.textTheme.bodyText1!.copyWith(color: Colors.red),
                  ),
                )
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Text(
                    item.title,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: Get.textTheme.headline6!.copyWith(
                        fontWeight: FontWeight.w500,
                        color: Colors.black.withOpacity(.7)),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 15),
                    child: Text(
                      '\$${count * (item.discount > 0 ? item.discount : item.price)}',
                      style: Get.textTheme.bodyText2!.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    )),
              ],
            ),
          ),
        ),
        SizedBox(
          width: 50,
          height: 120,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () => onIncrease(),
                child: Container(
                  height: 25,
                  width: 25,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.grey, width: 3),
                  ),
                  child: const Center(
                      child: Icon(
                    Icons.add,
                    size: 20,
                    color: Colors.grey,
                  )),
                ),
              ),
              Text(
                count.toString(),
                style: Get.textTheme.bodyText2!
                    .copyWith(fontWeight: FontWeight.w800),
              ),
              GestureDetector(
                onTap: () => onDecrease(),
                child: Container(
                  height: 25,
                  width: 25,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.grey, width: 3),
                  ),
                  child: const Center(
                      child: Icon(
                    Icons.remove,
                    size: 20,
                    color: Colors.grey,
                  )),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
