import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/common/index.dart';

class SkusWidget extends StatefulWidget {
  const SkusWidget({
    super.key, 
    required this.skus,
    required this.onSkusChanged
  });

  /// 初始庫存單元
  final List<SkuModel> skus;

  /// 銷售屬性變更時觸發
  final Function(List<SkuModel> skus) onSkusChanged;

  @override
  State<SkusWidget> createState() => _SkusWidgetState();
}




class _SkusWidgetState extends State<SkusWidget> {

  late List<SkuModel> skus;

  @override
  void initState() {
    super.initState();
    skus = widget.skus;
  }


  Widget _buildList(SkuModel sku) {
    return ListTile(
      title: TextWidget.h4(sku.name),
      subtitle: TextWidget.body("價格 \$${sku.price} 庫存 ${sku.quantity} 件"),
      trailing: Icon(Icons.chevron_right),
      tileColor: Get.theme.colorScheme.tertiaryContainer,
      textColor: Get.theme.colorScheme.onTertiaryContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8)
      ),
      onTap: () async {
        // 調整庫存單元價格和存量
        await ActionBottomSheet.barModel(
          PriceWidget(
            sku: sku,
            onSkuChanged: (sku) {
              setState(() {
                skus[widget.skus.indexOf(sku)] = sku;
                widget.onSkusChanged(skus);
              });
            }
          )
        );
        // 更新銷售屬性
        widget.onSkusChanged(skus);
      },
    )
    .paddingHorizontal(AppSpace.page)
    .paddingBottom(AppSpace.listItem);
  }

  Widget _buildMainView() {
    return SingleChildScrollView(
      child: <Widget>[
        for(var sku in widget.skus)
        _buildList(sku)

      ].toColumn().paddingTop(AppSpace.page * 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextWidget.h4("設置價格與庫存"),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () => Get.offNamedUntil(
              RouteNames.postPostShort, 
              (_) => false
            ),
          ),
        ],
      ),
      body: _buildMainView(),
      bottomSheet: SheetButtonWidget(
        onTap: () {
          Get.offNamedUntil(RouteNames.postPostShort, (_) => false);
        }, 
        text: "完成",
        withBackNav: true
      ),
    );
  }
}