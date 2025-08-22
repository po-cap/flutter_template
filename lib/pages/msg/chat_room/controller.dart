import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:template/common/index.dart';
import 'package:uuid/uuid.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class ChatRoomController extends GetxController {
  ChatRoomController();

  /// 聊天室數據
  late ChatroomModel chatroom = Get.arguments['chatroom'];

  /// 訊息
  late List<MessageModel> messages = [];
  
  /// 商品
  ItemModel? item;

  /// 刷新控制器
  final RefreshController refreshController = RefreshController(
    initialRefresh: false,
  );

  /// 滾動控制器
  final ScrollController scrollController = ScrollController();

  /// 訂閱
  StreamSubscription? _subscription;

  // 訂閱工作
  Worker? _subscribeWorker;

  // UUID
  final _uuid = Uuid();

  _initData() async {

    // 讀取訊息
    await MessageRepo.to.get(
      uri: chatroom.uri
    ).then((msgs) {
      for (var msg in msgs) {
        messages.add(msg);
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController.hasClients) {
          scrollController.jumpTo(
            scrollController.position.maxScrollExtent + 1000,
          );
        }
      });
      update(["chat_room"]);
    });

    // 設置未讀數量
    ChatService.to.totalUnreadCount.value -= ChatService.to.unReadCount[chatroom.uri] ?? 0;
    ChatService.to.unReadCount.value = { ...ChatService.to.unReadCount, chatroom.uri: 0 };
  

    if(ChatService.to.isConnecting.value == false) {
      await _subscribe(ChatService.to.isConnecting.value);
    }

    _subscribeWorker = ever(ChatService.to.isConnecting, (val) async {
      await _subscribe(val); 
    });


    item = await ProductApi.getById(
      id: chatroom.itemId
    );

    update(["chat_room"]);
  }

  void _onReceiveMsg(MessageModel msg) {
    
    try {

      // 如果不是該聊天室的訊息，不處理｀
      if(msg.uri != chatroom.uri) return;


      // 處理一般訊息
      if(msg.type == MsgType.text || 
          msg.type == MsgType.sticker) 
      {
        messages.add(msg);
      }

      // 處理資源訊息
      if(msg.type == MsgType.image || 
          msg.type == MsgType.video) 
      {
        final m = messages.firstWhereOrNull(
          (el) => el.tag == msg.tag
        );
        if(m != null) {
          final idx = messages.indexOf(m);
          messages[idx] = messages[idx].copyWith(
            id: msg.id,
            content: msg.content
          );
        }
        else {
          messages.add(msg);
        }
      }
      
      // TODO: DEBUG
      debugPrint('訊息 ID: ${msg.id}');

      // 更新介面
      _scrollToBottom();
      update(["messageList"]);
    } on Exception catch (e) {
      // TODO: handle exception
      debugPrint(e.toString());
    }
  }
  
  Future _subscribe(bool val) async {
    if(val == false) {
      _subscription = await ChatService.to.onJoin(
        uri: chatroom.uri,
        onReceive: _onReceiveMsg
      );         
    }  
  }

  @override
  void onReady() async {
    super.onReady();
    _initData();
  }

  @override
  void onClose() {
    scrollController.dispose();
    refreshController.dispose();
    _subscribeWorker?.dispose();
    if(_subscription != null) {
      ChatService.to.onExit(
        subscription:_subscription!
      );      
    }
    super.onClose();
  }

  /// 發送文字訊息
  Future onSendText(String text) async {
    await ChatService.to.onSend(
      FrameModel(
        type: MsgType.text,
        content: text,
        tag: _uuid.v4()
      )
    );
  }

  Future onImageSend() async {
    final assets = await AssetPicker.pickAssets(
      Get.context!, 
      pickerConfig: AssetPickerConfig(
        maxAssets: 1,
        requestType: RequestType.image
    ));

    if(assets == null) return;

    final file = await assets.first.file;
    final path = file?.path;
    if(path == null) return;


    final msg = MessageModel(
      id: 0, 
      uri: chatroom.uri,
      receiverId: chatroom.partnerId, 
      content: path, 
      type: MsgType.image,
      tag: assets.first.id,
      asset: assets.first
    );
    messages.add(msg);
    update(["messageList"]);

    _scrollToBottom();

    final uri = await PostApi.uploadImage(assets.first);

    await ChatService.to.onSend(
      FrameModel(
        type: MsgType.image,
        tag: assets.first.id,
        content: uri
      )
    );
  }

  Future onVideoSend() async {
    final assets = await AssetPicker.pickAssets(
      Get.context!, 
      pickerConfig: AssetPickerConfig(
        maxAssets: 1,
        requestType: RequestType.video,
        filterOptions: FilterOptionGroup(
          videoOption: FilterOption(
            durationConstraint: DurationConstraint(
              max: const Duration(seconds: 30),
            ),
          ),
        ),
      ),
    );

    if(assets == null) return;

    final msg = MessageModel(
      id: 0, 
      uri: chatroom.uri,
      receiverId: chatroom.partnerId, 
      content: "", 
      type: MsgType.video,
      tag: assets.first.id,
      asset: assets.first
    );
    messages.add(msg);
    update(["messageList"]);
    
    _scrollToBottom();

    final video = await PostApi.uploadVideo(assets.first);

    await ChatService.to.onSend(
      FrameModel(
      type: MsgType.video,
      tag: assets.first.id,
      asset: assets.first,
      content: jsonEncode(video.toJson())
    ));
  }

  // 发送表情消息
  Future onFaceSend(int index, String data) async {
    final text = data.trim();  
    await ChatService.to.onSend(
      FrameModel(
        type: MsgType.sticker,
        content: '${Constants.customFacePath}$index/$text',
        tag: _uuid.v4()
      )
    );
  }

  // 滚动到底部
  void _scrollToBottom() {
    // 多次嘗試確保成功
    for (int i = 0; i < 3; i++) {
      Future.delayed(Duration(milliseconds: i * 50), () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (scrollController.hasClients &&
              scrollController.position.maxScrollExtent > 0) {
            scrollController.animateTo(
              scrollController.position.maxScrollExtent,
              duration: Duration(milliseconds: 200),
              curve: Curves.easeOut,
            );
          }
        });
      });
    }
  }
  
}
