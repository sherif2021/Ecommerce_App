class UserModel {
  final String uid;
  String? name;
  String? pic;
  String phoneNumber;
  final bool isAdmin;
  final String provider;
  final String? email;

  UserModel({
    required this.uid,
    this.name,
    this.pic,
    this.email,
    required this.phoneNumber,
    required this.isAdmin,
    required this.provider,
  });

  factory UserModel.fromMap(String uid, Map<String, dynamic> map) => UserModel(
      uid: uid,
      name: map['name'],
      pic: map['pic'],
      phoneNumber: map['phone'],
      isAdmin: map['isAdmin'],
      email: map['email'],
      provider: map['provider']);

  Map<String, dynamic> toMap({bool withUID = false}) {
    final map = <String, dynamic>{};

    map['name'] = name;
    map['pic'] = pic;
    map['phone'] = phoneNumber;
    map['isAdmin'] = isAdmin;
    map['email'] = email;
    map['provider'] = provider;

    if (withUID) {
      map['uid'] = uid;
    }

    return map;
  }
}
