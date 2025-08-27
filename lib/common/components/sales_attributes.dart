import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:template/common/components/skus.dart';
import 'package:template/common/index.dart';

class SalesAttributesWidget extends StatefulWidget {
  const SalesAttributesWidget({
    super.key,
    this.salesAttributes = const {},
    required this.onAttributesChanged,
    required this.onSkusChanged
  });

  final Map<String, List<String>> salesAttributes;

  final Function(Map<String, List<String>>) onAttributesChanged;

  final Function(List<SkuModel>) onSkusChanged;

  @override
  State<SalesAttributesWidget> createState() => _SalesAttributesWidgetState();
}

class _SalesAttributesWidgetState extends State<SalesAttributesWidget> {

  late Map<String, List<String>> salesAttributes;

  late List<TextEditingController> textControllers = [];


  @override
  void initState() {
    super.initState();
    salesAttributes = widget.salesAttributes;
    if(salesAttributes.isEmpty) {
      salesAttributes[""] = [];
      textControllers.add(TextEditingController());
    }
    else {
      textControllers = List.generate(
        salesAttributes.length, 
        (index) => TextEditingController()
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    for(var controller in textControllers) {
      controller.dispose();
    }
  }
  

  Widget _buildAttributeSale({
    required TextEditingController controller,
    required MapEntry<String, List<String>> attribute
  }) {
    late Widget ws;

    if(attribute.key.isEmpty) {
      ws = <Widget>[
        TextField(
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "添加規格類型",
          ),    
          onSubmitted: (val) {
            setState(() {
              salesAttributes.remove("");
              salesAttributes[val] = [];
              controller.clear();
            });
          },
        ),

        TextWidget.label(
          "推薦常用的規格類型",
          color: context.colors.scheme.tertiary,
        ).paddingBottom(AppSpace.listItem),

        Wrap(
          spacing: AppSpace.listItem,
          runSpacing: AppSpace.listItem,
          children: [
            ButtonWidget.outline(
              "顏色",
              borderRadius: 20,
              borderColor: Colors.transparent,
              textColor: context.colors.scheme.onTertiaryContainer,
              backgroundColor: context.colors.scheme.tertiaryContainer, 
              onTap: () => setState(() {
                salesAttributes.remove("");
                salesAttributes["顏色"] = [];
                controller.clear();
              })
            ),
            ButtonWidget.outline(
              "尺碼",
              borderRadius: 20,
              borderColor: Colors.transparent,
              textColor: context.colors.scheme.onTertiaryContainer,
              backgroundColor: context.colors.scheme.tertiaryContainer, 
              onTap: () => setState(() {
                salesAttributes.remove("");
                salesAttributes["尺碼"] = [];
                controller.clear();
              })
            ),
            ButtonWidget.outline(
              "容量",
              borderRadius: 20,
              borderColor: Colors.transparent,
              textColor: context.colors.scheme.onTertiaryContainer,
              backgroundColor: context.colors.scheme.tertiaryContainer, 
              onTap: () => setState(() {
                salesAttributes.remove("");
                salesAttributes["容量"] = [];
                controller.clear();
              })
            ),
            ButtonWidget.outline(
              "份數",
              borderRadius: 20,
              borderColor: Colors.transparent,
              textColor: context.colors.scheme.onTertiaryContainer,
              backgroundColor: context.colors.scheme.tertiaryContainer, 
              onTap: () => setState(() {
                salesAttributes.remove("");
                salesAttributes["份數"] = [];
                controller.clear();
              })
            ),
            ButtonWidget.outline(
              "大小",
              borderRadius: 20,
              borderColor: Colors.transparent,
              textColor: context.colors.scheme.onTertiaryContainer,
              backgroundColor: context.colors.scheme.tertiaryContainer, 
              onTap: () => setState(() {
                salesAttributes.remove("");
                salesAttributes["大小"] = [];
                controller.clear();
              })
            ),
            ButtonWidget.outline(
              "高度",
              borderRadius: 20,
              borderColor: Colors.transparent,
              textColor: context.colors.scheme.onTertiaryContainer,
              backgroundColor: context.colors.scheme.tertiaryContainer, 
              onTap: () => setState(() {
                salesAttributes.remove("");
                salesAttributes["高度"] = [];
                controller.clear();
              })
            ),
            ButtonWidget.outline(
              "總量",
              borderRadius: 20,
              borderColor: Colors.transparent,
              textColor: context.colors.scheme.onTertiaryContainer,
              backgroundColor: context.colors.scheme.tertiaryContainer, 
              onTap: () => setState(() {
                salesAttributes.remove("");
                salesAttributes["總量"] = [];
                controller.clear();
              })
            ),
          ]
        ),


      ].toColumn(
        crossAxisAlignment: CrossAxisAlignment.start
      );
    }
    else {
      ws = <Widget>[

        <Widget>[
          TextWidget.body(attribute.key),
          ButtonWidget.outline(
            "刪除", 
            onTap: () => setState(() {
              salesAttributes.remove(attribute.key);
              textControllers.remove(controller);
              if(salesAttributes.isEmpty) {
                salesAttributes[""] = [];
                textControllers.add(TextEditingController());
              }
            }),
          ),
        ].toRow(
          mainAxisAlignment: MainAxisAlignment.spaceBetween
        ).paddingBottom(AppSpace.listItem * 2),

        for(var value in attribute.value)
        <Widget>[
          TextWidget.body(value),
          Spacer(),
          GestureDetector(
            onTap: () => setState(() {
            salesAttributes[attribute.key]!.remove(value);
            }),
            child: IconWidget.icon(
              Icons.delete_outline,
              color: context.colors.scheme.tertiary,
              size: 28
            ),
          ),
        ].toRow()
        .paddingHorizontal(AppSpace.listItem)
        .paddingBottom(AppSpace.listItem)
        .border(

          color: context.colors.scheme.surfaceDim,
          bottom: 1
        ).paddingTop(AppSpace.listItem),

        TextField(
          controller: controller,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "輸入具體的${attribute.key}",
          ),    
          onSubmitted: (val) {
            setState(() {
              salesAttributes[attribute.key]!.add(val);
              controller.clear();
            });
          },
        ).paddingHorizontal(AppSpace.listItem),

      ].toColumn();
    } 

    return ws.marginAll(AppSpace.card).card().paddingAll(AppSpace.page);
  }


  Widget _buidMainView() {
    return SingleChildScrollView(
      child: <Widget>[


        for(int index = 0; index < salesAttributes.length; index++)
          _buildAttributeSale(
            controller: textControllers[index],
            attribute: salesAttributes.entries.toList()[index]
          ),

        if(salesAttributes.length == 1 && salesAttributes.keys.first != "") 
        ButtonWidget.tertiary(
          "新增規格類型", 
          onTap: () => setState(() {
            textControllers.add(TextEditingController());
            salesAttributes[""] = [];
          })
        ).width(double.infinity)
        .paddingHorizontal(AppSpace.page)

      ].toColumn()
      .paddingBottom(AppSpace.buttonHeight * 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buidMainView(),
      appBar: AppBar(
        title: const TextWidget.h4("設置商品規格"),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              setState(() {
                for(var controller in textControllers) {
                  controller.clear();
                }
                salesAttributes = {};
              });
              Navigator.pop(context);
            },
          ),
        ],
      ),
      bottomSheet: SheetButtonWidget(
        onTap: () async {

          for(var attribute in salesAttributes.entries) {

            if(attribute.key.isEmpty) {
              return Loading.toast("規格類型不可為空");
            }

            if(attribute.value.isEmpty || attribute.value.length < 2) {
              return Loading.toast("規格值至少要有兩個");
            }
          }

          final skus = SkuUtil.toSkus(salesAttributes);

          widget.onAttributesChanged(salesAttributes);
          widget.onSkusChanged(skus);

          await ActionBottomSheet.barModel(
            SkusWidget(
              skus: skus,
              onSkusChanged: widget.onSkusChanged
            )
          );

        }, 
        onBackTap: () {
          setState(() {
            for(var controller in textControllers) {
              controller.clear();
            }
            salesAttributes = {};
          });
        },
        text: "下一步 設置價格與庫存",
        withBackNav: true
      ),
      resizeToAvoidBottomInset: false
    );
  }
}