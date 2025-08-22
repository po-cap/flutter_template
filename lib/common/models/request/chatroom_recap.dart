

import 'package:template/common/index.dart';

class ChatroomRecapRes {
  final ChatroomModel chatroom;
  final List<MessageModel> messages;

  ChatroomRecapRes({
    required this.chatroom,
    required this.messages
  });

  factory ChatroomRecapRes.fromJson(Map<String, dynamic> json) {
    return ChatroomRecapRes(
      chatroom: ChatroomModel.fromJson(json['chatroom']),
      messages: (json['messages'] as List).map((e) => MessageModel.fromJson(e)).toList()
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chatroom': chatroom.toJson(),
      'messages': messages.map((e) => e.toJson()).toList()
    };
  }
}