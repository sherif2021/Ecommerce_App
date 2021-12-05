import 'package:ecommerce/features/user/presentation/logic/home_controller.dart';
import 'package:ecommerce/features/user/presentation/logic/payment_controller.dart';
import 'package:ecommerce/features/user/presentation/screens/home/categories_widget.dart';
import 'package:ecommerce/features/user/presentation/screens/home/favorite_widget.dart';
import 'package:ecommerce/features/user/presentation/screens/home/home_widget.dart';
import 'package:ecommerce/features/user/presentation/screens/home/profile_widget.dart';
import 'package:ecommerce/utility/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final _controller = Get.put(HomeController());

  final _paymentController = Get.put(PaymentController());

  final widgets = [
    HomeWidget(),
    CategoriesWidget(),
    FavoriteWidget(),
    ProfileWidget()
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () {
          if (_controller.bottomNavBarIndex.value != 0) {
            _controller.bottomNavBarIndex.value = 0;
            return Future.value(false);
          }
          return Future.value(true);
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              _buildNavBarSelectedItem(context),
              _buildBottomNavBar(),
              _buildCartBackground(),
              _buildCartPrice(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavBarSelectedItem(BuildContext context) {
    return Obx(() => IndexedStack(
          index: _controller.bottomNavBarIndex.value,
          children: widgets,
        ));
  }

  Widget _buildBottomNavBar() {
    return Positioned(
      bottom: 0,
      child: SizedBox(
        height: 55,
        width: Get.width,
        child: Obx(
          () => Padding(
            padding: const EdgeInsets.only(right: 95),
            child: BottomNavigationBar(
              currentIndex: _controller.bottomNavBarIndex.value,
              selectedItemColor: primaryColor,
              unselectedItemColor: Colors.grey,
              onTap: (index) => _controller.bottomNavBarIndex.value = index,
              items: [
                const BottomNavigationBarItem(
                    icon: Icon(Icons.home), label: 'Home'),
                const BottomNavigationBarItem(
                    icon: Icon(
                      Icons.apps,
                    ),
                    label: 'Categories'),
                BottomNavigationBarItem(
                    icon: Icon(_controller.bottomNavBarIndex.value == 2
                        ? Icons.favorite
                        : Icons.favorite_border),
                    label: 'Favorite'),
                const BottomNavigationBarItem(
                    icon: Icon(Icons.person), label: 'Profile'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCartPrice() {
    return Positioned(
      child: GestureDetector(
        onTap: () => Get.toNamed(cartScreen),
        child: Container(
          height: 50,
          width: 100,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                bottomLeft: Radius.circular(30),
              ),
              gradient: LinearGradient(
                colors: [primaryColor, secondColor],
                begin: Alignment.center,
                end: Alignment.centerRight,
              ),
              color: primaryColor),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Icon(
                Icons.shopping_cart_outlined,
                color: Colors.white,
                size: 20,
              ),
              Obx(() => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '\$${_paymentController.calcCart()}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w700),
                      ),
                      Text(
                        '${_paymentController.cartItems.length} items',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
      right: 0,
      bottom: 20,
    );
  }

  Widget _buildCartBackground() {
    return const Positioned(
      child: SizedBox(
        height: 50,
        width: 100,
        child: ColoredBox(
          color: Colors.white,
        ),
      ),
      bottom: 0,
      right: 0,
    );
  }
}
