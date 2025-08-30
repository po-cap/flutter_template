import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/common/index.dart';

import 'index.dart';
import 'widgets/index.dart';

class PostShortPage extends GetView<PostShortController> {
  const PostShortPage({super.key});

  Widget _buildListItem() {
    return <Widget>[
      GestureDetector(
        onTap: controller.onEditSalesAttributes,
        child: ActionWidget(
          title: "商品規格", 
          value: controller.skus.isEmpty ? 
            "非必填，設置多個顏色、尺碼等" : 
            controller.skus.length == 1 ? "非必填，設置多個顏色、尺碼等" : "已經有${controller.skus.length}個規格",
        ),
      ),
      GestureDetector(
        onTap: controller.onEditPrice,
        child: ActionWidget(
          title: "價格", 
          value: controller.skus.isEmpty ? "\$0.0" : controller.skus.displayPrice(),
        ),
      ),
      GestureDetector(
        onTap: controller.onEditShippingFee,
        child: ActionWidget(
          title: "運費", 
          value: "\$${controller.shippingFee}",
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
        focusNode: controller.focusNode,
        maxLines: null,
        minLines: 5,
        //textInputAction: TextInputAction.done,
        decoration: const InputDecoration(
          hintText: "描述一下商品",
          border: InputBorder.none,
        ),
      ),
    );
  }
  
  Widget _buildBottomAction() {
    return <Widget>[
      ButtonWidget.tertiary(
        "完成",
        onTap: controller.onUnFocus,
      ).paddingHorizontal(
        AppSpace.page
      ),
    ].toRow(
      mainAxisAlignment: MainAxisAlignment.end
    ).paddingBottom(AppSpace.page);
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
    return GetBuilder<PostShortController>(
      init: PostShortController(),
      id: "post_short",
      builder: (_) {
        return Scaffold(
          appBar: AppBarWidget(
            onConfirm: controller.onConfirm,
          ),
          body: SafeArea(
            child: _buildView(),
          ),
          bottomSheet: controller.focusNode.hasFocus ? 
            _buildBottomAction()
            .backgroundColor(Get.theme.colorScheme.surface) : null,
        );
      },
    );
  }
}
