import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/common/index.dart';
import 'package:template/pages/index.dart';


class SkuEditPage extends GetView<SkuEditController> {
  const SkuEditPage({super.key});

  Widget _buildSku(SkuModel sku) {
    return [
      [
        TextWidget.h4(sku.name),
        TextWidget.body("價格 \$${sku.price} 庫存 ${sku.quantity} 件")
      ].toColumn(
        crossAxisAlignment: CrossAxisAlignment.start
      ),
      Icon(Icons.chevron_right)
    ].toRow(
      mainAxisAlignment: MainAxisAlignment.spaceBetween
    )
    .width(double.infinity)
    .paddingAll(AppSpace.card)
    .card();
  }

  // 主视图
  Widget _buildView() {
    return GetBuilder<PostItemController>(
      builder: (postItemController) {
        return [
          for(var sku in postItemController.skus)
          InkWell(
            onTap: () => controller.onSetSkuPrice(sku),
            child: _buildSku(sku).paddingBottom(AppSpace.listView)
          )
        ].toColumn().paddingAll(AppSpace.page);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SkuEditController>(
      init: Get.find<SkuEditController>(),
      id: "sku_edit",
      builder: (_) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          child: Scaffold(
            
            // 頭部導航
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              title: const Text("設置庫存價格")
            ),

            // 內容
            body: SafeArea(
              child: _buildView(),
            ),

            // 底部導航
            bottomSheet: SheetButtonWidget(
              onTap: () {
                Get.until((route) => route.settings.name == RouteNames.postPostItem);
              }, 
              text: "完成",
              withBackNav: true
            ),
          ),
        );
      },
    );
  }
}
