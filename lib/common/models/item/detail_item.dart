import 'package:template/common/index.dart';

class DetailItemModel {
  final int id;
  final int sellerId;
  final String displayName;
  final String avatar;
  final String cover;
  final String description;
  final int price;
  final List<String> assets;
  final bool isVideo;
  final double shippingFee;
  final List<SkuModel> skus;

  DetailItemModel({
    required this.id, 
    required this.sellerId, 
    required this.displayName, 
    required this.avatar, 
    required this.cover, 
    required this.description, 
    required this.price, 
    required this.assets, 
    required this.isVideo, 
    required this.shippingFee, 
    required this.skus
  });

  factory DetailItemModel.fromJson(Map<String, dynamic> json) {
    return DetailItemModel(
      id: json['id'],
      sellerId: json['sellerId'],
      displayName: json['displayName'],
      avatar: json['avatar'],
      cover: json['cover'],
      description: json['description'],
      price: json['price'],
      assets: json['assets'],
      isVideo: json['isVideo'],
      shippingFee: json['shippingFee'],
      skus: json['skus']
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'sellerId': sellerId,
    'displayName': displayName,
    'avatar': avatar,
    'cover': cover,
    'description': description,
    'price': price,
    'assets': assets,
    'isVideo': isVideo,
    'shippingFee': shippingFee,
    'skus': skus
  };

}