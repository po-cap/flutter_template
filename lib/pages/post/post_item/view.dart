import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/common/index.dart';
import 'package:template/pages/post/album_edit/view.dart';
import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:template/pages/price_edit/index.dart';

import 'index.dart';

class PostItemPage extends GetView<PostItemController> {
  const PostItemPage({super.key});

  Widget _buildListItem() {
    return <Widget>[
      GestureDetector(
        onTap: () {
          controller.onEditSalesAttributes();
        },
        child: BarItemWidget(
          title: "商品規格", 
          value: "非必填，設置多個顏色、尺寸等",
        ),
      ),
      GestureDetector(
        onTap: () {
          showModalBottomSheet(
            context: Get.context!, 
            isScrollControlled: true,
            builder:(context) {
              return PriceEditPage();
            },
          );
        },
        child: BarItemWidget(
          title: "價格", 
          value: "NT\$0.0",
        ),
      ),
      BarItemWidget(
        title: "發貨方式", 
        value: "包郵",
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
    return <Widget>[
      // 商品圖片
      AlbumEditPage(),

      // 圖片列表
      _buildContentInput(),

      // 參數規格
      _buildListItem(),
    ]
    .toColumn(
      crossAxisAlignment: CrossAxisAlignment.start
    )
    .padding(all:AppSpace.page * 2);
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
