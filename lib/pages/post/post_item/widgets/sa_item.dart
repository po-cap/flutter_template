import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/common/index.dart';
import 'package:template/pages/index.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';


class SAItem extends StatelessWidget {
  const SAItem({super.key});



  Widget _buildSA(
    BuildContext ctx,
    SalesAttributeModel sa,
    TextEditingController txtcontroller
  ) {
    return GetBuilder<PostItemController>(
      builder:(c) {

        return <Widget>[
        
          sa.name.isEmpty ? InputWidget(
            controller: txtcontroller,
            placeholder: LocaleKeys.postEnterSpecName.tr,
            onEditingComplete: (name) {
              sa.name = name;
              c.update(["sa_editor"]);
            },
            autoClear: true,
          ) : <Widget>[
            TextWidget.h4(sa.name),
            GestureDetector(
              onTap: () {
                if(c.salesAttributes.length > 1) {
                  c.salesAttributes.remove(sa);
                  c.update(["sa_editor"]); 
                }                
              },
              child: const Icon(Icons.delete_outline),
            ),
          ].toRow(
            mainAxisAlignment: MainAxisAlignment.spaceBetween
          ).paddingAll(AppSpace.card),
          
          for(var value in sa.values)
          <Widget>[
            <Widget>[
              value.asset == null ? 
                GestureDetector(
                  onTap: () async {
                    final result = await AssetPicker.pickAssets(
                      ctx,
                      pickerConfig: AssetPickerConfig(
                        maxAssets: 1,
                        requestType: RequestType.image
                    ));                
                    
                    if (result != null) {
                      value.asset = result.first;
                      c.update(["sa_editor"]);
                    }
                  },
                  child: Icon(Icons.camera_alt)
                ) : 
                Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadius.image),
                  ),
                  child: AssetEntityImage(
                    value.asset!,
                    isOriginal: false,
                    width: 30,
                    height: 30,
                    fit: BoxFit.cover,
                  ),
                ),
              TextWidget.body(value.value).paddingLeft(AppSpace.listRow),              
            ].toRow(),

            GestureDetector(
              onTap: () {
                sa.values.remove(value);
                c.update(["sa_editor"]);
              },
              child: Icon(Icons.delete_outline)
            )
          ].toRow(
            mainAxisAlignment: MainAxisAlignment.spaceBetween
          ).paddingAll(AppSpace.card),

          if(sa.name.isNotEmpty)
          InputWidget(
            controller: txtcontroller,
            placeholder: LocaleKeys.postEnterSAValue.tr,
            onEditingComplete: (value) {
              sa.values.add(
                SalesAttributeValueModel(value: value)
              );
              c.update(["sa_editor"]);
            },
            autoClear: true,
          ),
          
        ]
        .toColumn()
        .paddingAll(AppSpace.card)
        .card();
      },
    );
  }


  Widget _buildView(BuildContext ctx, PostItemController controller) {
    return SingleChildScrollView(
      child: <Widget>[

      TextWidget.h4('設置規格'),
      TextWidget.label(
        '或略過，直接設定庫存和價錢'
      )
      .paddingBottom(AppSpace.listItem),

      for(var sa in controller.salesAttributes)
      _buildSA(
        ctx, 
        sa, 
        controller.saControllers[controller.salesAttributes.indexOf(sa)]
      ),

      if(controller.salesAttributes.length == 1 && controller.salesAttributes[0].name.isNotEmpty)
      ButtonWidget.link(
        "添加規格類型",
        onTap: () {
          controller.salesAttributes.add(SalesAttributeModel(
            name: '',
            values: []
          ));
          controller.saControllers.add(TextEditingController());
          controller.update(["sa_editor"]);
        },
      )
      .width(double.infinity)
      .paddingTop(AppSpace.listItem),      


      ButtonWidget.primary(
        "下一步 設置庫存與價格",
        onTap: () {
          controller.onSetSkus();
          //showModalBottomSheet(
          //  context: ctx, 
          //  isScrollControlled: true,
          //  builder:(context) {
          //    return PriceList();
          //  },
          //);
        },
      )
      .width(double.infinity)
      .paddingTop(MediaQuery.of(Get.context!).size.height * 0.3),

      ].toColumn(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PostItemController>(
      id: "sa_editor",
      builder: (controller) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          child: _buildView(context, controller)
        );
      }
    );
  }
}