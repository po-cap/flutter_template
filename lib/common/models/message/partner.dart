
class PartnerModel {
  final int id;
  final String displayName;
  final String avatar;

  PartnerModel({
    required this.id,
    required this.displayName,
    required this.avatar
  });

  factory PartnerModel.fromJson(Map<String, dynamic> json) {
    return PartnerModel(
      id: json['id'],
      displayName: json['displayName'],
      avatar: json['avatar']
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'displayName': displayName,
    'avatar': avatar
  };
}