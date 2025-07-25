import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/common/index.dart';

import 'index.dart';

class AlbumPage extends GetView<AlbumController> {
  const AlbumPage({super.key});


  Widget _buildPhotoWithDeleteButton(
    String url,
    double width
  ) {
    return Stack(
      children: [
        _buildPhoto(url, width),
        Positioned(
          top: 0,
          right: 0,
          child: InkWell(
            onTap: () {},
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
          ),
        )
      ],
    );
  }

  Widget _buildPhoto(
    String url,
    double width, {
    double opacity = 1.0
  }) {
    return ImageWidget.img(
      url, 
      radius: AppRadius.image,
      fit: BoxFit.cover, 
      width: width, 
      height: width,
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
            for(final url in controller.album)
              Draggable(
                data: url,

                // 拖曳物件被放置時調用
                onDragCompleted: () {
                  controller.onSetTarget("");
                },
                
                // 拖曳物件被拖曳時，顯示的視圖
                feedback: _buildPhoto(url, width),

                //拖曳物件被拖曳時，原本位置的視圖
                childWhenDragging: _buildPhoto(url, width, opacity: 0.5),

                child: DragTarget(
                  builder:(_, _, _) =>
                    controller.targetUrl == url ?
                    _buildPhoto(url, width, opacity: 0.8) : 
                    _buildPhotoWithDeleteButton(url, width),
                  
                  // 拖拽物件被放置在目標物件時，會先調用這個 Method
                  onWillAcceptWithDetails: (details) {
                    if(details.data == url) {
                      return false;
                    }
                    controller.onSetTarget(url);
                    return true;
                  },

                  // 拖拽物件離開目標物件時，會調用這個 Method
                  onLeave: (data) => controller.onSetTarget(""),
                
                  // 拖拽物件被放置在目標物件，並且接收了物件時，會調用這個 Method
                  onAcceptWithDetails: (details) {                    
                    final fromPhoto = details.data as String;
                    controller.onSwapAssets(fromPhoto, url);
                  }
                ),
              ),

            if(controller.album.length < 9)
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
    return GetBuilder<AlbumController>(
      init: AlbumController(),
      id: "album",
      builder: (_) => _buildView(),
    );
  }
}
