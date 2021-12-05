import 'package:ecommerce/features/user/data/model/image_model.dart';
import 'package:ecommerce/features/user/data/model/item_model.dart';

class CategoryModel {
  int index;
  String? id;
  String name;
  ImageModel pic;
  int type;
  List<ItemModel>? items;

  // type 0 > normal
  // type 1 > slider
  // type 2 > sub

  CategoryModel(
      {this.id,
      required this.index,
      required this.name,
      required this.pic,
      required this.type,
      this.items});

  Map<String, dynamic> toMap() => {
        'index': index,
        'name': name,
        'pic': pic.url,
        'type': type,
      };

  factory CategoryModel.fromMap(String id, Map<String, dynamic> map) =>
      CategoryModel(
          id: id,
          index: map['index'],
          name: map['name'],
          pic: ImageModel(url: map['pic']),
          type: map['type']);
}
