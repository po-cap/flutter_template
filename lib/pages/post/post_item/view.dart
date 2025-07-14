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
              InkWell(
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
                  ),
                ),
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
