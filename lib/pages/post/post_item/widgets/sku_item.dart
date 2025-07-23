import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/common/index.dart';
import 'package:template/pages/index.dart';


class SkuItem extends StatelessWidget {
  const SkuItem({super.key});

  Widget _buildView(PostItemController controller) {
    return <Widget>[

      AppBar(
        backgroundColor: Colors.transparent,
        title: Text("設置庫存價格"),
        actions: [
          IconButton(
            onPressed: () {
              List.generate(2, (_) {
                Get.back();
              });
            }, 
            icon: Icon(Icons.close)
          )
        ],

      ),

      for(final sku in controller.skus) 
      GestureDetector(
        onTap: () {
          showModalBottomSheet(
            context: Get.context!, 
            isScrollControlled: true,
            builder:(context) {
              return PriceItem(
                sku: sku
              );
            },
          );
        },
        child: [
          [
            TextWidget.h4(sku.name),
            TextWidget.label("價格 \$${sku.price} 庫存 ${sku.availableStock} 件"),
          ].toColumn(
            crossAxisAlignment: CrossAxisAlignment.start
          ),
          Icon(Icons.chevron_right)
        ].toRow( mainAxisAlignment: MainAxisAlignment.spaceBetween)
        .paddingAll(AppSpace.card)
        .card()
        .paddingBottom(AppSpace.listItem),
      ),            

      <Widget>[
        Flexible(
          flex: 1,
          child: ButtonWidget.ghost(
            "上一步",
            onTap: () {
            },
          ),
        ),
        Expanded(
          child: ButtonWidget.primary(
            "完成",
            onTap: () {
            },
          ),
        ),
      ]
      .toRow(
        mainAxisAlignment: MainAxisAlignment.spaceAround
      )
      .width(double.infinity)
    ].toColumn(
      crossAxisAlignment: CrossAxisAlignment.center
    )
    .paddingAll(AppSpace.page);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PostItemController>(
      id: "price_editor",
      builder: (controller) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          child: _buildView(controller),
        );
      },
    );
  }
}