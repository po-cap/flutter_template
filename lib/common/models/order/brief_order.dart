class BriefOrderModel {
  final int id;
  final String avatar;
  final String displayName;
  final String cover;
  final String description;
  final double totalAmount;

  BriefOrderModel({
    required this.id, 
    required this.avatar, 
    required this.displayName, 
    required this.cover, 
    required this.description, 
    required this.totalAmount
  });

  factory BriefOrderModel.fromJson(Map<String, dynamic> json) {
    return BriefOrderModel(
      id: json['id'],
      avatar: json['avatar'],
      displayName: json['displayName'],
      cover: json['cover'],
      description: json['description'],
      totalAmount: json['totalAmount']
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'avatar': avatar,
    'displayName': displayName,
    'cover': cover,
    'description': description,
    'totalAmount': totalAmount
  };
}