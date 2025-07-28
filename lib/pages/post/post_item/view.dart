import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/common/index.dart';
import 'package:template/pages/index.dart';
import 'package:ducafe_ui_core/ducafe_ui_core.dart';


class PostItemPage extends GetView<PostItemController> {
  const PostItemPage({super.key});

  Widget _buildListItem() {
    return <Widget>[
      GestureDetector(
        onTap: () {
          controller.onEditOptions();
        },
        child: BarItemWidget(
          title: "商品規格", 
          value: controller.skuName,
        ),
      ),
      GestureDetector(
        onTap: controller.onEditPrice,
        child: BarItemWidget(
          title: "價格", 
          value: controller.price,
        ),
      ),
    ].toColumn()
    .paddingTop(AppSpace.listItem);
  }

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
        // 商品圖片
        //AlbumEditPage(),
      
        AlbumPage(),
      
        // 圖片列表
        _buildContentInput(),
      
        // 參數規格
        _buildListItem(),
      ]
      .toColumn(
        crossAxisAlignment: CrossAxisAlignment.start
      )
      .padding(all:AppSpace.page * 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PostItemController>(
      id: "post_item",
      builder: (_) {
        return Scaffold(
          appBar: AppBarWidget(),
          body: SafeArea(
            child: _buildView(),
          ),
        );
      },
    );
  }
}
