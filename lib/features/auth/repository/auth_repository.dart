import 'package:ecommerce/features/auth/data/local/auth_local_storage.dart';
import 'package:ecommerce/features/auth/data/model/user_model.dart';
import 'package:ecommerce/features/auth/data/remote/auth_remote_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthRepository {
  final _authRemoteStorage = Get.put(AuthRemoteStorage());
  final _authLocalStorage = Get.put(AuthLocalStorage());

  Future<String?> signInWithCredential(
      {required AuthCredential credential,
      required String provider,
      String? email}) async {
    final firebaseUser =
        await _authRemoteStorage.signInWithAuthCredential(credential);

    if (firebaseUser != null) {
      final user = await _authRemoteStorage.getUserData(firebaseUser.uid);

      if (user == null) {
        final insertUser = UserModel(
            uid: firebaseUser.uid,
            phoneNumber: firebaseUser.phoneNumber ?? '',
            email: firebaseUser.email,
            name: firebaseUser.displayName,
            pic: firebaseUser.photoURL,
            isAdmin: false,
            provider: provider);
        final result = await _authRemoteStorage.setAuthData(insertUser);

        if (result) {
          return insertUser.uid;
        }
      } else {
        return user.uid;
      }
    }
    return null;
  }

  Future<void> saveVerificationId(String? verificationId) async {
    return await _authLocalStorage.saveVerificationId(verificationId);
  }

  String? getVerificationId() {
    return _authLocalStorage.getVerificationId();
  }

  Future<void> savePhoneNumber(String phoneNumber) async {
    return await _authLocalStorage.savePhoneNumber(phoneNumber);
  }

  String? getPhoneNumber() {
    return _authLocalStorage.getPhoneNumber();
  }

  bool isLogin() {
    return _authLocalStorage.getUserUID() != null &&
        FirebaseAuth.instance.currentUser != null;
  }

  bool isVerifying() {
    return _authLocalStorage.isVerifying();
  }

  bool isSkippingLogin() {
    return _authLocalStorage.getSkippingLogin();
  }

  Future<void> setIsSkippingLogin() async {
    await _authLocalStorage.saveSkippingLogin(true);
  }

  Future<void> saveUserUID(String uid) async {
    return await _authLocalStorage.saveUserUID(uid);
  }

  String? getUserUID() {
    return _authLocalStorage.getUserUID();
  }

  void logout() {
    _authLocalStorage.removeUID();
    FirebaseAuth.instance.signOut();
  }
}
