import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../index.dart';

/// 数量编辑
class QuantityWidget extends StatelessWidget {
  // 数量发送改变
  final Function(int quantity) onChange;
  // 数量
  final int quantity;
  // 尺寸
  final double? size;
  // 文字尺寸
  final double? fontSize;
  // padding 水平距离
  final double? paddingHorizontal;

  const QuantityWidget({
    super.key,
    required this.quantity,
    required this.onChange,
    this.size,
    this.fontSize,
    this.paddingHorizontal,
  });

  @override
  Widget build(BuildContext context) {
    return <Widget>[
      // 减号 
      ButtonWidget.icon(
        Icon(
          CupertinoIcons.minus,
          size: fontSize ?? 18,
          color: Get.theme.colorScheme.onTertiaryContainer,
        ),
        onTap: () => onChange(quantity - 1 < 0 ? 0 : quantity - 1),
      ).constrained(
        height: 30,
        width: 30
      ).decorated(
        color: Get.theme.colorScheme.tertiaryContainer,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(15),
          bottomLeft: const Radius.circular(15),
        ),
      ),

      // 数量
      TextWidget.body(
        "$quantity",
        color: Get.theme.colorScheme.onSurface,
        weight: FontWeight.bold,
      )
          .center()
          .tight(width: size ?? 24, height: size ?? 24)
          //.decorated(
          //  borderRadius: const BorderRadius.all(Radius.circular(4)),
          //  border: Border.all(
          //    color: color ?? context.colors.scheme.outline,
          //    width: 1,
          //  ),
          //)
          .paddingHorizontal(paddingHorizontal ?? AppSpace.iconTextSmail),

      // 加号
      ButtonWidget.icon(
        Icon(
          CupertinoIcons.plus,
          size: fontSize ?? 18,
          color: Get.theme.colorScheme.onTertiaryContainer,
        ),
        onTap: () => onChange(quantity + 1),
      ).constrained(
        height: 30,
        width: 30
      ).decorated(
        color: Get.theme.colorScheme.tertiaryContainer,
        borderRadius: BorderRadius.only(
          topRight: const Radius.circular(15),
          bottomRight: const Radius.circular(15),
        ),
      ),

    ].toRow();
  }
}
