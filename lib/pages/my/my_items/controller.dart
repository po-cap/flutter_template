import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:template/common/index.dart';


class MyItemsController extends GetxController 
  with GetSingleTickerProviderStateMixin {
  MyItemsController();

  /// 滚动控制器
  ScrollController scrollController = ScrollController();

  // tab 控制器
  late TabController tabController;

  // tab 控制器
  int tabIndex = 0;

  /// 刷新控制器
  final RefreshController refreshController = RefreshController(
    initialRefresh: false,
  );

  /// 商品列表
  List<ItemModel> items = [];

  // 上一次加载的最后一条数据
  int? _lastItemId;

  // 页尺寸
  final int _itemLimit = 20;


  Future<bool> _onLoadItems(bool isRefresh) async {

    // 是否是刷新
    if(isRefresh) {
      _lastItemId = null;
      items.clear();
    }

    // 拉取数据    
    final result = await ProductApi.getByUserId(
      userId: UserService.to.profile.id!,
      lastId: _lastItemId,
      limit: _itemLimit
    );

    // 如果有數據，設置上一次加载的最後一條數據
    if(result.isNotEmpty){
      _lastItemId = result.last.id;
    }

    // 添加
    items.addAll(result);

    // 是否空
    return items.isEmpty;
  }

  _initData() async {
    await _onLoadItems(false);
    update(["my_sold_items"]);
  }

  // 切换 tab
  void onTapBarTap(int index) {
    tabIndex = index;
    tabController.animateTo(index);
    update(["my_items"]);
  }

  Future onLoadingItems() async {
    try {
      // x阿曲數據是否為空
      final isEmpty = await _onLoadItems(false);

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

    update(["profile_tab"]);
  }

  void onRefreshItems() async {
    try {
      await _onLoadItems(true);
      refreshController.refreshCompleted();
    } catch (error) {
      refreshController.refreshFailed();
    }
    update(["home_new_items"]);
  }

  @override
  void onInit() {
    super.onInit();

    // 初始化 tab 控制器
    tabController = TabController(length: 2, vsync: this);

    // 监听 tab 切换
    tabController.addListener(() {
      tabIndex = tabController.index;
      update(['my_items']);
    });
  }

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  @override
  void onClose() {
    super.onClose();
    tabController.dispose();
    refreshController.dispose();
    scrollController.dispose();
  }
}
