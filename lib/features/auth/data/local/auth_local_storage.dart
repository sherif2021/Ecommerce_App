
import 'package:get_storage/get_storage.dart';

class AuthLocalStorage {
  final _box = GetStorage('auth');

  Future<void> saveVerificationId(String? verificationId) async {
    if (verificationId == null) {
      await _box.remove('verificationId');
    } else {
      await _box.write('verificationId', verificationId);
    }
    return _box.save();
  }

  String? getVerificationId() {
    return _box.read('verificationId');
  }

  Future<void> savePhoneNumber(String phoneNumber) async {
    await _box.write('phone', phoneNumber);
    return _box.save();
  }

  String? getPhoneNumber() {
    return _box.read('phone');
  }

  bool isVerifying() {
    return _box.hasData('verificationId');
  }

  Future<void> removeUID() async {
    await _box.remove('uid');
    return await _box.save();
  }

  Future<void> saveUserUID(String uid) async {
    await _box.write('uid', uid);
    return await _box.save();
  }

  String? getUserUID() {
    return _box.read('uid');
  }
  Future<void> saveSkippingLogin(bool status) async {
    await _box.write('skippingLogin', status);
    return _box.save();
  }

  bool getSkippingLogin() {
    return !_box.hasData('skippingLogin') ? false : _box.read('skippingLogin') as bool;
  }
}
