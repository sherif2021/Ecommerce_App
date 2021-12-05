import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/features/auth/data/model/user_model.dart';
import 'package:ecommerce/features/user/data/model/category_model.dart';
import 'package:ecommerce/features/user/data/model/item_model.dart';
import 'package:ecommerce/features/user/data/model/order_model.dart';

class AdminRemoteStorage {
  Future<bool> addOrEditItem(ItemModel item) async {
    try {
      if (item.id == null || item.id!.isEmpty) {
        final result = await FirebaseFirestore.instance.collection('items').add(
            item.toMap()
              ..putIfAbsent('created_at',
                  () => DateTime.now().toUtc().millisecondsSinceEpoch));
        if (result.id.isNotEmpty) {
          item.id = result.id;
          return true;
        }
      } else {
        await FirebaseFirestore.instance
            .collection('items')
            .doc(item.id)
            .update(item.toMap());
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  Future<bool> removeItem(String itemId) async {
    try {
      await FirebaseFirestore.instance.collection('items').doc(itemId).delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<ItemModel>> getItemsByCat(String? categoryId) async {
    final request = FirebaseFirestore.instance
        .collection('items')
        .orderBy('created_at', descending: false)
        .where('cat', isEqualTo: categoryId);

    return (await request.get())
        .docs
        .map((e) => ItemModel.fromMap(e.id, e.data()))
        .toList();
  }

  Future<List<ItemModel>> getItems(List<String> ids) async {
    return (await FirebaseFirestore.instance
            .collection('items')
            .where(FieldPath.documentId, whereIn: ids)
            //.orderBy('created_at', descending: false)
            .get())
        .docs
        .map((e) => ItemModel.fromMap(e.id, e.data()))
        .toList();
  }

  Future<List<ItemModel>> searchItems(String value) async {
    final List<String> ids = [];
    return (await FirebaseFirestore.instance
            .collection('items')
            .where('title', isGreaterThanOrEqualTo: value)
            .get())
        .docs
        .map((e) => ItemModel.fromMap(e.id, e.data()))
        .toList()
      ..removeWhere((e) {
        final remove = ids.contains(e.id);
        ids.add(e.id!);
        return remove;
      });
  }

  Future<bool> updateCategories(List<CategoryModel> categories) async {
    try {
      final batch = FirebaseFirestore.instance.batch();
      for (var cat in categories) {
        batch.set(FirebaseFirestore.instance.collection('cats').doc(cat.id),
            cat.toMap());
      }
      await batch.commit();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> removeCategory(String categoryId) async {
    try {
      await FirebaseFirestore.instance
          .collection('cats')
          .doc(categoryId)
          .delete();

      final items = await FirebaseFirestore.instance
          .collection('items')
          .where('cat', isEqualTo: categoryId)
          .get();

      final batch = FirebaseFirestore.instance.batch();
      for (var e in items.docs) {
        batch.delete(e.reference);
      }
      await batch.commit();
      return true;
    } catch (e) {
      return false;
    }
  }

  Stream<List<OrderModel>?> getOrders(int? status) {
    return FirebaseFirestore.instance
        .collection('orders')
        .where('status', isEqualTo: status)
        .snapshots()
        .map((data) =>
            data.docs.map((e) => OrderModel.fromMap(e.id, e.data())).toList());
  }

  Future<bool> changeOrderStatus(OrderModel order) async {
    try {
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(order.id!)
          .update(order.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<UserModel?> getUserData(String uid) async {
    try {
      final result =
          (await FirebaseFirestore.instance.collection('users').doc(uid).get());

      return result.data() != null
          ? UserModel.fromMap(result.id, result.data()!)
          : null;
    } catch (e) {
      return null;
    }
  }
}
