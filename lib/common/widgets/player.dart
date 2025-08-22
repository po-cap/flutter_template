import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/route_manager.dart';
import 'package:template/common/index.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_player/video_player.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

/// 視頻播放器
/// 1 壓縮視頻，顯示壓縮進度
/// 2 播放壓縮後的視頻文件
class VideoPlayerWidget extends StatefulWidget {
  const VideoPlayerWidget({
    super.key, 
    this.controller, 
    this.initAsset, 
    this.onCompleted
  });

  /// chewie 视频播放控制器
  final ChewieController? controller;

  /// 视频 asset
  final AssetEntity? initAsset;

  /// 完成压缩回调
  final Function(XFile)? onCompleted;

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  /// video 视频控制器
  VideoPlayerController? _videoController;

  /// chewie 控制器
  ChewieController? _controller;

  /// 压缩消息订阅
  Subscription? _subscription;

  /// 资源 asset
  AssetEntity? _asset;

  /// 是否载入中
  bool _isLoading = true;

  /// 是否错误
  bool _isError = false;

  /// 压缩进度
  double _progress = 0;


  @override
  void initState() {
    super.initState();
    _asset = widget.initAsset;
    
    // 压缩进度订阅
    _subscription = VideoCompress.compressProgress$.subscribe((progress) {
      debugPrint('progress: $progress');
      setState(() {
        _progress = progress;
      });
    });
    if (mounted) onLoad();
  }

  void onLoad() async {
    // 1. 初始界面状态
    setState(() {
      _isLoading = _asset != null;
      _isError = _asset == null;
    });

    // 2. 安全检查, 容错
    if (_asset == null) return;

    // 3. 清理资源，释放播放器对象
    _videoController?.dispose();

    //
    try {

      // 开始视频压缩
      var xfile = await UCompress.video(_asset!);
      var file = await xFileToFile(xfile.video);

      // video_player 初始化
      _videoController = VideoPlayerController.file(file!);
      await _videoController!.initialize();

      // chewie 初始化
      _controller = widget.controller ??
          ChewieController(
            videoPlayerController: _videoController!,
            autoPlay: false,
            looping: false,
            autoInitialize: true,
            showOptions: false,
            cupertinoProgressColors: ChewieProgressColors(
              playedColor: Get.theme.colorScheme.secondary,
            ),
            materialProgressColors: ChewieProgressColors(
              playedColor: Get.theme.colorScheme.secondary,
            ),
            allowPlaybackSpeedChanging: false,
            deviceOrientationsOnEnterFullScreen: [
              DeviceOrientation.landscapeLeft,
              DeviceOrientation.landscapeRight,
              DeviceOrientation.portraitUp,
            ],
            deviceOrientationsAfterFullScreen: [
              DeviceOrientation.portraitUp,
            ],
          );
      if (widget.onCompleted != null) widget.onCompleted!(xfile.video);
    } catch (error) {
      Loading.toast('Video file error');
      setState(() {
        _isError = true;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<File?> xFileToFile(XFile xfile) async {
    try {
      // 檢查 XFile 是否有路徑
      File file = File(xfile.path);
      
      // 驗證文件是否存在
      if (await file.exists()) {
        return file;
      }
          
      // 如果沒有路徑或文件不存在，使用其他方法
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    if (widget.controller == null) _controller?.dispose();
    VideoCompress.cancelCompression();
    _subscription?.unsubscribe();
    _subscription = null;
    VideoCompress.deleteAllCache();
    super.dispose();
  }

  Widget _mainView() {
    // 默认空组件
    Widget ws = const SizedBox.shrink();

    // 正在载入
    if (_isLoading) {
      ws = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 进度状态 icon
          Container(
            height: 40,
            width: 40,
            alignment: Alignment.center,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Get.theme.colorScheme.secondary,
            ),
          ),
          const SizedBox(height: 10),
          // 进度状态文本
          Text(
            '${_progress.toStringAsFixed(2)}%',
            style: TextStyle(
              fontSize: 13,
              color: Get.theme.colorScheme.secondary,
            ),
          ),
        ],
      );
    }

    // 正确显示
    else {
      if (_controller != null && !_isError) {
        ws = Container(
          decoration: const BoxDecoration(color: Colors.black),
          child: Chewie(controller: _controller!),
        );
      } else {}
    }

    // 按比例组件包裹
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        color: Colors.grey[100],
        child: ws,
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return _mainView();
  }
}