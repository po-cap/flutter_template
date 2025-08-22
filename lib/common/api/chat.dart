

import 'dart:async';
import 'dart:convert';

import 'package:template/common/index.dart';

class ChatApi {

  static Future unReadMessages() async {
    final frame = FrameModel(
      type: MsgType.unreadMessages, 
      content: ""
    );

    ChatService.to.onSend(frame);
  }

  static Future onRead(
    List<MessageModel> messages
  ) async {
    final frame = FrameModel(
      type: MsgType.read, 
      content: jsonEncode(messages.map((e) => e.id).toList())
    );
    ChatService.to.onSend(frame);
  }

  static Future<List<ChatroomModel>> getChatrooms(
    Iterable<String> uris
  ) async {
    final response = await WPHttpService.to.get(
      '/chat',
      params: {
        'uri': uris.toList()
      }
    );

    List<ChatroomModel> rooms = [];
    for(var data in response.data) {
      rooms.add(ChatroomModel.fromJson(data));
    }

    return rooms;
  }

  static Future<ChatroomModel> getChatroom(
    String uri
  ) async {
    final response = await WPHttpService.to.get(
      '/chat',
      params: {
        'uri': List<String>.from([uri])
      }
    );

    List<ChatroomModel> rooms = [];
    for(var data in response.data) {
      rooms.add(ChatroomModel.fromJson(data));
    }

    return rooms[0];
  }

}