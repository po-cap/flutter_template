
import 'package:get/get.dart';
import 'package:template/common/index.dart';
import 'package:template/pages/index.dart';

class RoutePages {
  // 列表
  static List<GetPage> list = [
    GetPage(
      name: RouteNames.systemSplash,
      page: () => const SplashPage(),
    ),
  ];
}
