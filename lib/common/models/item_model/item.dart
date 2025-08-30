

import 'package:template/common/index.dart';


class ItemModel {
  final int id;
  final String description;
  final UserProfileModel seller;
  final List<String> album;
  final Map<String, dynamic> spec;
  final double shippingFee;

  ItemModel({
    required this.id, 
    required this.description, 
    required this.seller, 
    required this.album,
    required this.spec,
    required this.shippingFee
  });


  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id'],
      description: json['description'],
      seller: UserProfileModel.fromJson(json['user']),
      album: List<String>.from(json['album']),
      spec: json['spec'],
      shippingFee: double.parse(json['shippingFee'].toString())
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'description': description,
    'user': seller.toJson(),
    'album': album,
    'spec': spec,
    'shippingFee': shippingFee
  };
}