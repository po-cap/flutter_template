import 'package:template/common/index.dart';


class ChatroomModel {
  
  /// 對話的 uri 參數 
  final String uri;

  /// 聊天對象 ID
  final int partnerId;

  /// 聊天室標題
  final String title;

  /// 聊天室頭像
  final String avatar;

  /// 聊天室商品照片
  final String? photo;

  /// 最後一則訊息類型
  final MsgType? lastMessageType;

  /// 最後一則訊息
  final String? lastMessage;

  /// 更新時間
  final DateTime? updateAt;


  ChatroomModel({
    required this.uri, 
    required this.partnerId,
    required this.title, 
    required this.avatar, 
    required this.photo, 
    this.lastMessageType, 
    this.lastMessage,
    this.updateAt
  });

  int get itemId {
    return int.parse(uri.split('/')[1]);
  }

  int get buyerId {
    return int.parse(uri.split('/')[0]);
  }

  ChatroomModel copyWith({
    String? uri, 
    int? partnerId,
    String? title, 
    String? avatar, 
    String? photo, 
    MsgType? lastMessageType, 
    String? lastMessage,
    DateTime? updateAt
  }) {
    return ChatroomModel(
      uri: uri ?? this.uri, 
      partnerId: partnerId ?? this.partnerId,
      title: title ?? this.title, 
      avatar: avatar ?? this.avatar, 
      photo: photo ?? this.photo, 
      lastMessageType: lastMessageType ?? this.lastMessageType, 
      lastMessage: lastMessage ?? this.lastMessage,
      updateAt: updateAt ?? this.updateAt
    );  
  }

  factory ChatroomModel.fromJson(Map<String, dynamic> json) {
    return ChatroomModel(
      uri: json['uri'], 
      partnerId: json['partnerId'],
      title: json['title'], 
      avatar: json['avatar'], 
      photo: json['photo'], 
      lastMessageType: json['type'] == null ? null : MsgType.values[json['type']], 
      lastMessage: json['lastMessage'],
      updateAt: json['updateAt'] == null ? null : DateTime.fromMillisecondsSinceEpoch(json['updateAt']),
    );
  }

  Map<String, dynamic> toJson() => {
    'uri': uri, 
    'partnerId': partnerId,
    'title': title, 
    'avatar': avatar, 
    'photo': photo, 
    'lastMessageType': lastMessageType?.index, 
    'lastMessage': lastMessage,
    'updateAt': updateAt?.millisecondsSinceEpoch
  };
}
