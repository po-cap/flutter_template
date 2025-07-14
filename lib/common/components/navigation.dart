import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../index.dart';

/// 导航栏数据模型
class NavigationItemModel {
  final String label;
  final String icon;
  final int count;

  NavigationItemModel({
    required this.label,
    required this.icon,
    this.count = 0,
  });
}

/// 导航栏
class BuildNavigation extends StatelessWidget {
  final int currentIndex;
  final List<NavigationItemModel> items;
  final Function(int) onTap;

  const BuildNavigation({
    super.key,
    required this.currentIndex,
    required this.items,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    var ws = <Widget>[];

    for (var i = 0; i < items.length; i++) {

      // 中間要加一個空間
      if (i == items.length / 2 && items.length % 2 == 0) {
        ws.add(SizedBox(
          width: 36,
        ));
      }

      var color = (i == currentIndex)
          ? context.colors.scheme.primary
          : context.colors.scheme.outline;
      var item = items[i];
      ws.add(
        <Widget>[
          // 图标
          IconWidget.svg(
            item.icon,
            size: 24,
            color: color,
            badgeString: item.count > 0 ? item.count.toString() : null,
          ).paddingBottom(2),
          // 文字
          TextWidget.label(
            item.label.tr,
            color: color,
          ),
        ]
        .toColumn(
          mainAxisAlignment: MainAxisAlignment.center, // 居中
          mainAxisSize: MainAxisSize.max, // 最大
        )
        .onTap(() => onTap(i))
        .expanded(),
      );
    }
    return BottomAppBar(
      shape: CircularNotchedRectangle(), // 凹槽形状
      notchMargin: 5.0, 
      color: context.colors.scheme.surface,
      elevation: 0,
      child: ws
      .toRow(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
      )
      .height(kBottomNavigationBarHeight * 1.2),
    );
  }
}
