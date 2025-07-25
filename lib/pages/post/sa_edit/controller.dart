
import 'package:get/get.dart';
import 'package:template/common/index.dart';
import 'package:template/pages/index.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class SaEditController extends GetxController {
  SaEditController();

  /// 銷售屬性
  List<SalesOptionModel> options = [];


  /// 初始化
  _initData() {
    options.add(SalesOptionModel(
      name: '',
      values: []
    ));    
    update(["sa_edit"]);
  }

  /// 添加銷售屬性
  void onAddOption() {
    if(options[0].name.isNotEmpty) {
      options.add(SalesOptionModel(
        name: '',
        values: []
      ));
      update(["sa_edit"]);
    }
  }

  void onDeleteOption(int index) {
    if(options.length > 1) {
      options.removeAt(index);
      update(["sa_edit"]);
    }
  }

  /// 設置銷售屬性名稱
  void onSetName(int idx) {
    options[idx].setName();
    update(["sa_edit"]);
  }

  /// 為銷售屬性值，添加照片
  /// 這樣，對應的 sku 就會有照片了
  void onAddValuePhoto(
    SalesOptionModel option,
    int valueIdx
  ) async {

    final optionIdx = options.indexOf(option);
    if(optionIdx != 0) {
      Loading.toast("只有第一個規格的值能設定照片");
      return;
    }

    final result = await AssetPicker.pickAssets(
      Get.context!,
      pickerConfig: AssetPickerConfig(
        maxAssets: 1,
        requestType: RequestType.image
    ));                
    
    if (result != null) {
      Loading.show();
      try {
        final url = await PostApi.upload(result.first);
        option.values[valueIdx].url = url;
        update(["sa_edit"]);
      } finally {
        Loading.dismiss();
      }
    }
  }

  /// 刪除銷售屬性的屬性值
  void onDeleteSAValue(
    SalesOptionModel sa,
    SalesOptionValueModel value
  ) {
    sa.values.remove(value);
    update(["sa_edit"]);  
  }

  /// 添加銷售屬性的屬性值
  void onAddSAValue(
    SalesOptionModel sa,
    String value
  ) {
      sa.values.add(SalesOptionValueModel(
        name: value,
      ));
      update(["sa_edit"]);
  }

  /// 關閉銷售屬性編輯
  void onCloseEditor() {
    Get.back();
    options = [
      SalesOptionModel(
        name: '',
        values: []
      ),
    ];
    update(["sa_editor"]);
  }

  /// 前往銷售屬性編輯
  /// 前往銷售屬性編輯頁面前，必須先建立 sku
  void onToSKUEditPage() async {
    
    final List<SkuModel> skus = [];
    
    if(options.length == 1) {

      if(options[0].name.isEmpty) {
        Loading.toast("必須先設置規格");
        return;
      }

      if(options[0].values.length <= 1) {
        Loading.toast("必須先設置多個規格值");
        return;
      }

      skus.addAll(options[0].toSkus());
    }
    else {

      if(options[1].name.isEmpty) {
        Loading.toast("必須先設置規格");
        return;
      }

      if(options[0].values.length <= 1 || options[1].values.length <= 1) {
        Loading.toast("必須先設置多個規格值");
        return;
      }

      skus.addAll(options[0].toSkusWithSecondSA(options[1]));
    }

    final skuEditController = Get.find<PostItemController>();
    skuEditController.skus = skus;

    Sheet.page(
      child: const SkuEditPage()
    );
  }

  @override 
  void onInit() {
    super.onInit();
    _initData();
  }

 @override
  void onClose() {
    super.onClose();
    options.map((option) {
      option.dispose();
    });
  }
}
