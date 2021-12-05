import 'package:ecommerce/features/user/data/model/shopping_address_model.dart';
import 'package:ecommerce/utility/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShoppingAddressWidget extends StatelessWidget {
  const ShoppingAddressWidget(
      {Key? key, required this.shoppingAddress, this.onOnChangeClicked})
      : super(key: key);

  final ShoppingAddressModel shoppingAddress;

  final Function? onOnChangeClicked;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                '${shoppingAddress.name}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Get.textTheme.headline6!.copyWith(
                    color: primaryColor,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
            ),
            if (onOnChangeClicked != null)
              TextButton(
                  onPressed: () => onOnChangeClicked!(),
                  child: const Text(
                    'Change',
                    style: TextStyle(color: primaryColor),
                  ))
            else
              const SizedBox(height: 35,)
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 5),
          child: Text(
            '${shoppingAddress.street}',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Get.textTheme.bodyText2!
                .copyWith(color: Colors.grey, fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 5),
          child: Text(
            '${shoppingAddress.city} ${shoppingAddress.country} ${shoppingAddress.postalCode} ',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Get.textTheme.bodyText2!
                .copyWith(color: Colors.grey, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}
