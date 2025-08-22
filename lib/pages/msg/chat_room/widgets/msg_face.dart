import 'package:flutter/material.dart';
import 'package:template/common/index.dart';

/// 表情消息
class MsgFaceElemWidget extends StatelessWidget {
  final String url;

  const MsgFaceElemWidget({
    super.key,
    required this.url,
  });

  Widget _buildView() {
    return ImageWidget.img(
      url,
      width: 96,
      height: 96,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildView();
  }
}