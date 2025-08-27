import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:template/common/index.dart';

class PriceWidget extends StatefulWidget {
  const PriceWidget({
    super.key, 
    required this.sku, 
    required this.onChanged
  });

  final SkuModel sku;

  final Function(SkuModel sku) onChanged;

  @override
  State<PriceWidget> createState() => _PriceWidgetState();
}

class _PriceWidgetState extends State<PriceWidget> {

  /// 編輯價格控制器ㄋ
  TextEditingController priceController = TextEditingController();

  /// 編輯數量控制器
  TextEditingController quantityController = TextEditingController();


  Widget _buildTextEdit({
    required String label, 
    required TextEditingController controller,
    String? prefix
  }) {
    return <Widget>[
      TextWidget.label(
        label,
      ),
      TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          border: InputBorder.none,
          prefix: prefix != null ? Text(prefix) : null,
          labelText: label
        ),
      )
    ].toRow();
  }

  Widget _buildMainView() {
    return <Widget>[

      if(widget.sku.name.isNotEmpty)
      TextWidget.h4("設定規格: ${widget.sku.name}"),

      _buildTextEdit(
        label: "價格",
        controller: priceController,
        prefix: "\$",
      ),
      _buildTextEdit(
        label: "數量",
        controller: quantityController,
      ),
    ].toColumn();
  }


  @override
  void initState() {
    super.initState();
    priceController.text = widget.sku.price.toString();
    quantityController.text = widget.sku.quantity.toString();
  }


  @override
  void dispose() {
    super.dispose();
    priceController.dispose();
    quantityController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildMainView(),
      bottomSheet: SheetButtonWidget(
        onTap: () => widget.onChanged(
          widget.sku
            ..price = double.parse(priceController.text)
            ..quantity = int.parse(quantityController.text)
        ), 
        text: "設定",
        withBackNav: true
      ),
    );
  }
}