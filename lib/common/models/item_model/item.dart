

import 'package:template/common/models/item_model/seller.dart';

class ItemModel {
  final int id;
  final String description;
  final SellerModel seller;
  final List<String> album;

  ItemModel({
    required this.id, 
    required this.description, 
    required this.seller, 
    required this.album
  });


  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id'],
      description: json['description'],
      seller: SellerModel.fromJson(json['user']),
      album: List<String>.from(json['album'])
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'description': description,
    'user': seller.toJson(),
    'album': album
  };
}