import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:template/common/index.dart';

class ItemDetailController extends GetxController {
  ItemDetailController();

  /// 商品(鏈結 ID)
  ItemModel item = Get.arguments['item'];

  // 主界面 刷新控制器
  final refreshController = RefreshController(
    initialRefresh: false,
  );

  _initData() {
    update(["item_detail"]);
  }

  void onTap() {}

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
