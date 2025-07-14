import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:template/common/index.dart';
import 'package:template/pages/index.dart';



class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const _MainViewGetX();
  }
}

class _MainViewGetX extends GetView<MainController> {
  const _MainViewGetX();

  // 主视图
  Widget _buildView(BuildContext context) {
    return PopScope(
      // 允许返回
      canPop: false,

      // 防止连续点击两次退出
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        // 如果返回，则不执行退出请求
        if (didPop) {
          return;
        }

        // 退出请求
        if (controller.closeOnConfirm(context)) {
          SystemNavigator.pop(); // 系统级别导航栈 退出程序
        }
      },

      child: Scaffold(
        extendBody: true,
        resizeToAvoidBottomInset: false,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.toNamed(RouteNames.postPostItem);
          },
          child: Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        // 导航栏
        bottomNavigationBar: GetBuilder<MainController>(
          id: 'navigation',
          builder: (controller) {
            return BuildNavigation(
              currentIndex: controller.currentIndex,
              items: [
                NavigationItemModel(
                  label: LocaleKeys.tabBarHome.tr,
                  icon: AssetsSvgs.navHomeSvg,
                ),
                NavigationItemModel(
                  label: LocaleKeys.tabBarCart.tr,
                  icon: AssetsSvgs.navCartSvg,
                  count: 3,
                ),
                NavigationItemModel(
                  label: LocaleKeys.tabBarMessage.tr,
                  icon: AssetsSvgs.navMessageSvg,
                  count: 9,
                ),
                NavigationItemModel(
                  label: LocaleKeys.tabBarProfile.tr,
                  icon: AssetsSvgs.navProfileSvg,
                ),
              ],
              onTap: controller.onJumpToPage, // 切换tab事件
            );
          },
        ),
        // 内容页
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: controller.pageController,
          onPageChanged: controller.onIndexChanged,
          children: const [
            // 加入空页面占位
            HomePage(),
            CartIndexPage(),
            MsgIndexPage(),
            MyIndexPage(),
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainController>(
      id: "main",
      builder: (_) {
        return _buildView(context);
      }
    );
  }
}
