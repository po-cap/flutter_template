import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/common/index.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class SaEditController extends GetxController {
  SaEditController();

  /// 銷售屬性
  List<SalesAttributeModel> salesAttributes = [];

  /// 銷售屬性控制器
  List<TextEditingController> textControllers = [];

  /// 初始化
  _initData() {
    salesAttributes.add(SalesAttributeModel(
      name: '',
      values: []
    ));

    textControllers.add(TextEditingController());
    
    update(["sa_edit"]);
  }

  /// 添加銷售屬性
  void onAddSA() {
    salesAttributes.add(SalesAttributeModel(
      name: '',
      values: []
    ));
    textControllers.add(TextEditingController());
    update(["sa_edit"]);
  }

  void onDeleteSA(int index) {
    salesAttributes.removeAt(index);
    textControllers.removeAt(index);
    update(["sa_edit"]);
  }

  /// 設置銷售屬性名稱
  void onSetSAName(String name, int idx) {
    salesAttributes[idx].name = name;
    textControllers[idx].clear();
    update(["sa_edit"]);
  }

  /// 為銷售屬性值，添加照片
  /// 這樣，對應的 sku 就會有照片了
  void onAddValuePhoto(
    SalesAttributeValueModel value
  ) async {
    final result = await AssetPicker.pickAssets(
      Get.context!,
      pickerConfig: AssetPickerConfig(
        maxAssets: 1,
        requestType: RequestType.image
    ));                
    
    if (result != null) {
      value.asset = result.first;
      update(["sa_edit"]);
    }
  }

  /// 刪除銷售屬性的屬性值
  void onDeleteSAValue(
    SalesAttributeModel sa,
    SalesAttributeValueModel value
  ) {
    sa.values.remove(value);
    update(["sa_edit"]);  
  }

  /// 添加銷售屬性的屬性值
  void onAddSAValue(
    SalesAttributeModel sa,
    String value
  ) {
    sa.values.add(SalesAttributeValueModel(
      value: value,
      asset: null
    ));
    update(["sa_edit"]);
  }

  @override 
  void onInit() {
    super.onInit();
    _initData();
  }

 @override
  void onClose() {
    super.onClose();
    textControllers.map((e) {
      e.dispose();
    });
  }
}
