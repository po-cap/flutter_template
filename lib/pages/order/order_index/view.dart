import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/common/index.dart';

import 'index.dart';

class OrderIndexPage extends GetView<OrderIndexController> {
  const OrderIndexPage({super.key});


  Widget _buildItem({
    required ItemModel item
  }) {
    return [
      ImageWidget.img(
        item.album[0],
        width: 60, 
        height: 60,
        fit: BoxFit.fill,
        radius: 5,
      ),
      [
        TextWidget.body(
          item.description,
          maxLines: 1,
          weight: FontWeight.bold,
          overflow: TextOverflow.ellipsis,
        ),
        TextWidget.body(
          item.spec['price'],
          color: Get.context!.colors.scheme.error
        ),
      ].toColumn()
    ].toRow();
  }

  Widget _buildAddress() {
    
    final address = UserService.to.addresses[0];
    
    return ListTile(
      leading: IconWidget.svg(
        AssetsSvgs.locationSvg
      ),
      title: TextWidget.body(
        address.toString(),
        weight: FontWeight.bold,
      ),
      subtitle: TextWidget.label(
        '${address.receiver} ${address.phone}',
        color: Get.theme.colorScheme.tertiary,
      ),
      trailing: IconButton(
        onPressed: () {}, 
        icon: Icon(Icons.chevron_right_sharp)
      ),      
    );
  }


  // 主视图
  Widget _buildView() {
    return CustomScrollView(
      slivers: [
        _buildItem(
          item: controller.item
        ).sliverToBoxAdapter(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderIndexController>(
      init: OrderIndexController(),
      id: "order_index",
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text("order_index")),
          body: SafeArea(
            child: _buildView(),
          ),
        );
      },
    );
  }
}
