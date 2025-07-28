import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/common/index.dart';

import 'index.dart';

class PriceEditPage extends GetView<PriceEditController> {

  final SkuModel? sku;

  const PriceEditPage({
    super.key,
    this.sku
  });



  // 主视图
  Widget _buildView() {
    return [

      if(sku!.name.isNotEmpty)
      TextWidget.h4("設定\"${sku!.name}\""),

      InputWidget(
        controller: controller.priceController,
        placeholder: "價格",
        keyboardType: TextInputType.numberWithOptions(
          decimal: true
        ),
      ).paddingBottom(AppSpace.listItem),

      InputWidget(
        controller: controller.quantityController,
        placeholder: "庫存",
        keyboardType: TextInputType.number,
      ),

    ].toColumn()
    .paddingAll(AppSpace.page);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PriceEditController>(
      init: Get.find<PriceEditController>(),
      id: "price_edit",
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: TextWidget.h4("設定價格與數量")
          ),
          body: SafeArea(
            child: _buildView(),
          ),
          bottomSheet: SheetButtonWidget(
            onTap: () => controller.onSetSkuPrice(sku), 
            text: "設定",
            withBackNav: true
          ),
        );
      },
    );
  }
}
