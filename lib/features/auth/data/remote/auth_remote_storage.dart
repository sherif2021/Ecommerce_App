import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/features/auth/data/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class AuthRemoteStorage {
  Future<User?> signInWithAuthCredential(AuthCredential credential) async {
    return (await FirebaseAuth.instance.signInWithCredential(credential)).user;
  }

  Future<bool> setAuthData(UserModel user) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set(user.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<UserModel?> getUserData(String uid) async {
    final result =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return result.exists ? UserModel.fromMap(uid, result.data()!) : null;
  }

  Stream<UserModel?> getStreamUserData(String uid) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((snapshot) => snapshot.exists
            ? UserModel.fromMap(snapshot.id, snapshot.data()!)
            : null);
  }

  Future<bool> editUserInfo(UserModel user) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update(user.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<String?> uploadImage(String path) async {
    if (path.startsWith('http')) return path;

    final storagePath = 'pics/${const Uuid().v4()}.jpg';
    final file = File(path);
    final result =
        await FirebaseStorage.instance.ref(storagePath).putFile(file);

    return result.totalBytes == file.lengthSync()
        ? await FirebaseStorage.instance.ref(storagePath).getDownloadURL()
        : null;
  }

  Future<bool> deleteImage(String url) async {
    try {
      await FirebaseStorage.instance.refFromURL(url).delete();
      return true;
    } catch (e) {
      return false;
    }
  }
}
