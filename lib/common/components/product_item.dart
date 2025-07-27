import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/route_manager.dart';
import 'package:template/common/index.dart';



class ProductItem extends StatelessWidget {

  /// 点击事件
  final Function()? onTap;

  /// 商品数据模型
  final ItemModel product;

  /// 图片宽
  final double? imgWidth;

  /// 图片高
  final double? imgHeight;

  const ProductItem({
    super.key, 
    this.onTap, 
    required this.product, 
    this.imgWidth, 
    this.imgHeight
  });

  Widget _buildView(
    BuildContext context
  ) {
    var ws = [

      ImageWidget.img(
        product.album[0],
        fit: BoxFit.cover,
        width: imgWidth,
        height: imgHeight,
      ),

      TextWidget.h4(
        product.description,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),

      TextWidget.h4(
        "NTD\$200",
        color: context.colors.scheme.error
      ),

      [
        ImageWidget.img(
          product.seller.avatar,
          fit: BoxFit.cover,
          width: 20,
          height: 20,
          radius: 10,
        ),
        TextWidget.label(
          product.seller.diaplayName,
          overflow: TextOverflow.ellipsis,
        ),
      ].toRow()

    ].toColumn();


    return ws;
  }

  @override
  Widget build(BuildContext context) {
    return _buildView(context);
  }
}