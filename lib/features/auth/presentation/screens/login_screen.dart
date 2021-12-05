import 'dart:io';
import 'package:ecommerce/features/auth/presentation/logic/auth_controller.dart';
import 'package:ecommerce/utility/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthController controller = Get.put(AuthController(), tag: 'login');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: Get.width,
              height: MediaQuery.of(context).orientation == Orientation.portrait
                  ? Get.height * .23
                  : Get.height * .35,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(1000),
                ),
                gradient: LinearGradient(
                  colors: [primaryColor, secondColor],
                  begin: Alignment.center,
                  end: Alignment.topRight,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 60, left: 20),
                child: Text(
                  ' What Is Your Phone \n Number?',
                  style: Get.textTheme.headline4!.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontSize: 25),
                  textAlign: TextAlign.start,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 40),
              child: Text(
                'Please enter your phone number to verify your account',
                style: Get.textTheme.bodyText2!
                    .copyWith(fontWeight: FontWeight.w400),
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
                child: Obx(
                  () => InternationalPhoneNumberInput(
                    isEnabled: !controller.isLoading.value,
                    onInputChanged: (PhoneNumber phoneNumber) {
                      controller.phoneNumber.value = phoneNumber.phoneNumber!;
                    },
                    onFieldSubmitted: (v) {
                      controller.sendVerificationCode();
                    },
                    autoValidateMode: AutovalidateMode.onUserInteraction,
                    selectorConfig: const SelectorConfig(
                      selectorType: PhoneInputSelectorType.DIALOG,
                    ),
                  ),
                )),
            SizedBox(
              height: Get.height * .04,
            ),
            Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                child: SizedBox(
                  width: Get.width,
                  child: Obx(
                    () => MaterialButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : controller.sendVerificationCode,
                      color: buttonColor,
                      disabledColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: const Text(
                        'Send Verification Code',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                    ),
                  ),
                )),
            Row(
              children: [
                const Spacer(),
                TextButton(
                    onPressed: () {
                      controller.setIsSkippingLogin();
                      Get.offAllNamed(homeScreen);
                    },
                    child: const Text('Not Now.')),
                const SizedBox(width: 10,),
              ],
            ),
            Obx(() => Center(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator()
                      : const SizedBox(
                          height: 35,
                        ),
                ))),
            Row(
              children: const [
                Expanded(
                    child: Divider(
                  height: 30,
                  endIndent: 30,
                  indent: 30,
                )),
                Text('OR'),
                Expanded(
                    child: Divider(
                  height: 30,
                  endIndent: 30,
                  indent: 30,
                )),
              ],
            ),
            SizedBox(
              height: Get.height * .08,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: controller.signInWithGoogle,
                    icon: Image.asset('assets/icons/google.png')),
                const SizedBox(
                  width: 30,
                ),
                IconButton(
                    onPressed: controller.signInWithFacebook,
                    icon: Image.asset('assets/icons/facebook.png')),
                if (Platform.isIOS)
                  const SizedBox(
                    width: 30,
                  ),
                if (Platform.isIOS)
                  IconButton(
                      onPressed: controller.signInWithApple,
                      icon: Image.asset('assets/icons/apple.png')),
              ],
            ),
            SizedBox(
              height: Get.height * .08,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    controller.isCodeSent.listen(_codeSentChanged);
    controller.isLoggedIn.listen(_loggedInChanged);
  }

  void _codeSentChanged(bool state) {
    if (state) {
      Get.offAllNamed(verificationScreen);
      Get.delete(tag: 'login');
    } else {
      Get.showSnackbar(GetBar(
        title: 'Auth Error!',
        message: 'There an Error while send a verification code to your phone.',
        duration: const Duration(seconds: 5),
      ));
    }
  }

  void _loggedInChanged(bool state) {
    if (state) {
      Get.offAllNamed(homeScreen);
      Get.delete<AuthController>();
    }
  }
}
