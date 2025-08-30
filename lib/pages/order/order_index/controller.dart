import 'package:get/get.dart';
import 'package:template/common/index.dart';

class OrderIndexController extends GetxController {
  OrderIndexController();

  ItemModel item = Get.arguments["item"];

  late List<SkuModel> skus;


  _initData() async {
    skus = await ProductApi.getSkus(
      itemId: item.id
    );
    update(["order_index"]);
  }

  void onTap() {}


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
