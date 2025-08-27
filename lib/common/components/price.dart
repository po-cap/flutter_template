import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:template/common/index.dart';

class PriceWidget extends StatefulWidget {
  const PriceWidget({
    super.key, 
    this.sku,
    required this.onSkuChanged
  });

  final SkuModel? sku;

  final Function(SkuModel) onSkuChanged;

  @override
  State<PriceWidget> createState() => _PriceWidgetState();
}

class _PriceWidgetState extends State<PriceWidget> {

  /// 編輯的規格
  late SkuModel sku;

  /// 編輯價格控制器
  TextEditingController priceController = TextEditingController();

  /// 編輯數量控制器
  TextEditingController quantityController = TextEditingController();

  Widget _buildTextEdit({
    required String label, 
    required TextEditingController controller,
    String? prefix
  }) {
    return TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          //border: InputBorder.none,
          prefix: prefix != null ? Text(prefix) : null,
          labelText: label
        ),
      );
  }

  Widget _buildMainView() {
    return SingleChildScrollView(
      child: <Widget>[

        _buildTextEdit(
          label: "價格",
          controller: priceController,
          prefix: "\$",
        ).paddingBottom(AppSpace.listItem * 2),
        _buildTextEdit(
          label: "數量",
          controller: quantityController,
        ),
      ].toColumn()
      .paddingAll(AppSpace.page * 2)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: TextWidget.h4("設定規格: ${sku.name}"),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: _buildMainView(),
      bottomSheet: SheetButtonWidget(
        onTap: () {
          widget.onSkuChanged(
            sku
              ..price = double.parse(priceController.text)
              ..quantity = int.parse(quantityController.text)
          );
          priceController.clear();
          quantityController.clear();
          Navigator.pop(context);
        }, 
        text: "設定",
        withBackNav: true
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    if(widget.sku != null) {
      sku = widget.sku!;
      if(sku.price != 0) {
        priceController.text = sku.price.toString();
      }
      if(sku.quantity != 0) {
        quantityController.text = sku.quantity.toString();
      }
    } 
    else {
      sku = SkuModel(
        id: 0, 
        name: "", 
        specs: {}, 
        photo: "", 
        price: 0, 
        quantity: 0
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    priceController.dispose();
    quantityController.dispose();
  }
}