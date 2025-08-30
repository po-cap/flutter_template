import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:template/common/index.dart';
import 'package:template/pages/goods/item_detail/widgets/index.dart';

class ItemDetailController extends GetxController {
  ItemDetailController();


  List<ChatroomModel> chats = [];

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

  void onBuy() async {

    await ActionBottomSheet.barModel(
      OrderWiget(item: item)
    );
  }

  Future onChat() async {

    var room = await ChatroomRepo.to.getByUri(
      uri:'${UserService.to.profile.id}/${item.id}'
    );

    room ??= await ChatApi.getChatroom(
      '${UserService.to.profile.id}/${item.id}'
    );

    Get.toNamed(
      RouteNames.msgChatRoom, 
      arguments: {
        'chatroom': room
      }
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
