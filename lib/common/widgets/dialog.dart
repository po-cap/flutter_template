import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:template/common/index.dart';

/// dialog 对话框
class DialogWidget extends StatelessWidget {
  const DialogWidget({
    super.key,
    this.onCancel,
    this.onConfirm,
    this.title,
    this.description,
    this.content,
    this.footer,
    this.titleString,
    this.descriptionString,
    this.padding,
    this.backgroundColor,
    this.radius,
    this.border,
    double? width,
    double? height,
    double? elevation,
    this.cancel,
    this.confirm,
  })  : _elevation = elevation,
        _height = height,
        _width = width;

  final Widget? title;
  final Widget? description;
  final Widget? content;
  final Widget? footer;

  final String? titleString;
  final String? descriptionString;

  final double? padding;
  final Color? backgroundColor;
  final double? radius;
  final double? border;
  final double? _width;
  final double? _height;
  final double? _elevation;

  final Widget? cancel;
  final Widget? confirm;
  final void Function()? onCancel;
  final void Function()? onConfirm;

  static Future<T?> show<T>({
    required BuildContext context,
    Widget? title,
    Widget? description,
    Widget? content,
    Widget? footer,
    String? titleString,
    String? descriptionString,
    double? padding,
    Color? backgroundColor,
    double? radius,
    double? border,
    double? width,
    double? height,
    double? elevation,
    Widget? confirm,
    Widget? cancel,
    void Function()? onConfirm,
    void Function()? onCancel,
  }) {
    return showDialog<T>(
      context: context,
      barrierColor: const Color(0xFF09101D).withValues(alpha: 0.7),
      builder: (context) => DialogWidget(
        title: title,
        description: description,
        content: content,
        footer: footer,
        titleString: titleString,
        descriptionString: descriptionString,
        padding: padding,
        backgroundColor: backgroundColor,
        radius: radius,
        border: border,
        width: width,
        height: height,
        elevation: elevation,
        confirm: confirm,
        cancel: cancel,
        onCancel: onCancel,
        onConfirm: onConfirm,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> ws = [];

    // 标题
    if (title != null) {
      ws.add(title!);
    } else if (titleString != null) {
      ws.add(TextWidget.h4(titleString!));
    }

    // 描述
    if (description != null) {
      ws.add(description!);
    } else if (descriptionString != null) {
      ws.add(TextWidget.muted(descriptionString!));
    }

    // 内容
    if (content != null) {
      ws.add(content!);
    }

    // 确认，取消 按钮组
    List<Widget> btns = [];
    if (cancel != null) {
      btns.add(cancel!);
    }
    if (confirm != null) {
      btns.add(confirm!);
    }
    if (onCancel != null) {
      btns.add(ButtonWidget.ghost(
        'cancel',
        onTap: onCancel,
      ));
    }
    if (onConfirm != null) {
      btns.add(ButtonWidget.primary(
        'confirm',
        onTap: onConfirm,
      ));
    }
    ws.add(btns.length == 1
        ? btns[0]
        : btns
            .toRowSpace(
              mainAxisSize: MainAxisSize.min,
            )
            .alignment(Alignment.center));

    // 底部
    if (footer != null) {
      ws.add(footer!);
    }

    // 组件
    Widget child = ws.toColumnSpace(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
    );

    // 内边距
    child = child.padding(
      horizontal: padding ?? AppPadding.card.horizontal,
      vertical: padding ?? AppPadding.card.vertical,
    );

    // 背景、圆角、边框
    child = child.decorated(
      color: backgroundColor ?? context.colors.scheme.surface,
      borderRadius: BorderRadius.circular(
        radius ?? AppRadius.card,
      ),
      border: Border.all(
        color: context.colors.scheme.outline,
        width: border ?? AppBorder.card,
      ),
    );

    // 阴影
    child = child.elevation(
      _elevation ?? AppElevation.card,
      borderRadius: BorderRadius.circular(
        radius ?? AppRadius.card,
      ),
      shadowColor: context.colors.shadow,
    );

    // 约束
    if (_width != null || _height != null) {
      child = child.tight(
        height: _height,
        width: _width,
      );
    }

    return Dialog(
      child: child,
    );
  }
}
