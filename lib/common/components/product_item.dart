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
      ),

      TextWidget.body(
        item.spec['price'],
        color: context.colors.scheme.error
      ),

      [
        ImageWidget.img(
          item.seller.avatar,
          fit: BoxFit.cover,
          width: 20,
          height: 20,
          radius: 10,
        ).paddingRight(AppSpace.listItem),

        TextWidget.label(
          item.seller.diaplayName,
          overflow: TextOverflow.ellipsis,
        ),
      ].toRow()

    ].toColumn(
      crossAxisAlignment: CrossAxisAlignment.start
    );

    return ws.onTap(() {
      Get.toNamed(
        RouteNames.goodsItemDetail,
        arguments: {
          'item': item
        } 
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return _buildView(context);
  }
}