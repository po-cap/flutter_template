import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:template/common/index.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';



/// 视频消息
class MsgVideoElemWidget extends StatefulWidget {
  const MsgVideoElemWidget({
    super.key, 
    this.video,
    this.asset
  });

  final VideoModel? video;

  final AssetEntity? asset;


  @override
  State<MsgVideoElemWidget> createState() => _MsgVideoElemWidgetState();
}

class _MsgVideoElemWidgetState extends State<MsgVideoElemWidget> {


  @override
  void initState() {
    super.initState();
  }

  // 视频预览图
  Widget _buildRreview() {
    // 预览图
    Widget img = const ImageWidget.img(
      AssetsImages.logoPng,
      height: 200,
    );
    if(widget.video == null) {
      img = AssetEntityImage(
        widget.asset!,
        isOriginal: false,
        width: 150,
        height: 200,
      );
    }
    else {
      img = ImageWidget.img(
        widget.video!.thumbnail.url,
        height: 200,
      );
    }

    return img;
  }

  // 主视图
  Widget _buildView(BuildContext context) {
    var ws = <Widget>[
      // 预览图
      _buildRreview(),

      // 播放按钮
      if(widget.video != null)
      const Icon(
        Icons.play_circle_fill,
        color: Colors.white,
        size: 40,
      ),

      // 播放按钮
      if(widget.video == null)
      CircularProgressIndicator()
    ]
    .toStack(
      alignment: Alignment.center,
    )
    .onTap(() {
      if(widget.video != null) {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return VideoWidget(
            videoUrl: widget.video!.video.url,
          );
        }));
      }
    });

    return ws;
  }

  @override
  Widget build(BuildContext context) {
    return _buildView(context);
  }
}
