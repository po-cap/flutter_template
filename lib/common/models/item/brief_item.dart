
class BriefItemModel {
  final int id;
  final int sellerId;
  final String cover;
  final String description;
  final String price;
  final String displayName;
  final String avatar;

  BriefItemModel({
    required this.id, 
    required this.sellerId, 
    required this.cover, 
    required this.description, 
    required this.price, 
    required this.displayName, 
    required this.avatar
  });

  factory BriefItemModel.fromJson(Map<String, dynamic> json) {
    return BriefItemModel(
      id: json['id'],
      sellerId: json['sellerId'],
      cover: json['cover'],
      description: json['description'],
      price: json['price'],
      displayName: json['displayName'],
      avatar: json['avatar']
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'sellerId': sellerId,
    'cover': cover,
    'description': description,
    'price': price,
    'displayName': displayName,
    'avatar': avatar
  };
}