import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

/// 图片浏览组件
class GalleryWidget extends StatelessWidget {
  /// 初始图片位置
  final int initialIndex;

  /// 图片列表
  final List<String>? items;

  /// 资源列表
  final List<AssetEntity>? assets;

  /// 是否从本地资源加载
  final bool _fromAssets;

  const GalleryWidget.network({
    super.key,
    required this.initialIndex,
    required this.items,
  }) : assets = null, _fromAssets = false;

  const GalleryWidget.assets({
    super.key, 
    required this.initialIndex, 
    required this.assets 
  }) : items = null, _fromAssets = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // 不许穿透
      behavior: HitTestBehavior.opaque,
      // 点击返回
      onTap: () => Navigator.pop(context),
      child: Scaffold(
        // 全屏, 高度将扩展为包括应用栏的高度
        extendBodyBehindAppBar: true,

        // 背景黑色
        backgroundColor: Colors.black,

        // 导航栏 保留一个返回按钮
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          iconTheme: (
            IconThemeData(
              color: Colors.white,
          )),
        ),

        // 图片内容
        body: _buildGallery(_fromAssets),
      ),
    );
  }

  PhotoViewGallery _buildGallery(bool fromAssets) {
    return PhotoViewGallery.builder(
        // 允许滚动超出边界，但之后内容会反弹回来。
        scrollPhysics: const BouncingScrollPhysics(),
        // 图片列表
        builder: (BuildContext context, int index) {
          return PhotoViewGalleryPageOptions(
          
            // 图片内容
            imageProvider: fromAssets ? 
              AssetEntityImageProvider(assets![index]) : 
              NetworkImage(items![index]),
            // 初始尺寸 容器尺寸
            initialScale: PhotoViewComputedScale.contained,
            // 最小尺寸 容器尺寸
            minScale: PhotoViewComputedScale.contained,
            // 最大尺寸 容器尺寸 4 倍
            maxScale: PhotoViewComputedScale.covered * 4,
          );
        },

        // loading 载入标记
        loadingBuilder: (context, event) => CircularProgressIndicator(
          // 标记颜色
          backgroundColor: context.colors.scheme.tertiary,
          // 进度
          value: event == null
              ? 0
              : event.cumulativeBytesLoaded / (event.expectedTotalBytes ?? 0),
        ).tightSize(30).center(),

        // 图片个数
        itemCount: fromAssets ? assets!.length : items!.length,

        // 初始控制器，默认图片位置
        pageController: PageController(initialPage: initialIndex),
      );
  }
}
