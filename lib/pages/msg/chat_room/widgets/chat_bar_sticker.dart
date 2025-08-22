import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:template/common/index.dart';

/// 表情组件
class ChatBarStickerWidget extends StatefulWidget {
  const ChatBarStickerWidget({
    super.key,
    required this.emojiList,
    this.customFaceModelList,
    this.onEmojiTap,
    this.onFaceTap,
  });

  /// 符号表情列表
  final List<EmojiModel> emojiList;

  /// 图片表情列表
  final List<CustomFaceModel>? customFaceModelList;

  /// 标签符号被选中
  final Function(String emojiString)? onEmojiTap;

  /// 表情图片被选中
  final Function(int faceId, String faceFileName)? onFaceTap;

  @override
  State<ChatBarStickerWidget> createState() => _ChatBarStickerWidgetState();
}

class _ChatBarStickerWidgetState extends State<ChatBarStickerWidget> {
  // 分页管理
  final PageController _pageController = PageController();

  // 当前选中index
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      _currentIndex = _pageController.page!.toInt();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // 导航栏切换
  void onIndexChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  // 表情图片
  Widget _buildAssetImage(int faceId, String faceFileName) {
    return ImageWidget.img(
      "${Constants.customFacePath}$faceId/$faceFileName",
      width: 32,
      height: 32,
    );
  }

  // 图片表情列表
  Widget _buildFaceList(CustomFaceModel faceData) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        // 横轴上的组件数量
        crossAxisCount: 7,
        // 沿主轴的组件之间的逻辑像素数。
        mainAxisSpacing: 10,
        // 沿横轴的组件之间的逻辑像素数。
        crossAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        var faceFileName = faceData.picList![index];
        return Container(
          // color: Colors.grey[100],
          child: _buildAssetImage(faceData.faceId!, faceFileName),
        ).onTap(widget.onFaceTap == null
            ? null
            : () => widget.onFaceTap!(faceData.faceId!, faceFileName));
      },
      itemCount: faceData.picList?.length ?? 0,
    );
  }

  // Unicode 表情列表
  Widget _buildEmojiList() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        // 横轴上的组件数量
        crossAxisCount: 7,
        // 沿主轴的组件之间的逻辑像素数。
        mainAxisSpacing: 10,
        // 沿横轴的组件之间的逻辑像素数。
        crossAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        var emoji = widget.emojiList[index];

        // unicode 转 字符串
        var emojiString = String.fromCharCode(emoji.unicode!);

        return Container(
          child: TextWidget.body(
            emojiString,
            size: 32,
          ).center(),
        ).onTap(widget.onEmojiTap == null
            ? null
            : () => widget.onEmojiTap!(emojiString));
      },
      itemCount: widget.emojiList.length,
    );
  }

  // 导航切换
  Widget _buildTabBar() {
    var ws = <Widget>[];

    // 符号表情
    var emoji = widget.emojiList.first;
    var emojiString = String.fromCharCode(emoji.unicode!);
    ws.add(
      TextWidget.body(
        emojiString,
        size: 32,
      )
          .center()
          .tightSize(40)
          .backgroundColor(
              _currentIndex == 0 ? Colors.white : Colors.transparent)
          .paddingRight(5)
          .onTap(() => _pageController.jumpToPage(0)),
    );

    // 图片表情
    if (widget.customFaceModelList != null) {
      for (var i = 0; i < widget.customFaceModelList!.length; i++) {
        var item = widget.customFaceModelList![i];
        ws.add(
          _buildAssetImage(item.faceId!, item.menuPic!)
              .center()
              .tightSize(40)
              .backgroundColor(
                  _currentIndex == (i + 1) ? Colors.white : Colors.transparent)
              .paddingRight(5)
              .onTap(() => _pageController.jumpToPage(i + 1)),
        );
      }
    }

    return ws.toRow().backgroundColor(Colors.grey[100]!).height(40);
  }

  // 主视图
  Widget _buildView() {
    return <Widget>[
      // 工具栏
      if (widget.customFaceModelList != null) _buildTabBar(),

      // 表情列表
      PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: onIndexChanged,
        children: [
          // 符号表情列表
          _buildEmojiList(),

          // 图片表情列表
          for (var item in widget.customFaceModelList ?? [])
            _buildFaceList(item),
        ],
      ).expanded(),
    ].toColumn();
  }

  @override
  Widget build(BuildContext context) {
    return _buildView();
  }
}
