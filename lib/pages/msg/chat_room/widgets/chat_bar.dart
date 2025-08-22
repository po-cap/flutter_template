import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/common/index.dart';

import 'chat_bar_sticker.dart';

class ChatBarWidget extends StatefulWidget {
  const ChatBarWidget({
    super.key, 
    this.chatTextEditingController, 
    this.onTextSend, 
    this.onVideoSend,
    this.onSoundRecordBefore, 
    this.onImageSend, 
    this.onSoundSend, 
    this.onFaceSend,
    this.isClose
  });

  /// 聊天输入框控制器
  final TextEditingController? chatTextEditingController;

  /// 发送文字
  final Function(String text)? onTextSend;

  /// 录音前
  final Function()? onSoundRecordBefore;

  /// 发送图片
  final Function()? onImageSend;

  /// 发送视频
  final Function()? onVideoSend;

  /// 发送语音
  final Function(String path, int seconds)? onSoundSend;

  /// 发送表情
  final Function(int index, String data)? onFaceSend;

  /// 关闭
  final bool? isClose;


  @override
  State<ChatBarWidget> createState() => _ChatBarWidgetState();
}

class _ChatBarWidgetState extends State<ChatBarWidget> {

  // 子栏高度
  final double _keyboardHeight = 200;

  // 显示表情栏
  bool _isShowEmoji = false;

  // 显示更多栏
  bool _isShowMore = false;

  // 是否是输入框
  bool _isTextEdit = false;

  // 输入框焦点
  final FocusNode _focusNode = FocusNode();

  // 输入框控制器
  late TextEditingController _chatTextEditingController;

  // 符号表情列表
  List<EmojiModel> emojiList = [];

  // 图片表情列表
  List<CustomFaceModel> customFaceModelList = [];

  // 准备数据
  Future<void> _initData() async {
    // 符号表情
    for (var it in textEmojiData) {
      emojiList.add(EmojiModel.fromJson(it));
    }

    // 图片表情
    customFaceModelList.add(CustomFaceModel(
      faceId: 4350,
      menuPic: "menu@2x.png",
      picList: face4350,
    ));
    customFaceModelList.add(CustomFaceModel(
      faceId: 4351,
      menuPic: "menu@2x.png",
      picList: face4351,
    ));
    customFaceModelList.add(CustomFaceModel(
      faceId: 4352,
      menuPic: "menu@2x.png",
      picList: face4352,
    ));
  }



  @override
  void initState() {
    super.initState();
    _chatTextEditingController =
        widget.chatTextEditingController ?? TextEditingController();

    _focusNode.addListener(_unfocus);

    // 准备标签数据
    _initData();
  }

  @override
  void dispose() {
    _focusNode.removeListener(_unfocus);
    _focusNode.dispose();
    super.dispose();
  }

  void _unfocus() {
    if (!_focusNode.hasFocus) {
      setState(() {
        _isTextEdit = false;
      });
    }
  }
  
  // 底部弹出评论栏
  Widget _buildBar() {
    List<Widget> ws = [];

    // 文字输入
    ws.add(
      TextField(
        controller: _chatTextEditingController,
        focusNode: _focusNode,
        maxLines: 5,
        minLines: 1,
        //textInputAction: TextInputAction.done,
        decoration: const InputDecoration(
          hintText: "想說什麼...?",
          border: InputBorder.none,
        ),
        onTap: () {
          setState(() {
            _isShowEmoji = false;
            _isShowMore = false;
          });
        },
        onChanged: (value) {
          setState(() {
            _isTextEdit = value.isNotEmpty;
          });
        },
        onSubmitted: (value) {
          _onSendText();
        },
      ).paddingRight(AppSpace.iconTextSmail,).expanded()
    );

    // 表情按钮
    ws.add(
      IconWidget.svg(
        _isShowEmoji == true ? AssetsSvgs.stickerSvg : AssetsSvgs.keyboardSvg,
        size: 32,
        color: Get.theme.colorScheme.outline,
        onTap: _onToggleEmoji,
      )
      .paddingRight(AppSpace.iconTextSmail)
    );

    // 更多按钮
    if(_isTextEdit == false) {
      ws.add(
        IconWidget.svg(
          AssetsSvgs.add2Svg,
          size: 32,
          color: Get.theme.colorScheme.outline,
          onTap: _onToggleMore,
        )
      );
    }
    else {
      ws.add(
        IconWidget.svg(
          AssetsSvgs.sendSvg,
          size: 32,
          color: Get.theme.colorScheme.outline,
          onTap: _onSendText,
        )
      );


      //ws.add(
      //  ButtonWidget.primary(
      //    "發送",
      //    onTap: _onSendText,
      //  ).constrained(
      //    height: 32,
      //    width: 60,
      //  )
      //);
    }

    return ws.toRow(crossAxisAlignment: CrossAxisAlignment.center);
  }

  // 表情列表
  Widget _buildEmojiList() {
    return ChatBarStickerWidget(
      // 符号表情
      emojiList: emojiList,
      onEmojiTap: (emoji) {
        // 追加输入框文字
        _chatTextEditingController.text += emoji;
        // 将光标设置为文本的末尾
        _chatTextEditingController.selection = TextSelection.fromPosition(
            TextPosition(offset: _chatTextEditingController.text.length));
        // 设置正在编辑
        setState(() {
          _isTextEdit = true;
        });
      },
      // 图片表情
      customFaceModelList: customFaceModelList,
      // 图片表情点击
      onFaceTap: widget.onFaceSend,
    ).height(_keyboardHeight).paddingTop(AppSpace.listRow);
  }


  // 更多 item
  Widget _buildMoreItem(
    IconData icon, 
    String text, 
    GestureTapCallback? onTap
  ) {
    return Column(
      children: [
        IconWidget.icon(
          icon,
          size: 56,
        ),
        Text(text),
      ],
    ).onTap(() {
      onClose();
      onTap?.call();
    });
  }

  // 更多列表
  Widget _buildMoreList() {
    return SizedBox(
      height: _keyboardHeight,
      child: Wrap(
        spacing: 30,
        runSpacing: 30,
        children: [
          // 1 图片
          _buildMoreItem(
            Icons.image,
            "照片",
            widget.onImageSend,
          ),
          // 2 视频
          _buildMoreItem(
            Icons.video_camera_back,
            "影片",
            widget.onVideoSend,
          ),
        ],
      ),
    ).paddingTop(AppSpace.listRow)
    .paddingHorizontal(AppSpace.page * 1.2);
  }

  Widget _mainView() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      padding: MediaQuery.of(context).viewInsets,
      color: Get.theme.colorScheme.surface,
      child: <Widget>[
        _buildBar(),
        if (_isShowEmoji) _buildEmojiList(),
        if (_isShowMore) _buildMoreList(),
      ]
      .toColumn(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
      )
      .padding(all: AppSpace.page)
      .safeArea(),
    );
  }


  @override
  Widget build(BuildContext context) {
    return _mainView();
  }

  // 关闭
  void onClose() {
    _focusNode.unfocus();
    _isShowEmoji = false;
    _isShowMore = false;
  }


  // 切换表情
  void _onToggleEmoji() {
    setState(() {
      _isShowEmoji = !_isShowEmoji;
      _isShowMore = false;
    });
    if (_isShowEmoji) {
      _focusNode.unfocus();
    } else {
      _focusNode.requestFocus();
    }
  }

  // 切换更多
  void _onToggleMore() {
    setState(() {
      _isShowEmoji = false;
      _isShowMore = !_isShowMore;
    });
    if (_isShowMore) {
      _focusNode.unfocus();
    } else {
      _focusNode.requestFocus();
    }
  }

  // 发送文字
  Future _onSendText() async {
    await widget.onTextSend?.call(_chatTextEditingController.text);
    _chatTextEditingController.text = "";
    setState(() {
      _isTextEdit = false;
    });
  }


}