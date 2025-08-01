import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';

import '../index.dart';

class InputWidget extends StatefulWidget {
  const InputWidget({
    super.key,
    this.controller,
    this.placeholder,
    this.prefix,
    this.suffix,
    this.obscureText = false,
    this.cleanable = true,
    this.readOnly = false,
    this.onChanged,
    this.onEditingComplete,
    this.keyboardType,
    this.autofocus,
    this.minLines,
    this.maxLines,
    this.hasBorder = true,
    this.autoClear = false,
  });

  /// 输入框控制器
  final TextEditingController? controller;

  /// 占位符
  final String? placeholder;

  /// 前缀
  final Widget? prefix;

  /// 后缀
  final Widget? suffix;

  /// 是否隐藏文本
  final bool? obscureText;

  /// 是否可清空
  final bool? cleanable;

  /// 是否只读
  final bool? readOnly;

  /// 输入变化回调
  final Function(String)? onChanged;

  /// 输入完成回调
  final Function(String)? onEditingComplete;

  /// 输入法类型
  final TextInputType? keyboardType;

  /// 自动焦点
  final bool? autofocus;

  /// 最小行數
  final int? minLines;  

  /// 最大行數
  final int? maxLines;

  /// 是否有边框
  final bool? hasBorder;

  /// 自动清空
  final bool? autoClear;

  // final FocusNode focusNode;
  // final TextStyle style;
  // final Color cursorColor;
  // final Color backgroundCursorColor;

  @override
  State<InputWidget> createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  late TextEditingController controller;
  FocusNode focusNode = FocusNode();
  bool? hasFocus;
  bool? showPassword = false;
  bool showClean = false;

  Widget? prefix;
  Widget? suffix;

  @override
  void initState() {
    super.initState();

    controller = widget.controller ?? TextEditingController();
    hasFocus = focusNode.hasFocus;
    focusNode.addListener(_onFocusChange);
    prefix = widget.prefix;
    suffix = widget.suffix;
  }

  // 监听是否失去焦点
  void _onFocusChange() {
    setState(() {
      hasFocus = focusNode.hasFocus;
    });
  }

  Widget _buildView() {
    var colorScheme = context.colors.scheme;

    // 显示密码按钮
    if (widget.obscureText == true) {
      suffix = Icon(
        showPassword == true ? Icons.visibility : Icons.visibility_off,
        size: 20,
      ).ripple().clipOval().gestures(
            onTap: () => setState(() {
              showPassword = !showPassword!;
            }),
          );
    }

    // 清除按钮
    Widget? cleanButton = widget.cleanable == true && showClean == true
        ? ButtonWidget.icon(
            const Icon(
              Icons.cancel,
              size: 20,
            ),
            onTap: () {
              controller.clear();
              setState(() {
                showClean = false;
              });
              widget.onChanged?.call("");
            },
          )
        : null;

    // 占位文本
    Widget? placeholder = controller.text.isEmpty &&
            hasFocus == false &&
            widget.placeholder != null
        ? Align(
            alignment: Alignment.centerLeft,
            child: TextWidget.muted(
              widget.placeholder!,
            ),
          )
        : null;

    // 2 输入框
    Widget textField = EditableText(
      controller: controller,
      focusNode: focusNode,
      readOnly: widget.readOnly ?? false,
      style: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 16,
      ),
      cursorColor: colorScheme.onSurface,
      backgroundCursorColor: Colors.transparent,
      onTapOutside: (tapOutside) {
        focusNode.unfocus();
      },
      obscureText: widget.obscureText == true && showPassword == false,
      onChanged: (value) {
        setState(() {
          showClean = value.isNotEmpty;
        });
        widget.onChanged?.call(value);
      },
      onEditingComplete:() {
        widget.onEditingComplete?.call(controller.text);
        if(widget.autoClear == true) {
          controller.clear();
          focusNode.unfocus();
        }
      },
      keyboardType: widget.keyboardType,
      autofocus: widget.autofocus ?? false,
      minLines: widget.minLines ?? 1,
      maxLines: widget.maxLines ?? 1,
    );

    // 输入区域
    Widget inputArea = Stack(
      children: [
        if (placeholder != null) Positioned.fill(child: placeholder),
        textField,
        if (cleanButton != null)
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: Center(child: cleanButton),
          ),
      ],
    );

    // 返回
    return Container(
      padding: const EdgeInsets.all(5),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.input),
          border: Border.all(
            color: widget.hasBorder == true ? colorScheme.primary : Colors.transparent,
            width: hasFocus == true ? 2 : 0,
          ),
        ),
        child: <Widget>[
          if (prefix != null) prefix!,
          Expanded(child: inputArea),
          if (suffix != null)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: suffix!,
            ),
        ].toRowSpace(
          space: 5,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildView();
  }
}

