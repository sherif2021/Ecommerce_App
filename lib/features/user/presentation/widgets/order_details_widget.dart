import 'package:ecommerce/features/user/data/model/cart_model.dart';
import 'package:ecommerce/features/user/presentation/widgets/image_widget.dart';
import 'package:ecommerce/utility/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'info_widget.dart';

class OrderDetailsWidget extends StatelessWidget {
  final CartModel cart;
  final bool isAdmin;

  const OrderDetailsWidget({Key? key, required this.cart, this.isAdmin = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (cart.item != null) {
          Get.toNamed(itemDetailsScreen, arguments: cart.item);
        }
      },
      child: Card(
        margin: const EdgeInsets.all(15),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: ImageWidget(
                      image: cart.selectedColor ?? cart.wallImage,
                      width: 120,
                      height: 150)),
              const SizedBox(
                width: 30,
              ),
              Expanded(
                child: Column(
                  children: [
                    if (isAdmin) ...infoWidget('ID', cart.itemId),
                    ...infoWidget('Size', cart.selectedSize),
                    ...infoWidget('Count', cart.count.toString()),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
