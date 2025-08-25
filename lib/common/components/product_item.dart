import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/common/index.dart';



class ProductItemWidget extends StatelessWidget {

  /// 点击事件
  final Function()? onTap;

  /// 商品数据模型
  final ItemModel item;


  const ProductItemWidget({
    super.key, 
    this.onTap, 
    required this.item, 
  });

  Widget _buildView(
    BuildContext context
  ) {
    var ws = [

      ImageWidget.img(
        item.album[0],
        fit: BoxFit.cover,
      ),

      TextWidget.h4(
        item.description,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ).paddingHorizontal(AppSpace.titleContent),

      TextWidget.h4(
        item.spec['price'],
        color: context.colors.scheme.error,
        scale: WidgetScale.small
      ).paddingHorizontal(AppSpace.titleContent),

      [
        ImageWidget.img(
          item.seller.avatar!,
          fit: BoxFit.cover,
          width: 20,
          height: 20,
          radius: 10,
        ).paddingRight(AppSpace.listItem),

        TextWidget.label(
          item.seller.displayName!,
          overflow: TextOverflow.ellipsis,
        ),
      ].toRow().paddingHorizontal(AppSpace.titleContent),

    ].toColumn(
      crossAxisAlignment: CrossAxisAlignment.start
    ).paddingBottom(AppSpace.titleContent);

    return ws.onTap(() {
      Get.toNamed(
        RouteNames.goodsItemDetail,
        arguments: {
          'item': item
        } 
      );
    }).card(
      margin:  EdgeInsets.all(0),
      elevation: AppElevation.card
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildView(context);
  }
}