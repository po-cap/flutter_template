import 'package:flutter/material.dart';
import 'package:template/common/index.dart';

class SalesOptionModel {
  
  /// 销售属性名稱
  String name;
  
  /// 销售属性值
  List<SalesOptionValueModel> values;
  
  /// 輸入控制器
  final textController = TextEditingController();
  
  SalesOptionModel({
    required this.name,
    required this.values,
  });

  void dispose() {
    textController.dispose();
  }

}

extension SAValueExtension on SalesOptionModel {

  /// 設置銷售屬性名稱
  void setName() {
    name = textController.text;
    textController.clear();
  }

  /// 添加銷售屬性值
  void addValue() {
    
    if(!values.map((e) => e.name).contains(textController.text)) {
      values.add(
        SalesOptionValueModel(
          name: textController.text
        )
      );
      textController.clear();
    }
    else {
      Loading.toast("規格已存在");
    }
  }

  /// 將銷售屬性轉成 sku
  List<SkuModel> toSkus() {
    List<SkuModel> skus = [];
    for(var value in values) {
      var sku = SkuModel(
        id: 0, 
        name: value.name, 
        specs: {
          name: value.name
        }, 
        photo: value.url,
        price: 0, 
        quantity: 0
      );
      skus.add(sku);
    }
    return skus;
  }

  /// 將銷售屬性轉成 sku
  List<SkuModel> toSkusWithSecondSA(SalesOptionModel sa) {

    List<SkuModel> skus = [];
    for(var v1 in values) {
      for(var v2 in sa.values) {
        var sku = SkuModel(
          id: 0, 
          name: "${v1.name},${v2.name}", 
          specs: {
            sa.name: v1.name,
            name: v2.name
          }, 
          photo: v1.url ?? v2.url,
          price: 0, 
          quantity: 0
        );
        skus.add(sku);
      }
    }
    return skus;
  }
}
