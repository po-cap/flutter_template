import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/common/style/index.dart';
import 'package:template/common/widgets/index.dart';

class ShippingFeeWidget extends StatefulWidget {
  const ShippingFeeWidget({
    super.key,
    required this.onChanged
  });

  final Function(double fee) onChanged;

  @override
  State<ShippingFeeWidget> createState() => _ShippingFeeWidgetState();
}

class _ShippingFeeWidgetState extends State<ShippingFeeWidget> {
  
  final feeController = TextEditingController();


  @override
  void dispose() {
    feeController.dispose();
    super.dispose();
  }

  Widget _buildView() {
    return SingleChildScrollView(
      child: <Widget>[

        <Widget>[
          TextWidget.h4(
            "運費",
            weight: FontWeight.bold,
            color: Get.theme.colorScheme.tertiary
          ).paddingRight(AppSpace.listItem),   
          
          InputWidget(
            keyboardType: TextInputType.number,
            controller: feeController,
            onChanged: (val) {
              setState(() {
                feeController.text = val;
                widget.onChanged(double.parse(val));
              });
            },
          ).expanded(),        
        ].toRow(),
      ].toColumn(
        crossAxisAlignment: CrossAxisAlignment.start
      )
      .paddingVertical(AppSpace.page * 3)
      .paddingHorizontal(AppSpace.page * 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("設定運費"),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: _buildView(),
    );
  }
}