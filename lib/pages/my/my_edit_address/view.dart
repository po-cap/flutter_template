import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/common/index.dart';



import 'index.dart';
import 'widgets/index.dart';

class MyEditAddressPage extends GetView<MyEditAddressController> {

  const MyEditAddressPage({
    super.key,
  });

  // 主视图
  Widget _buildView() {

    if(controller.selectedCity == null || controller.selectedDistrict == null) {
      return CircularProgressIndicator().center();
    }

    if(controller.address.type == 'home') {
      return TabDeliveryView(
        receiverController: controller.receiverController, 
        phoneController: controller.phoneController, 
        streetController: controller.streetController, 
        onCityChanged: controller.onSelectCity, 
        onDistrictChanged: controller.onSelectDistrict,
        cities: controller.cities,
        selectedCity: controller.selectedCity,
        selectedDistrict: controller.selectedDistrict,
        onSetFirst: controller.onSetDefaultAddress,
        isFirst: controller.isFirst,
      );
    }

    if(controller.address.type == 'seven') {
      return TabSevenView(
        receiverController: controller.receiverController, 
        phoneController: controller.phoneController, 
        streetController: controller.streetController, 
        storeController: controller.storeController, 
        onCityChanged: controller.onSelectCity, 
        onDistrictChanged: controller.onSelectDistrict,
        cities: controller.cities,
        selectedCity: controller.selectedCity,
        selectedDistrict: controller.selectedDistrict,
        onSetFirst: controller.onSetDefaultAddress,
        isFirst: controller.isFirst,
      );
    }

    return TabFamilyView(
      receiverController: controller.receiverController, 
      phoneController: controller.phoneController, 
      streetController: controller.streetController, 
      storeController: controller.storeController, 
      onCityChanged: controller.onSelectCity, 
      onDistrictChanged: controller.onSelectDistrict,        
        cities: controller.cities,
        selectedCity: controller.selectedCity,
        selectedDistrict: controller.selectedDistrict,
        onSetFirst: controller.onSetDefaultAddress,
        isFirst: controller.isFirst,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyEditAddressController>(
      init: MyEditAddressController(
        address: Get.arguments['address'],
      ),
      id: "my_edit_address",
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: <Widget>[
              if(controller.address.type == 'home')
                IconWidget.svg(
                  AssetsSvgs.pHomeSvg,
                  size: 36,
                ).paddingRight(AppSpace.listRow),
              if(controller.address.type == 'family')
                IconWidget.svg(
                  AssetsSvgs.familyMartSvg,
                  size: 36,
                ).paddingRight(AppSpace.listRow),
              if(controller.address.type == 'seven')
                IconWidget.svg(
                  AssetsSvgs.sevenElevenSvg,
                  size: 36,
                ).paddingRight(AppSpace.listRow),

              TextWidget.h4("編輯收貨地址"),
            ].toRow(
              mainAxisSize: MainAxisSize.min,
            ),
            actions: [
              ButtonWidget.tertiary(
                "刪除",
                onTap: controller.onDeleteAddress,
              ).center().paddingHorizontal(AppSpace.page * 2)
            ],
          ),
          body: SafeArea(
            child: _buildView().paddingAll(AppSpace.page * 2),
          ),
        );
      },
    );
  }
}
