import 'package:ecommerce/features/user/data/model/cart_model.dart';
import 'package:ecommerce/features/user/data/model/shopping_address_model.dart';

class OrderModel {
  final String? id;
  final String cartId;
  final String tranRef;
  int status;
  final String userUID;
  final ShoppingAddressModel shoppingAddress;
  final String deliveryCompanyName;
  final double deliveryCost;
  final List<CartModel> items;
  final double cost;
  final DateTime time;

  OrderModel(
      {this.id,
      required this.cartId,
      required this.tranRef,
      required this.status,
      required this.userUID,
      required this.shoppingAddress,
      required this.deliveryCompanyName,
      required this.deliveryCost,
      required this.cost,
      required this.items,
      required this.time});

  Map<String, dynamic> toMap() => {
        'cartId': cartId,
        'tranRef': tranRef,
        'status': status,
        'userUID': userUID,
        'shoppingAddress': shoppingAddress.toMap(),
        'deliveryCompanyName': deliveryCompanyName,
        'deliveryCost': deliveryCost,
        'cost': cost,
        'items': items.map((e) => e.toMap()).toList(),
        'time': time.toUtc().millisecondsSinceEpoch
      };

  factory OrderModel.fromMap(String id, Map<String, dynamic> map) => OrderModel(
      id: id,
      cartId: map['cartId'],
      tranRef: map['tranRef'],
      status: map['status'],
      userUID: map['userUID'],
      shoppingAddress: ShoppingAddressModel.fromMap(map['shoppingAddress']),
      deliveryCompanyName: map['deliveryCompanyName'],
      deliveryCost: map['deliveryCost'],
      cost: map['cost'],
      items: (map['items'] as List).map((e) => CartModel.fromMap(e)).toList(),
      time: DateTime.fromMillisecondsSinceEpoch(map['time'], isUtc: true));
}
