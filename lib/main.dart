import 'package:ecommerce/utility/app_router.dart';
import 'package:ecommerce/utility/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';

import 'features/auth/repository/auth_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init('auth');
  await GetStorage.init('user');

  runApp(Ecommerce());
}

class Ecommerce extends StatelessWidget {
  Ecommerce({Key? key}) : super(key: key);
  final appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    final authRepository = Get.put(AuthRepository());

    return LayoutBuilder(
      builder: (_, size) => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Ecommerce',
        theme: ThemeData(
          primarySwatch: buttonColor,
          //brightness: SchedulerBinding.instance?.window.platformBrightness
        ),
        onGenerateRoute: appRouter.onGenerateRoute,
        initialRoute: authRepository.isLogin() || authRepository.isSkippingLogin()
            ? homeScreen
            : authRepository.isVerifying()
                ? verificationScreen
                : onBoardingScreen,
      ),
    );
  }
}
