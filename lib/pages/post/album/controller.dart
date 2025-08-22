import 'package:get/get.dart';
import 'package:template/common/index.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class AlbumController extends GetxController {
  AlbumController();
  
  List<String> album = [];

  /// 是否正在拖拽
  bool isDragging = false;

  /// 準備被交換位置的圖片的 ID
  String targetUrl = '';
  
  _initData() {
    update(["album"]);
  }

  void onSetTarget(String url) {
    targetUrl = url;
    update(["album"]);
  }

  void onSwapAssets(
    String fromPhoto, 
    String toPhoto
  ) {
    final fromIdx = album.indexOf(fromPhoto);
    final toIdx   = album.indexOf(toPhoto);

    final tmp = album[fromIdx];
    album[fromIdx] = album[toIdx];
    album[toIdx] = tmp;
    update(["album"]);
  }

  void onSelectAssets() async {
    final result = await AssetPicker.pickAssets(
      Get.context!,
      pickerConfig: AssetPickerConfig(
        maxAssets: 9 - album.length,
        requestType: RequestType.image,
      ),
    );

    Loading.show();
    try {
      for(final asset in result ?? []) {
        final url = await PostApi.uploadImage(asset);
        album.add(url);
      }
    } finally {
      Loading.dismiss();
    }

    update(["album"]);
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
