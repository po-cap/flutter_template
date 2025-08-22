
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

enum MsgType{
  ping,           // 預留
  text,           // 文字
  sticker,        // 貼圖
  image,          // 圖片
  video,          // 影片
  join,           // 加入
  exit,           // 離開
  read,           // 讀取
  unreadCount,    // 未讀取數量（拿掉）
  unreadMessages, // 未讀取訊息
  chatroom,       // 取得聊天室資訊（拿掉）
}

class MessageModel{

  /// id: 訊息編號
  final int id;

  /// 聊天室 uri
  final String uri;

  /// from: 訊息來源
  final int receiverId;

  /// content: 訊息內容
  final String content;

  /// type: 訊息類型
  final MsgType type; 

  /// exception: 錯誤
  final int status;

  /// tag
  final String? tag;

  final AssetEntity? asset;


  MessageModel({
    required this.id, 
    required this.uri,
    required this.receiverId, 
    required this.content, 
    this.type = MsgType.text,
    this.status = 0,
    this.tag,
    this.asset
  });

  MessageModel copyWith({
    int? id,
    String? uri,
    int? receiverId,
    String? content,
    MsgType? type,
    int? status,
    String? tag
  }) {
    return MessageModel(
      id: id ?? this.id,
      uri: uri ?? this.uri,
      receiverId: receiverId ?? this.receiverId,
      content: content ?? this.content,
      type: type ?? this.type,
      status: status ?? this.status,
      tag: tag ?? this.tag
    );
  }

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      uri: json['uri'],
      receiverId: json['receiverId'],
      content: json['content'],
      type: MsgType.values[json['type']],
      status: 0,
      tag: json['tag']
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'uri': uri,
    'receiverId': receiverId,
    'content': content,
    'type': type.index,
    'status': status,
    'tag': tag
  };
}

