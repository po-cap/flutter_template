import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/common/index.dart';
import 'package:template/pages/index.dart';

class PriceItem extends StatelessWidget {

  final SkuModel sku;

  const PriceItem({
    super.key,
    required this.sku
  });


  Widget _buildInput() {
    return GetBuilder<PostItemController>(
      builder: (controller) => [
        TextWidget.label("價格"),
        InputWidget(
          controller: controller.priceController,
          keyboardType: TextInputType.numberWithOptions(
            decimal: true
          ),
        ),
        TextWidget.label("庫存"),
        InputWidget(
          controller: controller.quantityController,
          keyboardType: TextInputType.number,
        ),
      ].toColumn(
        crossAxisAlignment: CrossAxisAlignment.start
      ).padding(all: AppSpace.card)
      .card()
      .paddingBottom(AppSpace.listItem * 2),
    ); 
  }

  Widget _buildButton() {
    return GetBuilder<PostItemController>(
      builder: (controller) => [
        Flexible(
          flex: 1,
          child: ButtonWidget.ghost(
            "上一頁",
            onTap: () {
              Get.back();
            }
          )
        ),
        Expanded(
          flex: 2,
          child: ButtonWidget.primary(
            "完成",
            onTap: () => controller.onSetSkuPriceAndQuantity(sku),
          )
        )
      ].toRow(
        mainAxisAlignment: MainAxisAlignment.spaceAround
      ).width(double.infinity)
    );
  }

  Widget _buildView() {
    return <Widget>[
      AppBar(
        backgroundColor: Colors.transparent,
        title: Text("設置庫存價格"),
        actions: [
          IconButton(
            onPressed: () {
              List.generate(3, (_) {
                Get.back();
              });
            }, 
            icon: Icon(Icons.close)
          )
        ],
      ),

      TextWidget.h4(
        "選中的規格: ${sku.name}"
      ).paddingAll(AppSpace.card),
      _buildInput(),
      _buildButton()
    ].toColumn(
      crossAxisAlignment: CrossAxisAlignment.start
    ).paddingAll(AppSpace.page);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PostItemController>(
      builder:(controller) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          child: _buildView()
        );    
      },
    );
  }
}