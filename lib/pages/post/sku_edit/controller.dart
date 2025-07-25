import 'package:get/get.dart';
import 'package:template/common/index.dart';
import 'package:template/pages/index.dart';

class SkuEditController extends GetxController {
  SkuEditController();

  List<SkuModel> skus = [];

  _initData() {
    update(["sku_edit"]);
  }

  void onTap() {}

  void onSetSkuPrice(SkuModel sku) {
    Sheet.page(
      child: PriceEditPage(
        sku: sku,
      )
    );
  }

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  // @override
  // void onClose() {
  //   super.onClose();
  // }
}
