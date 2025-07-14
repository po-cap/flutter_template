import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/common/index.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'index.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  // 表单页
  Widget _buildForm(BuildContext context) {
    return Form(
      key: controller.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: <Widget> [

        InputFormFieldWidget(
          controller: controller.emailController,
          labelText: LocaleKeys.loginBackFieldEmail.tr,
          prefix: const Icon(Icons.email),
        ).paddingBottom(AppSpace.listRow),

        InputFormFieldWidget(
          controller: controller.passwordController,
          labelText: LocaleKeys.loginBackFieldPassword.tr,
          prefix: const Icon(Icons.password),
          obscureText: true,
        ).paddingBottom(AppSpace.listRow * 2),

        ButtonWidget.primary(
          LocaleKeys.loginSignIn.tr,
          onTap: controller.onSignIn,
        ).width(double.infinity).paddingBottom(30),

        TextWidget.label(
          LocaleKeys.loginOrText.tr
        ).paddingBottom(15),

        ButtonWidget.ghost(
          LocaleKeys.loginWithLine.tr,
          icon: IconWidget.svg(AssetsSvgs.lineSvg),
          onTap: controller.onSignInWithLine,
        ).width(double.infinity),

      ].toColumn()
    ).paddingAll(AppSpace.card);
  }

  Widget _buildSigninPage(BuildContext context) {
    return SingleChildScrollView(
      child: <Widget> [

       // 头部标题
        PageTitleWidget(
          title: LocaleKeys.loginBackTitle.tr,
          desc: LocaleKeys.loginBackDesc.tr,
        ).paddingTop(50),

        _buildForm(context),
      ]
      .toColumn()
      .paddingHorizontal(AppSpace.page),
    );    
  }

  // 主视图
  Widget _buildView(BuildContext context) {
    return _buildSigninPage(context);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      init: LoginController(),
      id: "login",
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text("login")),
          body: SafeArea(
            child: _buildView(context),
          ),
        );
      },
    );
  }
}
