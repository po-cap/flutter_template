import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/common/index.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:ducafe_ui_core/ducafe_ui_core.dart';

import 'index.dart';

class PostItemPage extends GetView<PostItemController> {
  const PostItemPage({super.key});

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
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadius.image),
                    color: context.theme.colorScheme.surfaceContainerHigh,
                  ),
                  width: width,
                  height: width,
                  child: Icon(
                    Icons.add,
                    color: context.theme.colorScheme.onSurface,
                  ),
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

  InkWell _buildPhotoItem(AssetEntity asset, double width,{ double opacity = 1.0 }) {
    return InkWell(
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
      // 圖片列表
      _buildPhotoList(),
    ]
    .toColumn()
    .padding(all:AppSpace.page * 2);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PostItemController>(
      init: PostItemController(),
      id: "post_item",
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text("post_item")),
          body: SafeArea(
            child: _buildView(),
          ),
        );
      },
    );
  }
}
