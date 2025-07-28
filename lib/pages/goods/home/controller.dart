import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:template/common/index.dart';

class HomeController extends GetxController {
  HomeController();

  /// 商品列表
  List<ItemModel> newItems = [];

  /// 刷新控制器
  final RefreshController refreshController = RefreshController(
    initialRefresh: false,
  );

  // 上一次加载的最后一条数据
  int? _lastItemId;

  // 页尺寸
  final int _limit = 5;

  /// Banner 当前位置
  int bannerCurrentIndex = 0;

  /// Banner 数据
  List<KeyValueModel> bannerItems = [];

  _initData() async {
    
    // banner
    bannerItems = await SystemApi.banners();
    
    // 新商品
    newItems = await ProductApi.getByUserId(
      userId: 1949104296763199488,
      limit: _limit
    );
    if(newItems.isNotEmpty){
      _lastItemId = newItems.last.id;
    }
    
    update(["home"]);
  }

  /// 拉取数据
  /// isRefresh 是否是刷新
  Future<bool> _loadNewItems(
    bool isRefresh
  ) async {
    
    /// 拉取数据
    var result = await ProductApi.getByUserId(
      userId: 1949104296763199488,
      limit: _limit,
      lastId: _lastItemId
    );

    /// 下拉刷新
    if(isRefresh){
      _lastItemId = null;
      newItems.clear();
    }

    /// 有数据
    if(result.isNotEmpty){
      _lastItemId = result.last.id;
    }

    newItems.addAll(result);

    /// 是否空
    return result.isEmpty;
  }

  void onLoading() async {
    if(newItems.isNotEmpty){
      try {
        // x阿曲數據是否為空
        final isEmpty = await _loadNewItems(false);

        if(isEmpty) {
          // 設置無數據
          refreshController.loadNoData();
        } else {
          // 加載完成
          refreshController.loadComplete();
        }

      } catch (e) {
        // 加載失敗
        refreshController.loadFailed();
      } 

    }
    else {
      // 設置無數據
      refreshController.loadNoData();
    }

    update(["home_new_items"]);
  }

  // 下拉刷新
  void onRefresh() async {
    try {
      await _loadNewItems(true);
      refreshController.refreshCompleted();
    } catch (error) {
      refreshController.refreshFailed();
    }
    update(["home_new_items"]);
  }

  // 导航点击事件
  void onAppBarTap() {}

  // Banner 切换事件
  void onChangeBanner(int index, /*CarouselPageChangedReason*/ reason) {
    bannerCurrentIndex = index;
    update(["home_banner"]);
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

  @override
  void onClose() {
    super.onClose();
    // 释放刷新控制器
    refreshController.dispose();
  }
}
