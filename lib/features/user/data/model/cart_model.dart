import 'package:ecommerce/features/user/data/model/image_model.dart';
import 'package:ecommerce/features/user/data/model/item_model.dart';

class CartModel {
  ItemModel? item;
  final String itemId;
  final ImageModel? selectedColor;
  final ImageModel wallImage;
  final String? selectedSize;
  int count;

  CartModel(
      {this.item,
      required this.itemId,
      this.selectedColor,
      this.selectedSize,
      required this.wallImage,
      required this.count});

  Map<String, dynamic> toMap() => {
        'itemId': itemId,
        'count': count,
        'color': selectedColor?.url,
        'wall': wallImage.url,
        'size': selectedSize,
      };

  factory CartModel.fromMap(Map<String, dynamic> map) => CartModel(
      itemId: map['itemId'],
      count: map['count'],
      selectedColor:
          map['color'] != null ? ImageModel(url: map['color']) : null,
      wallImage: ImageModel(url: map['wall']),
      selectedSize: map['size']);
}
