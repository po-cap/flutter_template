import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:template/common/index.dart';

import 'index.dart';

class MsgIndexPage extends GetView<MsgIndexController> {
  const MsgIndexPage({super.key});

  Widget _buildListItem({
    required ChatroomModel chatroom
  }) {
    return Slidable(
      // 唯一值
      key: Key(chatroom.uri),

      // The start action pane is the one at the left or the top side.
      endActionPane: ActionPane(
        // A motion is a widget used to control how the pane animates.
        motion: const ScrollMotion(),

        // A pane can dismiss the Slidable.
        //dismissible: DismissiblePane(onDismissed: () {}),

        // All actions are defined in the children parameter.
        children: [
          // A SlidableAction can have an icon and/or a label.
          SlidableAction(
            onPressed: (_) async {
              await controller.onDeleteChatroom(room: chatroom);
            },
            backgroundColor: Get.theme.colorScheme.errorContainer,
            foregroundColor: Get.theme.colorScheme.onErrorContainer,
            icon: Icons.delete,
            label: '刪除',
          ),
        ],
      ),

      child: ListTile(
        leading: Obx(
          () {
            if(ChatService.to.unReadCount[chatroom.uri] == null || 
               ChatService.to.unReadCount[chatroom.uri] == 0) {
              return ImageWidget.img(
                chatroom.avatar,
                width: 60, 
                height: 60,
                fit: BoxFit.fill,
                radius: 30,
              );
            }
            else {
              return Badge(
                backgroundColor: Get.theme.primaryColor,
                label: Text(
                  ChatService.to.unReadCount[chatroom.uri].toString()
                ),
                alignment: Alignment.topRight,
                child: ImageWidget.img(
                  chatroom.avatar,
                  width: 60, 
                  height: 60,
                  fit: BoxFit.fill,
                  radius: 30,
                ),
              );
            }
          }
        ),
        title: TextWidget.h4(chatroom.title),
        subtitle: TextWidget.body(
          chatroom.lastMessage ?? "",
          overflow: TextOverflow.ellipsis
        ),
        trailing: ImageWidget.img(
          chatroom.photo!,
          width: 60, 
          height: 60,
          fit: BoxFit.fill,
          radius: 5,
        ),
        onTap: () => controller.onGoToChatroom(room: chatroom),
      ),
    );
  }

  Widget _buildList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return _buildListItem(
            chatroom: controller.chatrooms[index],
          );
        },
        childCount: controller.chatrooms.length
      )
    );
  }

  // 主视图
  Widget _buildView() {
    return CustomScrollView(
      slivers: [
        _buildList(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MsgIndexController>(
      init: Get.find<MsgIndexController>(),
      id: "msg_index",
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: Obx(
              () => Text(
                ChatService.to.isConnecting.value ? 
                "連線中..." : "訊息"
              ),
            ),
          ),
          body: SmartRefresher(
            controller: controller.refreshController, // 刷新控制器
            enablePullUp: false, // 启用上拉加载
            onRefresh: controller.onRefresh, // 下拉刷新回调
            footer: const SmartRefresherFooterWidget(), // 底部加载更
            child: _buildView()
          ),
        );
      },
    );
  }
}
