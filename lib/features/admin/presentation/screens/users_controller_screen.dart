import 'package:ecommerce/utility/constants.dart';
import 'package:flutter/material.dart';

class UsersControllerScreen extends StatelessWidget {
  const UsersControllerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        leading: const BackButton(
          color: Colors.white,
        ),
      ),
    );
  }
}