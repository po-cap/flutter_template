import 'package:get/get.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class PostItemController extends GetxController {
  PostItemController();

  /// 已選中的圖片
  List<AssetEntity> selectedAssets = [];

  _initData() {
    update(["post_item"]);
  }

  void onTap() {}

  void onSelectAssets() async {
    final result = await AssetPicker.pickAssets(
      Get.context!,
      pickerConfig: const AssetPickerConfig(
        maxAssets: 9,
        requestType: RequestType.image,
      ),
    );

    selectedAssets = result ?? [];

    update(["post_item"]);
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
