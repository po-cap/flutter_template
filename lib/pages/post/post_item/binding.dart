import 'package:get/get.dart';
import 'package:template/pages/index.dart';

class PostItemBinding implements Bindings {
  
  @override
  void dependencies() {
    Get.lazyPut<PostItemController>(() => PostItemController()); 
    Get.lazyPut<AlbumEditController>(() => AlbumEditController());   
    Get.lazyPut<SaEditController>(() => SaEditController());
    Get.lazyPut<SkuEditController>(() => SkuEditController());
    Get.lazyPut<PriceEditController>(() => PriceEditController());
  }

}