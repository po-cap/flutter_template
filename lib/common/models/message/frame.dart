

import 'package:template/common/index.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class FrameModel {

  /// 訊息類型
  final MsgType type;

  /// 訊息內容
  final String content;

  /// 訊息標籤
  final String? tag;

  final AssetEntity? asset;

  FrameModel({
    required this.type, 
    this.content = "",
    this.tag,
    this.asset
  });

  copyWith({
    MsgType? type, 
    String? content,
    String? tag,
    AssetEntity? asset
  }) {
    return FrameModel(
      type: type ?? this.type, 
      content: content ?? this.content,
      tag: tag ?? this.tag,
      asset: asset ?? this.asset
    );
  }

  factory FrameModel.fromJson(Map<String, dynamic> json) {
    return FrameModel(
      type: MsgType.values[json['type']], 
      content: json['content'],
      tag: json['tag']
    );
  }

  Map<String, dynamic> toJson() => {
    'type': type.index,
    'content': content,
    'tag': tag
  };

}