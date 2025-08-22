import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:template/common/index.dart';
import 'package:video_player/video_player.dart';

class VideoWidget extends StatefulWidget {
  const VideoWidget({
    super.key,
    this.imgLocaPath,
    this.imgUrl,
    this.isBarVisible,
    this.videoLocalPath,
    this.videoUrl,
  });

  /// 图片 本地文件
  final String? imgLocaPath;

  /// 图片 url
  final String? imgUrl;

  /// 视频 本地文件
  final String? videoLocalPath;

  /// 视频 url
  final String? videoUrl;

  /// 是否显示 bar
  final bool? isBarVisible;

  @override
  State<VideoWidget> createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget>
    with SingleTickerProviderStateMixin, RouteAware, WidgetsBindingObserver {
  /// 是否显示 bar
  bool _isShowAppBar = true;

  /// video 视频控制器
  VideoPlayerController? _videoController;

  /// chewie 控制器
  ChewieController? _chewieController;

  /// 监控路由状态
  final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

  /// 文字样式
  TextStyle textStyleDetail = const TextStyle(
    color: Colors.white,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  /// 加载视频
  Future<void> _onLoadVideo() async {
    if ((widget.videoUrl?.isEmpty ?? true) == true) {
      return Future.value();
    }

    try {
      // 01 本地视频
      if (widget.videoLocalPath != null) {
        _videoController =
            VideoPlayerController.file(File(widget.videoLocalPath!));
      }
      // 02 远程视频
      else if (widget.videoUrl != null) {
        _videoController =
            VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl!));
      }

      // video_player 初始化
      await _videoController?.initialize();

      // chewie 初始化
      _chewieController = ChewieController(
        videoPlayerController: _videoController!,
        fullScreenByDefault: true,
        autoPlay: true,
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
        // placeholder: Image.network(
        //   DuTools.imageUrlFormat(
        //     widget.timeline?.video?.cover ?? "",
        //     width: 400,
        //   ),
        //   fit: BoxFit.cover,
        // ),
      );
    } catch (e) {
      // DuToast.show('Video url load error.');
    } finally {
      if (mounted) setState(() {});
    }
  }

  /// app 生命周期状态
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (_videoController?.value.isInitialized != true) return;
    if (state != AppLifecycleState.resumed) {
      _chewieController?.pause(); // 如果应用生命周期状态不是 resumed，暂停 Chewie 播放器。
    }
  }

  /// 路由状态变化
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(
        this, ModalRoute.of(context) as PageRoute); // 订阅路由观察者，以便在路由变化时接收通知。
  }

  /// 进入其他页面时调用该方法。
  @override
  void didPushNext() {
    super.didPushNext();
    if (_videoController?.value.isInitialized != true) return;
    _chewieController?.pause(); // 如果视频控制器已初始化，暂停 Chewie 播放器。
  }

  /// 从其他页面返回时调用该方法。
  @override
  void didPopNext() {
    super.didPopNext();
    if (_videoController?.value.isInitialized != true) return;
    _chewieController?.play(); // 如果视频控制器已初始化，播放 Chewie 播放器。
  }

  /// 初始
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _onLoadVideo());

    _isShowAppBar = widget.isBarVisible ?? true;
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _chewieController?.pause();
    _chewieController?.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  // 视频视图
  Widget _buildVideoView() {
    // 按比例组件包裹
    return _chewieController == null
        ? Text(
            "视频载入中 loading...",
            style: textStyleDetail,
            textAlign: TextAlign.center,
          ).center()
        : Chewie(controller: _chewieController!);
  }

  // 图片视图
  Widget _buildImageView() {
    // 支持手势的图片查看组件
    return ExtendedImageGesturePageView.builder(
      // 控制器，初始化显示第1个
      controller: ExtendedPageController(
        initialPage: 0,
      ),
      // 图片数量
      itemCount: 1,
      // 图片构建
      itemBuilder: (BuildContext context, int index) {
        // 默认图片
        ImageProvider imageProvider = const AssetImage(AssetsImages.logoPng);
        // 远程图片
        if (widget.imgUrl != null) {
          imageProvider = ExtendedNetworkImageProvider(widget.imgUrl!);
        } else if (widget.imgLocaPath != null) {
          // 本地图片
          imageProvider = ExtendedFileImageProvider(File(widget.imgLocaPath!));
        }

        // 每一页图片对象
        return ExtendedImage(
          // 图片
          image: imageProvider,
          // 图片拉伸方式
          fit: BoxFit.contain,
          // 支持手势 放大、旋转
          mode: ExtendedImageMode.gesture,
          // 初始手势配置
          initGestureConfigHandler: (state) {
            return GestureConfig(
              minScale: 0.9, // 最小缩放
              animationMinScale: 0.7, // 动画最小缩放
              maxScale: 3.0, // 最大缩放
              animationMaxScale: 3.5, // 动画最大缩放
              speed: 1.0, // 缩放速度
              inertialSpeed: 100.0, // 惯性速度
              initialScale: 1.0, // 初始缩放
              inPageView: true, // 在页面视图中
            );
          },
        );
      },
    );
  }

  /// 主视图
  Widget _mainView() {
    Widget body = const Text("loading");

    // 视频
    if (widget.videoUrl != null || widget.videoLocalPath != null) {
      body = _buildVideoView();
    }
    // 图片
    else if (widget.imgUrl != null || widget.imgLocaPath != null) {
      body = _buildImageView();
    }

    return GestureDetector(
      // 不许穿透
      behavior: HitTestBehavior.opaque,
      // 点击返回
      onTap: () => setState(() => _isShowAppBar = !_isShowAppBar),
      // onTap: () => Navigator.pop(context),
      child: Scaffold(
        // 全屏, 高度将扩展为包括应用栏的高度
        extendBodyBehindAppBar: true,

        // 背景黑色
        backgroundColor: Colors.black,

        // 导航栏
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_outlined,
              color: Colors.white,
              size: 36,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),

        // 图片浏览
        body: SafeArea(child: body),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _mainView();
  }
}
