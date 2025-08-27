import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/common/index.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class AlbumWidget extends StatefulWidget {
  const AlbumWidget({
    super.key, 
    required this.onAssetsChanged
  });

  final Function(List<AssetEntity>) onAssetsChanged;

  @override
  State<AlbumWidget> createState() => _AlbumWidgetState();
}

class _AlbumWidgetState extends State<AlbumWidget> {
  
  List<AssetEntity> _assets = [];

  /// 準備被交換位置的圖片的 ID
  String _assetTargetId = '';
  
  Widget _buildAssetWithDeleteButton(
    AssetEntity asset, 
    double width
  ) {
    return Stack(
      children: [
        _buildAsset(asset, width),
        Positioned(
          top: 0,
          right: 0,
          child: _buildDeleteButton(asset, width),
        )
      ] 
    );
  }

  Widget _buildDeleteButton(
    AssetEntity asset, 
    double width
  ) {
    return InkWell(
      onTap: () => _onRemoveAsset(asset),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(AppRadius.image),
            bottomLeft: Radius.circular(AppRadius.image)
          ),
          color: Colors.white
        ),
        child: Icon(
          Icons.close,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildAsset(
    AssetEntity asset, 
    double width, {
    double opacity = 1.0
  }) {

    if(asset.type == AssetType.video) {
      return Stack(
        children: [
          Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.image),
            ),
            child: AssetEntityImage(
              asset,
              isOriginal: false,
              width: width,
              height: width,
              fit: BoxFit.cover,
              opacity: AlwaysStoppedAnimation(opacity),
            ),
          ),

          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                debugPrint('play video');
                Get.to(
                  () => Scaffold(
                    appBar: AppBar(),
                    body: VideoPlayerWidget(
                      initAsset: asset
                    )
                  )
                );    
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(AppRadius.image),
                    bottomLeft: Radius.circular(AppRadius.image)
                  ),
                  color: Colors.transparent
                ),
                child: Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 50
                ),
              ),
            ),
          )
      ]);
    }
    else {
      return Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.image),
        ),
        child: AssetEntityImage(
          asset,
          isOriginal: false,
          width: width,
          height: width,
          fit: BoxFit.cover,
          opacity: AlwaysStoppedAnimation(opacity),
        ),
      );
    }

  }

  Widget _buildAddBtn({
    required double width
  }) {
    return InkWell(
      onTap: _onSelectAssets,
      borderRadius: BorderRadius.circular(AppRadius.image),
      child: Ink(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.image),
            color: Get.theme.colorScheme.tertiaryContainer,
        ),
        width: width,
        height: width,
        child: Icon(
          Icons.add,
          size: 36,
          color: context.theme.colorScheme.onTertiaryContainer
        )                  
      )
    );
  }
  
  Widget _buildMainView() {
    return LayoutBuilder(
      builder:(context, constraints) {
        final width = (constraints.maxWidth - 10 * 2) / 3;

        return Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for(final asset in _assets)
              Draggable(
                data: asset,

                // 拖曳物件被放置時調用
                onDragCompleted: () {
                  setState(() {
                    _assetTargetId = "";
                  });
                },

                // 拖曳物件被拖曳時，顯示的視圖
                feedback: _buildAsset(asset, width),

                //拖曳物件被拖曳時，原本位置的視圖
                childWhenDragging: _buildAsset(asset, width, opacity: 0.5),

                child: DragTarget(
                  builder:(_, _, _) =>
                    _assetTargetId == asset.id ?
                    _buildAsset(asset, width, opacity: 0.8) : 
                    _buildAssetWithDeleteButton(asset, width),
                  
                  // 拖拽物件被放置在目標物件時，會先調用這個 Method
                  onWillAcceptWithDetails: (details) {
                    if(details.data == asset) {
                      return false;
                    }
                    setState(() {
                      _assetTargetId = asset.id;
                    });
                    return true;
                  },

                  // 拖拽物件離開目標物件時，會調用這個 Method
                  onLeave: (data) => setState(() => _assetTargetId = ""),
                
                  // 拖拽物件被放置在目標物件，並且接收了物件時，會調用這個 Method
                  onAcceptWithDetails: (details) {                    
                    final fromAsset = details.data as AssetEntity;
                    _onSwapAssets(fromAsset, asset);
                  }
                ),
              ),
            _buildAddBtn(width: width)
          ]
        );
      },
    );
  }

  void _onSelectAssets() async {
    final result = await AssetPicker.pickAssets(
      Get.context!,
      pickerConfig: AssetPickerConfig(
        
        // 选中的資源
        selectedAssets: _assets,

        // 通过 FilterOptionGroup 限制视频时长
        filterOptions: FilterOptionGroup(
          videoOption: FilterOption(
            durationConstraint: DurationConstraint(
              max: const Duration(seconds: 1000),
            ),
          ),
        ),
        
        // 设置为视频选择模式
        //requestType: RequestType.video,
        
        // 其他配置
        maxAssets: 9,

        // 选择类型
        specialPickerType: SpecialPickerType.wechatMoment,
        textDelegate: AssetPickerTextDelegate(),
        //specialItemBuilder: (context, path, length) {
        //  return Container(
        //    color: Colors.grey,
        //    child: const Center(child: Icon(Icons.camera_alt)),
        //  );
        //},
      ),
    );

    if(result == null) return;

    setState(() {
      _assets = result;
    });

    widget.onAssetsChanged(_assets);
  }

  void _onSwapAssets(
    AssetEntity fromAsset, 
    AssetEntity toAsset
  ) {
    setState(() {
      final fromIdx = _assets.indexOf(fromAsset);
      final toIdx   = _assets.indexOf(toAsset);

      final tmp = _assets[fromIdx];
      _assets[fromIdx] = _assets[toIdx];
      _assets[toIdx] = tmp;
    });
    
    widget.onAssetsChanged(_assets);
  }

  void _onRemoveAsset(
    AssetEntity asset
  ) {
    setState(() {
      _assets.remove(asset);
    });
    widget.onAssetsChanged(_assets);
  }

  @override
  Widget build(BuildContext context) {
    return _buildMainView();
  }
}