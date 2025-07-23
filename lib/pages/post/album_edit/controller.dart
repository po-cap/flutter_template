import 'package:get/get.dart';
import 'package:template/common/index.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class AlbumEditController extends GetxController {
  AlbumEditController();

  /// 选中的图片
  List<AssetEntity> selectedAssets = [];

  /// 是否正在拖拽
  bool isDragging = false;

  /// 準備被交換位置的圖片的 ID
  String assetTargetId = '';

  _initData() {
    update(["album_edit"]);
  }

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

    update(["album_edit"]);
  }

  void onSwapAssets(
    AssetEntity fromAsset, 
    AssetEntity toAsset
  ) {
    final fromIdx = selectedAssets.indexOf(fromAsset);
    final toIdx   = selectedAssets.indexOf(toAsset);

    final tmp = selectedAssets[fromIdx];
    selectedAssets[fromIdx] = selectedAssets[toIdx];
    selectedAssets[toIdx] = tmp;
    update(["album_edit"]);
  }

  void onSetTargetId(String id) {
    assetTargetId = id;
    update(["album_edit"]);
  }

  void onRemoveAsset(
    AssetEntity asset
  ) {
    selectedAssets.remove(asset);
    update(["album_edit"]);
  }

  void onOpenGallery(
    AssetEntity asset
  ) {
    Get.to(
      GalleryWidget.assets(
        initialIndex: selectedAssets.indexOf(asset), 
        assets: selectedAssets
      )
    );
  }

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

}
