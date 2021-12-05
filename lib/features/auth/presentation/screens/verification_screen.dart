import 'dart:async';
import 'package:ecommerce/features/auth/presentation/logic/auth_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce/utility/constants.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({Key? key}) : super(key: key);

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  
  final  controller = Get.put(AuthController(), tag: 'login');
  
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        _backHandle();
        return Future.value(false);
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: Get.width,
                height:
                    MediaQuery.of(context).orientation == Orientation.portrait
                        ? Get.height * .25
                        : Get.height * .40,
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: BackButton(
                        onPressed: _backHandle,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15, left: 20),
                      child: Text(
                        'Verification \nCode',
                        style: Get.textTheme.headline4!.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            wordSpacing: 3,
                            fontSize: 25),
                        textAlign: TextAlign.start,
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 40),
                child: Text(
                  'Please enter code sent to',
                  style: Get.textTheme.bodyText2!
                      .copyWith(fontWeight: FontWeight.w400),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 10),
                child: Obx(() => Text(
                      controller.phoneNumber.value,
                      style: Get.textTheme.headline6!.copyWith(fontSize: 15),
                    )),
              ),
              SizedBox(
                height: Get.height * .03,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: SizedBox(
                    height: 50,
                    width: Get.width,
                    child: Obx(
                      () => PinCodeTextField(
                        length: 6,
                        keyboardType: TextInputType.phone,
                        animationType: AnimationType.fade,
                        enabled: !controller.isLoading.value,
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.underline,
                          borderRadius: BorderRadius.circular(5),
                          fieldHeight: 40,
                          borderWidth: 0,
                        ),
                        animationDuration: const Duration(milliseconds: 300),
                        onCompleted: (v) {
                          controller.verify();
                        },
                        onSubmitted: (v) {
                          controller.verify();
                        },
                        appContext: context,
                        onChanged: (String value) =>
                            controller.code = value,
                      ),
                    )),
              ),
              SizedBox(
                height: Get.height * .03,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: TextButton(
                      onPressed: _back,
                      child: Text(
                        'Change Phone Number?',
                        style: Get.textTheme.button!.copyWith(
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: Get.height * .03,
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
                            : controller.verify,
                        color: buttonColor,
                        disabledColor: Colors.grey,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: const Text(
                          'Continue',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                      ),
                    ),
                  )),
              Obx(() => Center(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: controller.isLoading.value
                        ? const CircularProgressIndicator()
                        : const SizedBox(
                            height: 35,
                          ),
                  ))),
              SizedBox(
                height: Get.height * .05,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(() => TextButton(
                        onPressed: !controller.isLoading.value &&
                                controller.isResendCodeEnable.value
                            ? _resendCode
                            : null,
                        child: Text(
                          'Resend Code',
                          style: Get.textTheme.caption!.copyWith(
                              fontSize: 15, fontWeight: FontWeight.w700),
                        ),
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    controller.getPhoneNumber();
    controller.isLoggedIn.listen(_loggedInChanged);
  }

  void _loggedInChanged(bool state) {
    if (state) {
      Get.offAllNamed(homeScreen);
      Get.delete<AuthController>(tag: 'verify');
    } else {
      Get.showSnackbar(GetBar(
        title: 'Auth Error!',
        message: 'Error While Authentication, please make sure and try again.',
        duration: const Duration(seconds: 5),
      ));
    }
  }

  void _resendCode() async {
    if (controller.isResendCodeEnable.value) {
      controller.isResendCodeEnable.value = false;
      controller.sendVerificationCode();
      await Future.delayed(const Duration(minutes: 2));
      controller.isResendCodeEnable.value = true;
    }
  }

  void _backHandle() {
    Get.defaultDialog(
        title: 'Back Confirm!',
        middleText: 'Are you sure you want to go back?',
        textConfirm: 'Yes',
        textCancel: 'No',
        onConfirm: _back);
  }

  void _back() async {
    await controller.clearVerificationId();
    Get.offAllNamed(loginScreen);
    Get.delete<AuthController>(tag: 'verify');
  }
}
