import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:template/common/index.dart';


class MsgIndexController extends GetxController {
  MsgIndexController();

  /// 聊天室
  List<ChatroomModel> chatrooms = []; 

  /// 刷新控制器
  final RefreshController refreshController = RefreshController(
    initialRefresh: false,
  );

  /// 訂閱
  StreamSubscription? _subscription;

  /// 監聽連線並訂閱的 worker
  Worker? _subscribeWorker;

  // 页码
  int _page = 1;

  // 页尺寸
  final int _limit = 50;

  _initData() async {

    chatrooms = await ChatroomRepo.to.get(
      size: _limit,
      page: _page
    );

    update(["msg_index"]);

    // 1. 第一次直接讀取
    if(ChatService.to.isConnecting.value == false) {
      _subscribe(ChatService.to.isConnecting.value);
    }

    // 2. 監聽後續變化
    _subscribeWorker = ever(ChatService.to.isConnecting, _subscribe);
  }

  void _subscribe(bool val) {
    debugPrint("==================================================");
    debugPrint("連線狀況: ${val ? "連線中" : "已連線"}");
    debugPrint("==================================================");
    if(val == false) {
      _subscription = ChatService.to.onSubscribe(
        onData: (message) {
          switch(message.type) {
              case MsgType.text:
              case MsgType.sticker:
              case MsgType.image:
              case MsgType.video:
                onReceiveMessage(message: message);
                break;
              default:
                break;
          }
      });          
    }  
  }

  void onGoToChatroom({
    required ChatroomModel room
  }) {
    Get.toNamed(
      RouteNames.msgChatRoom, 
      arguments: {
        'chatroom': room
      }
    );
  }

  Future onReceiveMessage({
    required MessageModel message
  }) async {

    // 找到對應的聊天室
    var room = chatrooms.firstWhereOrNull(
      (el) => el.uri == message.uri
    );

    // 更新聊天室
    if(room != null) {
      room = room.copyWith(
        lastMessageType: message.type,
        lastMessage: message.content
      );
    }
    else {
      room = await ChatApi.getChatroom(message.uri);
      room = room.copyWith(
        lastMessageType: message.type,
        lastMessage: message.content
      );
    }

    // 把聊天室堆到頂部
    chatrooms.removeWhere((el) => el.uri == message.uri);
    chatrooms.insert(0, room);  

    update(["msg_index"]);
  }

  Future onDeleteChatroom({
    required ChatroomModel room
  }) async {
      await DialogWidget.show(
        context: Get.context!,
        content: Text("確認刪除？"),
        confirm: ButtonWidget(
          text: "確定",
          onTap: () async {
            await ChatroomRepo.to.delete(room);
            await MessageRepo.to.deleteByUri(room.uri);
            Get.back();
            chatrooms.remove(room);
            update(["msg_index"]);
          },
        ),
        cancel: ButtonWidget(
          text: "取消",
          onTap: () => Get.back(),
        ),
        //onConfirm: () async {
        //  chatrooms.remove(room);
        //  await ChatroomRepo.to.delete(room);
        //  update(["msg_index"]);
        //},
      );
  }

  // 下拉刷新
  void onRefresh() async {
    try {
      _page += 1;
      chatrooms = await ChatroomRepo.to.get(
        size: _limit,
        page: _page
      );
      refreshController.refreshCompleted();
    } catch (error) {
      // 刷新失败
      refreshController.refreshFailed();
    }
    update(["chat_find_user"]);
  }

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  @override
  void onClose() {
    _subscribeWorker?.dispose();
    refreshController.dispose();
    if(_subscription != null) {
      ChatService.to.onExit(
        subscription:_subscription!
      );      
    }
    super.onClose();
  }

}
