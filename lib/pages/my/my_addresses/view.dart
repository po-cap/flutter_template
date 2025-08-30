import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/common/index.dart';

import 'index.dart';

class MyAddressesPage extends GetView<MyAddressesController> {
  const MyAddressesPage({super.key});

  // 主视图
  Widget _buildView() {
    return CustomScrollView(
      slivers: <Widget>[


        Obx(
          () => SliverList.builder(
            itemBuilder: (_, index) {
          
              final address = UserService.to.addresses[index];
          
              return ListTile(
                title: TextWidget.body(
                  '${address.receiver} ${address.phone}',
                  weight: FontWeight.bold,
                ),
                subtitle: TextWidget.label(address.toString()),
                leading: address.type == 'seven' ? 
                  IconWidget.svg(
                    AssetsSvgs.sevenElevenSvg,
                    size: 36,
                  ): 
                  address.type == 'family' ? 
                    IconWidget.svg(
                      AssetsSvgs.familyMartSvg,
                      size: 36,
                    ) : 
                    IconWidget.svg(
                      AssetsSvgs.pHomeSvg,
                      size: 36,
                    ),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => controller.onEditAddress(address),
                ),
              ).card()
              .paddingBottom(AppSpace.listItem);
            },
            itemCount: UserService.to.addresses.length,
          ),
        ),

        ButtonWidget.tertiary(
          "增加收貨地址",
          onTap: () => controller.onAddAddress(),
        ).sliverToBoxAdapter()
        .sliverPaddingTop(AppSpace.page),

      ]
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyAddressesController>(
      init: MyAddressesController(),
      id: "my_addresses",
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: TextWidget.h4("我的收貨地址")
          ),
          body: SafeArea(
            child: _buildView().paddingAll(AppSpace.page),
          ),
        );
      },
    );
  }
}
