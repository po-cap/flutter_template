import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/common/index.dart';

class DropdownWidget<T> extends StatelessWidget {
  const DropdownWidget({
    super.key, 
    this.label,
    required this.items, 
    this.onChanged,
    this.value
  });

  final String? label;

  final T? value;

  final List<T>? items;

  final void Function(T?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      value: value,
      isExpanded: true,
      items: items?.map((e) {
        return DropdownMenuItem(
          value: e,
          child: Text(
            e.toString(),
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        );
      }).toList(),
      hint: label != null ? Text(
        label!,
        style: TextStyle(
          color: Get.theme.colorScheme.inverseSurface,
          fontSize: 12
        ),
      ) : null,
      onChanged: onChanged,
      underline: Container(
        height: 0,
        color: Colors.transparent,
      ),
    ).constrained(
      maxHeight: 42
    ).paddingHorizontal(AppSpace.appbar)
    .decorated(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(5),
      border: Border.all(
        color: Get.theme.colorScheme.outlineVariant
      ),
    ).paddingHorizontal(AppSpace.button);
  }
}