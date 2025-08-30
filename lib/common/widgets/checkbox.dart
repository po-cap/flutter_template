import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:template/common/index.dart';

/// 复选框
class CheckboxWidget extends StatelessWidget {
  const CheckboxWidget({
    super.key,
    this.checked,
    this.title,
    this.description,
    this.onChanged,
  });

  final bool? checked;
  final String? title;
  final String? description;

  final Function(bool?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return <Widget>[
      // 图标按钮
      Icon(
        checked == true ? Icons.check_box : Icons.check_box_outline_blank,
        color: context.colors.scheme.onSurface.withValues(alpha: 0.8),
      ),

      // 标题、说明
      if (title != null || description != null)
        <Widget>[
          if (title != null) TextWidget.label(title!),
          if (description != null)
            TextWidget.muted(
              description!,
              softWrap: true,
              maxLines: 3,
            ),
      ]
      .toColumnSpace(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
      ),
    ]
    .toRowSpace(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
    )
    .gestures(onTap: () {
      onChanged?.call(!(checked ?? false));
    });
  }
}