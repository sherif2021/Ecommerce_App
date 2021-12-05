import 'package:ecommerce/utility/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminPanelScreen extends StatelessWidget {
  const AdminPanelScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text(
          'Admin Panel',
          style: TextStyle(color: Colors.white),
        ),
        leading: const BackButton(
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: Column(
            children: [
              _buildElement('Items Controller', itemsControllerScreen),
              _buildElement('Categories Controller', catsControllerScreen),
              _buildElement('Orders Controller', ordersControllerScreen),
              _buildElement('Users Controller', usersControllerScreen),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildElement(String text, String routeName) {
    return SizedBox(
        width: Get.width,
        child: ElevatedButton(
            onPressed: () => Get.toNamed(routeName), child: Text(text)));
  }
}
