import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/features/user/data/model/category_model.dart';
import 'package:ecommerce/features/user/data/model/item_model.dart';
import 'package:ecommerce/features/user/data/model/order_model.dart';
import 'package:ecommerce/features/user/data/model/payment_request_model.dart';
import 'package:ecommerce/features/user/data/model/payout_info_model.dart';
import 'package:ecommerce/features/user/data/model/shopping_address_model.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class MainRemoteStorage {
  final _instance = FirebaseFirestore.instance
    ..settings = const Settings(
      persistenceEnabled: true,
      sslEnabled: true,
    );
  final _instanceWithoutCache = FirebaseFirestore.instance
    ..settings = const Settings(
      persistenceEnabled: false,
      sslEnabled: true,
    );

  Stream<List<CategoryModel>?> getCategories() {
    return _instance.collection('cats').snapshots().map((snapshots) => snapshots
        .docs
        .map((e) => CategoryModel.fromMap(e.id, e.data()))
        .toList());
  }

  Stream<List<ItemModel>?> getItemsWithStream(List<String> itemsId) {
    return _instanceWithoutCache
        .collection('items')
        .where(FieldPath.documentId, whereIn: itemsId)
        .snapshots()
        .map((snapshots) => snapshots.docs
            .map((e) => ItemModel.fromMap(e.id, e.data()))
            .toList());
  }

  Future<List<ItemModel>?> getItems(List<String> itemsId) async {
    return (await _instanceWithoutCache
            .collection('items')
            .where(FieldPath.documentId, whereIn: itemsId)
            .get())
        .docs
        .map((e) => ItemModel.fromMap(e.id, e.data()))
        .toList();
  }

  Future<List<ItemModel>> getItemsByCat(String catId) async {
    return (await _instance
            .collection('items')
            .where('cat', isEqualTo: catId)
            .get())
        .docs
        .map((e) => ItemModel.fromMap(e.id, e.data()))
        .toList();
  }

  Future<PayoutInfoModel?> getPayoutInfo() async {
    try {
      return PayoutInfoModel.fromMap(
          (await _instance.collection('payoutInfo').get()).docs.first.data());
    } catch (e) {
      return null;
    }
  }

  Future<PaymentRequestModel?> makePayout(
      {required double amount,
      required ShoppingAddressModel shoppingAddress,
      required double exchangeRate,
      required PayoutInfoModel payoutInfo}) async {
    final result = await http.post(Uri.parse(payoutInfo.requestURL),
        headers: {
          'Content-Type': 'application/json',
          'authorization': payoutInfo.authorization
        },
        body: const JsonEncoder().convert({
          "profile_id": payoutInfo.profileId,
          "tran_type": "sale",
          "tran_class": "ecom",
          "cart_description": "Ecommerce cart",
          "cart_id": const Uuid().v4(),
          "cart_currency": "egp",
          "cart_amount": amount * exchangeRate,
          "callback": "https://google.com/",
          "return": "https://google.com/",
          "hide_shipping": true,
          "customer_details": {
            "name": shoppingAddress.name,
            "email": shoppingAddress.email,
            "phone": shoppingAddress.phoneNumber,
            "street1": shoppingAddress.street,
            "city": shoppingAddress.city,
            "state": shoppingAddress.state,
            "country": shoppingAddress.country,
          },
        }));

    if (result.statusCode == 200) {
      final json = const JsonDecoder().convert(result.body) as Map;

      if (json.containsKey('tran_ref') &&
          json.containsKey('cart_id') &&
          json.containsKey('redirect_url')) {
        return PaymentRequestModel(
            tranRef: json['tran_ref'],
            cartId: json['cart_id'],
            redirectUrl: json['redirect_url']);
      }
    }
    return null;
  }

  Future<bool> checkPayoutStatus(
      String tranRef, PayoutInfoModel payoutInfo) async {
    final result = await http.post(Uri.parse(payoutInfo.checkURL),
        headers: {
          'Content-Type': 'application/json',
          'authorization': payoutInfo.authorization
        },
        body: const JsonEncoder().convert(
            {'profile_id': payoutInfo.profileId, 'tran_ref': tranRef}));

    if (result.statusCode == 200) {
      final json = const JsonDecoder().convert(result.body);
      return json['payment_result']['response_status'] == 'A';
    }
    return false;
  }

  Future<bool> sendOrder(OrderModel order) async {
    try {
      await _instanceWithoutCache.collection('orders').add(order.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  Stream<List<OrderModel>?> getOrders(String uid) {
    return _instanceWithoutCache
        .collection('orders')
        .where('userUID', isEqualTo: uid)
        .orderBy('time')
        .snapshots()
        .map((data) =>
            data.docs.map((e) => OrderModel.fromMap(e.id, e.data())).toList());
  }
}
