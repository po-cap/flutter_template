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

    final priceEditController = Get.find<PriceEditController>();
    priceEditController.priceController.text = sku.price.toString();
    priceEditController.quantityController.text = sku.quantity.toString();

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
