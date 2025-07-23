import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/common/index.dart';
import 'package:template/pages/index.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';



class PostItemController extends GetxController {
  PostItemController();

  /// 已選中的圖片
  List<AssetEntity> selectedAssets = [];

  /// 是否正在拖曳
  bool isDragging = false;

  /// 準備被交換位置的圖片的 ID
  String assetTargetId = "";

  // 内容输入控制器
  final contentController = TextEditingController();

  /// 銷售屬性
  List<SalesAttributeModel> salesAttributes = [
    SalesAttributeModel(
      name: '',
      values: []
    ),
  ];

  /// 庫存單元
  List<SkuModel> skus = [];

  /// 銷售屬性的輸入控制器
  List<TextEditingController> saControllers = [
    TextEditingController(),
  ];

  final priceController = TextEditingController();
  final quantityController = TextEditingController();

  void onSelectAssets() async {
    final result = await AssetPicker.pickAssets(
      Get.context!,
      pickerConfig: AssetPickerConfig(
        selectedAssets: selectedAssets,
        maxAssets: 9,
        requestType: RequestType.image,
      ),
    );

    selectedAssets = result ?? [];

    update(["post_item"]);
  }
  
  void onSetSkuPriceAndQuantity(SkuModel sku) {
    var price = double.parse(priceController.text);
    var quantity = int.parse(quantityController.text);
    sku.price = price;
    sku.availableStock = quantity;
    priceController.clear();
    quantityController.clear();
    Get.back();
  }

  void onSetSkus() {
    skus = [];

    // 雙重銷售屬性
    if(salesAttributes.length == 2) {
      for(int i = 0; i < salesAttributes[0].values.length; i++) {
        for(int j = 0; j < salesAttributes[1].values.length; j++) {
          var sku = SkuModel(
            id: 0, 
            name: "${salesAttributes[0].values[i].value},${salesAttributes[1].values[j].value}", 
            specs: {
              salesAttributes[0].name: salesAttributes[0].values[i].value,
              salesAttributes[1].name: salesAttributes[1].values[j].value
            }, 
            price: 0, 
            availableStock: 0
          );
          skus.add(sku);
        }
      }
    }
    // 單一銷售屬性 
    else {
      for(int i = 0; i < salesAttributes[0].values.length; i++) {
        var sku = SkuModel(
          id: 0, 
          name: salesAttributes[0].values[i].value, 
          specs: {
            salesAttributes[0].name: salesAttributes[0].values[i].value
          }, 
          price: 0, 
          availableStock: 0
        );
        skus.add(sku);
      }
    }

    showModalBottomSheet(
      context: Get.context!, 
      isScrollControlled: true,
      builder:(context) {
        return SkuItem();
      },
    );    
  }

  void onRemoveAsset(AssetEntity asset) {
    selectedAssets.remove(asset);
    update(["post_item"]);
  }

  void onSwapAssets(AssetEntity fromAsset, AssetEntity toAsset) {
    final fromIdx = selectedAssets.indexOf(fromAsset);
    final toIdx   = selectedAssets.indexOf(toAsset);

    final tmp = selectedAssets[fromIdx];
    selectedAssets[fromIdx] = selectedAssets[toIdx];
    selectedAssets[toIdx] = tmp;
    update(["post_item"]);
  }

  void onSetTargetId(String id) {
    assetTargetId = id;
    debugPrint('ID = $id');
    update(["post_item"]);
  }

  void onAddSA() {
    salesAttributes.add(SalesAttributeModel(
      name: '',
      values: []
    ));
    update(["sa_editor"]);
  }

  void onChangeSAName(int idx, String name) {
    salesAttributes[idx].name = name;
    update(["sa_editor"]);
  }

  void onEditSalesAttributes() {
    showModalBottomSheet(
      context: Get.context!, 
      isScrollControlled: true, // 允許控制高度
      builder:(context) {
        return const SAItem();
      },
    );
  }

  @override
  void onClose() {
    contentController.dispose();
    for (var controller in saControllers) {
      controller.dispose();
    }
    priceController.dispose();
    quantityController.dispose();
    super.onClose();
  }
}
