import 'package:flutter/material.dart';
import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:template/common/index.dart';

class BarItemWidget extends StatelessWidget {
  final String title;
  final String svgPath;

  const BarItemWidget({
    super.key,
    required this.title,
    required this.svgPath,
  });

  @override
  Widget build(BuildContext context) {
    return <Widget>[
      // 图标
      IconWidget.svg(
        svgPath,
        size: 24,
        color: context.colors.scheme.primary,
      ).paddingBottom(AppSpace.iconTextSmail),

      // 标题
      TextWidget.label(
        title,
      ),
    ].toColumn();
  }
}
