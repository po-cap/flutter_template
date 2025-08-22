import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/common/index.dart';
import 'package:web_socket_channel/io.dart';

class ChatService extends GetxService {
  static ChatService get to => Get.find();

  /// 未读消息总数
  final totalUnreadCount = 0.obs;

  /// 未读消息总数
  final isConnecting = true.obs;

  /// 未读消息
  RxMap<String, int> unReadCount = <String, int>{}.obs;

  /// 聊天室 uri，若非空，表示已進入聊天室
  String? uri;

  late IOWebSocketChannel _channel;

  late Stream<dynamic> _stream;
  
  late StreamSubscription _subscription;

  final List<StreamSubscription> _subscriptions = [];

  Timer? _reconnectTimer;
  
  @override
  void onClose() {
    super.onClose();
    onDisconnect();
  }

  /// 加入聊天室
  Future<StreamSubscription> onJoin({
    required String uri,
    Function(MessageModel message)? onReceive
  }) async {
    
    // 加入聊天室
    onSend(FrameModel(
      type: MsgType.join, 
      content: uri
    ));

    // 讀取聊天室
    onSend(FrameModel(
      type: MsgType.read
    ));

    // 設定 uri
    this.uri = uri;

    // 訂閱
    return onSubscribe(
      onData: onReceive ?? (_) {}
    );
  }

  /// 離開聊天室
  Future onExit({
    required StreamSubscription subscription
  }) async {
    final frame = FrameModel(
      type: MsgType.exit,
    );
    ChatService.to.onSend(frame);

    uri = null;

    ChatService.to.unSubscribe(
      subscription
    );
  }

  /// 接收消息，該做的事
  Future onGetMessage(
    MessageModel message
  ) async {

    // 更新未讀消息
    MessageRepo.to.insert(message);

    // 更新總未讀消息數量
    if(message.uri != uri) {
      totalUnreadCount.value += 1;

      if (unReadCount.containsKey(message.uri)) {
        unReadCount.update(message.uri, (val) => val + 1);
      } else {
        unReadCount[message.uri] = 1;
      }
    }

    // 更新聊天室
    await ChatroomRepo.to.getByUri(
      uri: message.uri
    ).then((room) async {
      if(room != null) {
        room = room.copyWith(
          lastMessageType: message.type,
          lastMessage: message.content
        );
      } else {
        room = await ChatApi.getChatroom(message.uri);
        room = room.copyWith(
          lastMessageType: message.type,
          lastMessage: message.content
        );
      }
      await ChatroomRepo.to.update(room);
    });
  }

  /// 处理未读消息
  Future onProcessUnreadMessages({
    required MessageModel message
  }) async {
    // 更新未讀消息
    List<MessageModel> messages = [];
    // 獲取所有未讀訊息數據
    for (var item in jsonDecode(message.content)) {
      messages.add(MessageModel.fromJson(item));
    }
    // 更新未讀訊息數量
    for (var msg in messages) {
      await onGetMessage(msg);
    }
  }

  /// 訂閱消息
  StreamSubscription onSubscribe({
    required Function(MessageModel message) onData
  }) {
    final subscription = _stream.listen((data) {
      final map = jsonDecode(data);
      final message = MessageModel.fromJson(map);
      onData.call(message);
    });

    _subscriptions.add(
      subscription
    );

    return subscription;
  }

  /// 取消訂閱
  void unSubscribe(
    StreamSubscription subscription
  ) {
    subscription.cancel();
    _subscriptions.remove(subscription);
  }

  Future _onConnect() async {

      // 連線
    _channel = IOWebSocketChannel.connect(
      Uri.parse('${Constants.wpSocketBaseUrl}/ws/chat'),
      headers: {
        'Authorization': 'Bearer ${UserService.to.accessToken}',
        'Connection': 'Upgrade',
        'Upgrade': 'websocket',
      },
      pingInterval: const Duration(seconds: 10)
    );
    
    // 設定 stream 為 boradcast
    _stream = _channel.stream.asBroadcastStream();

    // 加入監聽
    _subscription = _stream.listen(
      (data) async {
        try {
          final map = jsonDecode(data);
          final message = MessageModel.fromJson(map);

          if(message.type == MsgType.unreadMessages) {
            await onProcessUnreadMessages(message: message);
          }
          else if (
            message.type == MsgType.text || 
            message.type == MsgType.sticker || 
            message.type == MsgType.image || 
            message.type == MsgType.video
          ) {
            await onGetMessage(message);
          }
        } catch (e) {
          // TODO: 這裏想一下要處理啥
          debugPrint(e.toString());
        }
      },
      onError: (error) {
        if (error is WebSocketException) {} 
        else if (error is SocketException) {} 
        else {
          if(error.toString().contains("401")) {
            return;
          }
        }
        onDisconnect();
        _onReconnect();
      },
      onDone: () {
        onDisconnect();
        _onReconnect();
      },
    );

    // 連線成功，把重新連線的 timer 取消
    await _channel.ready.then((value) async {
      // 取消重新建立連接到
      if(_reconnectTimer != null) {
        _reconnectTimer?.cancel();
      }
      isConnecting.value = false;
      onSend(FrameModel(
        type: MsgType.unreadMessages, 
      ));
      debugPrint('++++++++++++++++++++++++++++++++++++++++++');
      debugPrint('成功連線');
      debugPrint('++++++++++++++++++++++++++++++++++++++++++');
    }); 
  }

  /// 建立 Web Socket 連線
  Future onConnect() async {
    try {
      await _onConnect();
    } catch (e) {
      await _onReconnect();
    }
  }

  /// 重新連線
  Future _onReconnect() async {    
    isConnecting.value = true;

    _reconnectTimer = Timer(
      Duration(seconds: 3), 
      () async {
        await onConnect();
      }
    );
  }

  /// 關閉 Web Socket 連接
  void onDisconnect() {
    _reconnectTimer?.cancel();
    _subscription.cancel();
    for (var sub in _subscriptions) {
      sub.cancel();
    }
    _channel.sink.close();
  }
  
  /// 發送訊息
  Future onSend(
    FrameModel frame
  ) async {
    try {
      final message = jsonEncode(frame.toJson());
      _channel.sink.add(message);
      await Future.delayed(Duration.zero);
    } catch (e) {
      debugPrint("訊息傳送失敗 $e");
      //onReconnect();
    }

  }
}