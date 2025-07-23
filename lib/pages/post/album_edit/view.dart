import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/common/index.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import 'index.dart';

class AlbumEditPage extends GetView<AlbumEditController> {
  const AlbumEditPage({super.key});


  Widget _buildPhotoWithDeleteButton(
    AssetEntity asset, 
    double width
  ) {
    return Stack(
      children: [
        _buildPhoto(asset, width),
        Positioned(
          top: 0,
          right: 0,
          child: _buildDeleteButton(asset, width),
        )
      ] 
    );
  }

  Widget _buildDeleteButton(
    AssetEntity asset, 
    double width
  ) {
    return InkWell(
      onTap: () => controller.onRemoveAsset(asset),
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

  Widget _buildPhoto(
    AssetEntity asset,
    double width, {
    double opacity = 1.0
  }) {
    return GestureDetector(
      onTap: () => controller.onOpenGallery(asset),
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
    return LayoutBuilder(
      builder:(context, constraints) {
        final width = (constraints.maxWidth - 10 * 2) / 3;

        return Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for(final asset in controller.selectedAssets)
              Draggable(
                data: asset,

                // 拖曳物件被放置時調用
                onDragCompleted: () {
                  controller.onSetTargetId("");
                },
                
                // 拖曳物件被拖曳時，顯示的視圖
                feedback: _buildPhoto(asset, width),

                //拖曳物件被拖曳時，原本位置的視圖
                childWhenDragging: _buildPhoto(asset, width, opacity: 0.5),

                child: DragTarget(
                  builder:(_, _, _) =>
                    controller.assetTargetId == asset.id ?
                    _buildPhoto(asset, width, opacity: 0.8) : 
                    _buildPhotoWithDeleteButton(asset, width),
                  
                  // 拖拽物件被放置在目標物件時，會先調用這個 Method
                  onWillAcceptWithDetails: (details) {
                    if(details.data == asset) {
                      return false;
                    }
                    controller.onSetTargetId(asset.id);
                    return true;
                  },

                  // 拖拽物件離開目標物件時，會調用這個 Method
                  onLeave: (data) => controller.onSetTargetId(""),
                
                  // 拖拽物件被放置在目標物件，並且接收了物件時，會調用這個 Method
                  onAcceptWithDetails: (details) {                    
                    final fromAsset = details.data as AssetEntity;
                    controller.onSwapAssets(fromAsset, asset);
                  }
                ),
              ),

            if(controller.selectedAssets.length < 9)
              InkWell(
                onTap: () => controller.onSelectAssets(),
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
                )
              )
          ]
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AlbumEditController>(
      init: Get.find<AlbumEditController>(),
      id: "album_edit",
      builder: (_) =>_buildView()
    );
  }
}
