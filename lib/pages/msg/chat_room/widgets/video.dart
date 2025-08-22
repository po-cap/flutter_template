import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayer extends StatefulWidget {
  const VideoPlayer({
    super.key, 
    required this.url
  });

  final String url;

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {

  late VideoPlayerController _videoPlayerController;
  
  ChewieController? _chewieController;

  Future<void> _initializeVideo() async {
    _videoPlayerController = 
      VideoPlayerController.networkUrl(Uri.parse(widget.url));
    await _videoPlayerController.initialize();

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: false,
      looping: false,
      allowFullScreen: true,
    );

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  Widget _buildLoadingPlaceholder() {
  return SizedBox(
    width: double.infinity,
    height: 200, // 明確的高度
    child: const Center(child: CircularProgressIndicator()),
  );
}

  @override
  Widget build(BuildContext context) {
    
    if (_chewieController == null || 
        !_videoPlayerController.value.isInitialized) {
      return _buildLoadingPlaceholder();
    }
    
    return SizedBox(
      height: 200,
      width: 100,
      child: Text("ss"),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final aspectRatio = _videoPlayerController.value.aspectRatio;
        final width = constraints.maxWidth;
        final height = width / aspectRatio;

        return SizedBox(
          width: width,
          height: height,
          child: Chewie(controller: _chewieController!),
        );
      },
    );
  }
}