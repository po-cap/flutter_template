import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'index.dart';

class LoginWithLinePage extends GetView<LoginWithLineController> {
  const LoginWithLinePage({super.key});

  // 主视图
  Widget _buildView() {
    return controller.webViewController == null ? 
      SizedBox() : 
      WebViewWidget(
        controller: controller.webViewController!,
      );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginWithLineController>(
      init: LoginWithLineController(),
      id: "login_with_line",
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
          ),
          body: SafeArea(
            child: _buildView(),
          ),
        );
      },
    );
  }
}
