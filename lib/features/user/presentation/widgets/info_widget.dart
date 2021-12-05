import 'package:ecommerce/utility/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

List<Widget> infoWidget(String title, String? info, {bool last = false}) {
  return [
    Row(
      children: [
        Text(
          '$title :',
          style: Get.textTheme.headline6!
              .copyWith(fontSize: 16, color: primaryColor),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: GestureDetector(
            onLongPress: () {
              Clipboard.setData(ClipboardData(text: info));
              Fluttertoast.showToast(
                  msg: "$title Copied to clipboard",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: primaryColor,
                  textColor: Colors.white,
                  fontSize: 16.0);
            },
            child: Text(
              info ?? '',
              maxLines: 1,
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        )
      ],
    ),
    if (!last)
      const SizedBox(
          height: 20,
          child: Divider(
            height: 3,
          )),
  ];
}
