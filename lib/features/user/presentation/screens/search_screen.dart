import 'package:ecommerce/utility/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        leading: const BackButton(
          color: Colors.white,
        ),
        title: Text(
          'Search',
          style: Get.textTheme.headline6!
              .copyWith(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
