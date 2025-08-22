import 'dart:convert';

import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:template/common/index.dart';
import 'package:template/pages/index.dart';
import 'package:template/pages/msg/chat_room/widgets/item.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';



class ChatRoomPage extends StatefulWidget {
  const ChatRoomPage({super.key});

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage>
    with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const _ChatRoomViewGetX();
  }
}

class _ChatRoomViewGetX extends GetView<ChatRoomController> {
  const _ChatRoomViewGetX();

  /// 消息列表
  Widget _buildMsgList() {
    return GetBuilder<ChatRoomController>(
      id: "messageList",
      tag: tag,
      builder: (_) {

        return SmartRefresher(
          controller: controller.refreshController,
          scrollController: controller.scrollController,
          enablePullUp: false,
          enablePullDown: false,
          //physics: const NeverScrollableScrollPhysics(),
          //reverse: true,
          onLoading: () {}, // 上拉加载回调
          footer: ClassicFooter(
            loadingIcon: SizedBox(
              width: 25,
              height: 25,
              child: CupertinoActivityIndicator(),
            ),
          ),
          child: CustomScrollView(
            slivers: [

            if(controller.item != null)
              SliverPersistentHeader(
                pinned: true,
                delegate: ItemWidget(controller.item!),
              ),

              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return _buildMsgItem(
                      msg: controller.messages[index]
                    );
                  },
                  childCount: controller.messages.length,
                ),
              ).sliverPadding(
                all: AppSpace.page,
              ),
            ],
          )
        );
      },
    );
  }

  /// 消息
  Widget _buildMsgItem({
    required MessageModel msg
  }) {
    
    final isSender = UserService.to.profile.id == msg.receiverId;

    final ws = <Widget>[
      ImageWidget.img(
        !isSender ? UserService.to.profile.avatar! : controller.chatroom.avatar,
        width: 42, 
        height: 42,
        fit: BoxFit.fill,
        radius: 21,
      ),

      if(msg.type == MsgType.sticker)
        MsgFaceElemWidget(
          url: msg.content,
        ).paddingHorizontal(AppSpace.listRow),

      if(msg.type == MsgType.text)
        BubbleWidget(
          text: msg.content,
          isSender: !isSender, 
          color: Get.theme.colorScheme.surfaceContainerHighest,
        ),

      if(msg.type == MsgType.image)
        <Widget>[
          if(msg.id != 0)
          ImageWidget.img(
            msg.content,
            height: 220,
            radius: 5,
            fit: BoxFit.cover,
          ).constrained(
            minWidth: 150
          )
          .onTap(() {
            Get.to(
              GalleryWidget.network(
                initialIndex: 0, 
                items: [msg.content]
              )
            );
          }),

          if(msg.id == 0)
          AssetEntityImage(
            msg.asset!,
            isOriginal: false,
            height: 220,
            fit: BoxFit.cover,
          ),

          if(msg.id == 0)
          CircularProgressIndicator()
        ].toStack(
          alignment: Alignment.center,
        ).paddingHorizontal(AppSpace.listRow),

      if(msg.type == MsgType.video)
        MsgVideoElemWidget(
          video: msg.id == 0 ? null : VideoModel.fromJson(jsonDecode(msg.content)),
          asset: msg.id == 0 ? msg.asset : null,
        ).paddingHorizontal(AppSpace.listRow),

    ];

    return ws.toRow(
      key: key,
      textDirection: !isSender ? TextDirection.rtl : TextDirection.ltr
    ).paddingBottom(AppSpace.listRow * 2);
  }

  // 主视图
  Widget _buildView() {
    return _buildMsgList();

  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatRoomController>(
      init: ChatRoomController(),
      id: "chat_room",
      builder: (_) {
        return Scaffold(
          //resizeToAvoidBottomInset: false, 
          appBar: AppBar(
            title: Obx(
              () => Text(
                ChatService.to.isConnecting.value ? 
                "連線中..." :
                controller.chatroom.title
              ),
            ),
          ),
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SafeArea(
              child: _buildView(),
            ),
          ),

          bottomNavigationBar: ChatBarWidget(
            onTextSend: controller.onSendText,
            onFaceSend: controller.onFaceSend,
            onImageSend: controller.onImageSend,
            onVideoSend: controller.onVideoSend,
          ),
        );
      },
    );
  }
}
