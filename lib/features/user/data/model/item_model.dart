import 'package:ecommerce/features/user/data/model/image_model.dart';

class ItemModel {
  String? id;
  String title;
  List<ImageModel> pics;
  List<ImageModel> colors;
  List<String> sizes;
  double price;
  double discount;
  double rating;
  String catId;
  bool inStock;

  ItemModel(
      {this.id,
      required this.title,
      required this.pics,
      required this.colors,
      required this.sizes,
      required this.price,
      required this.discount,
      required this.rating,
      required this.catId,
      required this.inStock});

  Map<String, dynamic> toMap({bool addId = false}) {
    final map = {
      'title': title,
      'pics': pics.map((e) => e.url).toList(),
      'colors': colors.map((e) => e.url).toList(),
      'sizes': sizes,
      'price': price,
      'discount': discount,
      'rating': rating,
      'cat': catId,
      'stock': inStock,
    };
    if (addId) {
      map['id'] = id!;
    }
    return map;
  }

  factory ItemModel.fromMap(String id, Map<String, dynamic> map) => ItemModel(
      id: id,
      title: map['title'],
      pics: (map['pics'] as List).map((e) => ImageModel(url: e)).toList(),
      colors: (map['colors'] as List).map((e) => ImageModel(url: e)).toList(),
      sizes: (map['sizes'] as List).cast(),
      price: double.tryParse(map['price'].toString()) ?? 0,
      discount: double.tryParse(map['discount'].toString()) ?? 0,
      rating: double.tryParse(map['rating'].toString()) ?? 0,
      inStock: map['stock'] ?? true,
      catId: map['cat']);
}
