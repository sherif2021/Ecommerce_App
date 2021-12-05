class DeliveryMethodModel {
  final String name;
  final String logoPath;
  final double cost;
  final String time;

  DeliveryMethodModel(
      {required this.name,
      required this.logoPath,
      required this.cost,
      required this.time});

  Map<String, dynamic> toMap() => {
        'name': name,
        'logoPath': logoPath,
        'cost': cost,
        'time': time,
      };

  factory DeliveryMethodModel.fromMap(Map<String, dynamic> map) =>
      DeliveryMethodModel(
        name: map['name'],
        logoPath: map['logoPath'],
        cost: map['cost'],
        time: map['time'],
      );
}
