import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/common/index.dart';

import 'index.dart';
import 'widgets/index.dart';

class PostShortPage extends GetView<PostShortController> {
  const PostShortPage({super.key});

  Widget _buildContentInput() {
    return LimitedBox(
      maxHeight: 200,
      child: TextField(
        controller: controller.contentController,
        maxLines: null,
        minLines: 5,
        textInputAction: TextInputAction.done,
        decoration: const InputDecoration(
          hintText: "描述一下商品",
          border: InputBorder.none,
        ),
      ),
    );
  }
  // 主视图
  Widget _buildView() {
    return SingleChildScrollView(
      child: [
        // 文章資源      
        AlbumWidget(
          onAssetsChanged: controller.onAssetsChanged,
        ),
      
        // 輸入內容
        _buildContentInput(),
      
      ]
      .toColumn(
        crossAxisAlignment: CrossAxisAlignment.start
      )
      .padding(all:AppSpace.page * 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PostShortController>(
      init: PostShortController(),
      id: "post_short",
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text("post_short")),
          body: SafeArea(
            child: _buildView(),
          ),
        );
      },
    );
  }
}
