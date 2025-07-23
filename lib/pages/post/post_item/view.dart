import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/common/index.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:ducafe_ui_core/ducafe_ui_core.dart';

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
      BarItemWidget(
        title: "價格", 
        value: "NT\$0.0",
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
        decoration: const InputDecoration(
          hintText: "描述一下商品",
          border: InputBorder.none,
        ),
      ),
    );
  }

  // 圖片列表
  Widget _buildPhotoList() {

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = (constraints.maxWidth - 10 * 2) / 3;

        return Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for(final asset in controller.selectedAssets)
              Draggable(
                data: asset,

                // 當 draggable 被放置並被 [DragTarget] 接收時調用
                onDragCompleted: () {
                  controller.onSetTargetId("");
                },

                feedback: _buildPhotoItem(asset, width),
                childWhenDragging: _buildPhotoItem(asset, width, opacity: 0.5),
                child: DragTarget(
                  builder: (context, candidateData, rejectedData) {
                    return controller.assetTargetId == asset.id ?
                    _buildPhotoItem(asset, width, opacity: 0.8) : 
                     _buildPhotoItemWithDelete(asset, width);
                  },
                  onWillAcceptWithDetails: (details) {
                    if(details.data == asset) {
                      return false;
                    } else {
                      controller.onSetTargetId(asset.id);
                      return true;
                    }
                  },
                  onLeave: (data) {
                    controller.onSetTargetId("");
                  },

                  onAcceptWithDetails: (details) {
                    final fromAsset = details.data as AssetEntity;
                    controller.onSwapAssets(fromAsset, asset);
                  },


                )
              ),
            
            if(controller.selectedAssets.length < 9)
              InkWell(
                onTap: controller.onSelectAssets,
                borderRadius: BorderRadius.circular(AppRadius.image),
                child: Ink(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppRadius.image),
                      color: context.theme.colorScheme.surfaceContainerHigh,
                  ),
                  width: width,
                  height: width,
                  child: Icon(
                    Icons.add,
                    color: context.theme.colorScheme.onSurface,
                  )
                ),
              ) 
          ],
        );
      }
    );

  }

  Widget _buildPhotoItemWithDelete(
    AssetEntity asset, 
    double width
  ) {
    return Stack(
      children: [
        _buildPhotoItem(asset, width),
        Positioned(
          top: 0,
          right: 0,
          child: _buildDeleteButton(asset, width),
        )
      ] 
    );
  }

  Widget _buildDeleteButton(AssetEntity asset, double width) {
    return InkWell(
      onTap:() => controller.onRemoveAsset(asset),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(AppRadius.image),
            bottomLeft: Radius.circular(AppRadius.image)
          ),
          color: Colors.white
        ),
        child: Icon(
          Icons.close,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildPhotoItem(AssetEntity asset, double width,{ double opacity = 1.0 }) {
    return GestureDetector(
      onTap: () {
        Get.to(GalleryWidget.assets(
          initialIndex: controller.selectedAssets.indexOf(asset), 
          assets: controller.selectedAssets
        ));
      },
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.image),
        ),
        child: AssetEntityImage(
          asset,
          isOriginal: false,
          width: width,
          height: width,
          fit: BoxFit.cover,
          opacity: AlwaysStoppedAnimation(opacity),
        ),
      ),
    );
  }

  // 主视图
  Widget _buildView() {
    return <Widget>[
      // 商品描述文字輸入框
      _buildPhotoList()
      .paddingBottom(AppSpace.listItem),

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
      init: PostItemController(),
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
