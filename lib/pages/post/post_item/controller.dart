import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/common/index.dart';
import 'package:template/pages/index.dart';



class PostItemController extends GetxController {
  PostItemController();

  // 内容输入控制器
  final contentController = TextEditingController();

  /// 庫存單元
  List<SkuModel> skus = [];

  /// 銷售屬性名稱
  String get skuName {

    if(skus.isEmpty) {
      return "非必填，設置多個顏色、尺寸等";
    } 
    else {
      final name = skus.map((e) => e.name).join(",");
      if(name.isEmpty) {
        return "非必填，設置多個顏色、尺寸等";
      }
      else {
        return name;
      }
    }
  }

  _initData() {
    skus.add(
      SkuModel(
        id: 0, 
        name: "", 
        specs: {}, 
        price: 0, 
        quantity: 0
      )
    );
    update(["post_item"]);
  }

  @override
  void onInit() {
    super.onInit();
    _initData();
  }

  /// 價格
  String get price {
    
    if(skus.isEmpty) {
      return "NTD\$ 0";
    } 
    else if(skus.length == 1) {
      return "NTD\$ ${skus[0].price}";
    }
    else {
      final sortedPrices = skus.map((e) => e.price).toList();
      sortedPrices.sort();
      if(sortedPrices.length == 1) {
        return "NTD\$ ${sortedPrices.first}";
      }
      else {
        return "NTD\$ ${sortedPrices.first} ~ ${sortedPrices.last}"; 
      }
    }
  }

  void onConfirm() {

    Loading.show();
    try{
      PostApi.addItem(
        description: contentController.text,
        album: Get.find<AlbumController>().album,
        skus: skus
      );
      Get.back();
    } finally {
      Loading.dismiss();
    }
  }

  void onEditOptions() async{
    await showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      enableDrag: false,
      builder:(context) {
        return SaEditPage();
      },
    );
    update(["post_item"]);
  }

  void onEditPrice() async {
    if(skus.length == 1) {
      await Sheet.page(
        child: PriceEditPage(
          sku: skus[0],
        )
      );
    }
    else {
      await Sheet.page(
        child: SkuEditPage()
      );
    }
    update(["post_item"]);
  }

  @override
  void onClose() {
    super.onClose();
    contentController.dispose();
  }
}
