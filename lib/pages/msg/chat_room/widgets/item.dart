

import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/common/index.dart';

class ItemWidget  extends SliverPersistentHeaderDelegate{

  final ItemModel item;

  ItemWidget(this.item);

  @override
  Widget build(
    BuildContext context, 
    double shrinkOffset, 
    bool overlapsContent
  ) {

    Widget ws = <Widget>[
      ImageWidget.img(
        item.album[0],
        width: 60, 
        height: 60,
        fit: BoxFit.fill,
        radius: 5,
      ).paddingRight(
        AppSpace.listItem
      ),
      <Widget>[
        TextWidget.h4(
          item.spec['price'],
          color: Get.context!.colors.scheme.error
        ),
        TextWidget.body(
          item.description,
          overflow: TextOverflow.ellipsis,
        ),
      ].toColumn(
        crossAxisAlignment: CrossAxisAlignment.start
      ),
    ].toRow(  )
    .paddingAll(AppSpace.listItem)
    .border(
      color: Get.context!.colors.scheme.surfaceContainerHigh,
      bottom: 1
    );

    return ws.backgroundColor(Get.context!.colors.scheme.surface);
  }

  @override
  double get maxExtent => 80;

  @override
  double get minExtent => 80;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

}