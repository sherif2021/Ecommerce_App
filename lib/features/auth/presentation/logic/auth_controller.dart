import 'package:ecommerce/features/auth/repository/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController extends GetxController {
  final authRepository = Get.put(AuthRepository());

  final phoneNumber = ''.obs;

  final isCodeSent = false.obs;

  final isLoggedIn = false.obs;

  final isLoading = false.obs;

  final isResendCodeEnable = true.obs;

  String code = '';

  void sendVerificationCode() async {
    if (phoneNumber.value.isPhoneNumber) {
      isLoading.value = true;

      FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber.value,
        verificationCompleted: (PhoneAuthCredential credential) {
          _handleCredential(credential, 'phone');
        },
        verificationFailed: (FirebaseAuthException e) {
          isLoading.value = false;
          isCodeSent.value = false;
        },
        codeSent: (String verificationId, int? resendToken) {
          _handleCodeSent(verificationId);
        },
        codeAutoRetrievalTimeout: _handleCodeSent,
      );
    }
  }

  void verify() async {
    try {
      isLoading.value = true;

      final verificationId = authRepository.getVerificationId();

      if (verificationId != null && code.length == 6) {
        await _handleCredential(
            PhoneAuthProvider.credential(
                verificationId: verificationId, smsCode: code),
            'phone');
      }
    } catch (e) {
      isLoggedIn.value = false;
    }
    isLoading.value = false;
  }

  void getPhoneNumber() async {
    final phone =  authRepository.getPhoneNumber();
    phoneNumber.value = phone ?? '';
  }

  void signInWithGoogle() async {
    isLoading.value = true;
    final googleUser = await GoogleSignIn().signIn();

    if (googleUser != null) {
      final googleAuth = await googleUser.authentication;

      _handleCredential(
          GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          ),
          'google');
    }
    isLoading.value = false;
  }

  void signInWithFacebook() async {
    isLoading.value = true;
    final facebookUser = await FacebookAuth.instance.login();

    if (facebookUser.accessToken != null) {
      _handleCredential(
          FacebookAuthProvider.credential(facebookUser.accessToken!.token),
          'facebook');
    }
    isLoading.value = false;
  }

  void signInWithApple() async {}

  Future<void> clearVerificationId() async {
    await authRepository.saveVerificationId(null);
  }

  void _handleCodeSent(String verificationId) async {
    await authRepository.savePhoneNumber(phoneNumber.value);
    await authRepository.saveVerificationId(verificationId);

    isLoading.value = false;
    isCodeSent.value = true;
  }

  Future<void> _handleCredential(
      AuthCredential credential, String provider) async {
    final result = await authRepository.signInWithCredential(
        credential: credential, provider: provider);

    if (result != null) {
      await authRepository.saveUserUID(result);
      await authRepository.saveVerificationId(null);
      isLoggedIn.value = true;
    } else {
      isLoggedIn.value = false;
    }
  }
  bool isSkippingLogin() {
    return authRepository.isSkippingLogin();
  }

  void setIsSkippingLogin() {
    authRepository.setIsSkippingLogin();
  }
}
