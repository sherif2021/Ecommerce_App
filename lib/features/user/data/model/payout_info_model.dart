class PayoutInfoModel {
  String requestURL;
  String checkURL;
  String authorization;
  String profileId;

  PayoutInfoModel(
      {required this.requestURL,
      required this.checkURL,
      required this.authorization,
      required this.profileId});

  Map<String, dynamic> toMap() => {
        'requestURL': requestURL,
        'checkURL': checkURL,
        'authorization': authorization,
        'profileId': profileId,
      };

  factory PayoutInfoModel.fromMap(Map<String, dynamic> map) => PayoutInfoModel(
        requestURL: map['requestURL'],
        checkURL: map['checkURL'],
        authorization: map['authorization'],
        profileId: map['profileId'],
      );
}
