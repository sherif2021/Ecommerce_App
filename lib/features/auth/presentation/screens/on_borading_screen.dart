import 'package:ecommerce/utility/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: Get.width,
        height: Get.height,
        child: Stack(
          children: [
            Image.asset(
              'assets/images/on_boarding_image.jpg',
              height: Get.height * .6,
              width: Get.width,
              fit: BoxFit.fill,
            ),
            Positioned(
              bottom: Get.height * .40,
              right: 0,
              child: Container(
                width: Get.width * .5,
                height: 80,
                decoration: BoxDecoration(
                  color: buttonColor.withOpacity(.5),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(100),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                width: Get.width,
                height: Get.height * .44,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30),
                  ),
                  gradient: LinearGradient(
                    colors: [primaryColor, secondColor],
                    begin: Alignment.center,
                    end: Alignment.topRight,
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        height: Get.height * .01,
                      ),
                      RichText(
                        text: TextSpan(
                          style: Get.textTheme.headline3,
                          children: const [
                            TextSpan(
                                text: 'My',
                                style: TextStyle(
                                    color: buttonColor,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Anton')),
                            TextSpan(
                                text: 'Shop',
                                style: TextStyle(
                                    color: Colors.white, fontFamily: 'Anton')),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: Get.height * .04,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Lorem ipsum dolor sit amet, consLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                          textAlign: TextAlign.center,
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(
                        height: Get.height * .08,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Get.offAllNamed(loginScreen);
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 75, vertical: 15),
                          child: Text(
                            'Get Started',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
