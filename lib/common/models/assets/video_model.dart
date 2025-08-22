

import 'package:template/common/models/index.dart';

class VideoModel {
  final AssetModel video;
  final AssetModel thumbnail;

  VideoModel({
    required this.video, 
    required this.thumbnail,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) => VideoModel(
    video: AssetModel.fromJson(json['video']),
    thumbnail: AssetModel.fromJson(json['thumbnail']),
  );

  Map<String, dynamic> toJson() => {
    'video': video.toJson(),
    'thumbnail': thumbnail.toJson(),
  };
}