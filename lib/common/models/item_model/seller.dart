

class SellerModel {
  final int id;
  final String diaplayName;
  final String avatar;

  SellerModel({
    required this.id, 
    required this.diaplayName, 
    required this.avatar
  });

  factory SellerModel.fromJson(Map<String, dynamic> json) {
    return SellerModel(
      id: json['id'],
      diaplayName: json['displayName'],
      avatar: json['avatar']
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'displayName': diaplayName,
    'avatar': avatar
  };
}