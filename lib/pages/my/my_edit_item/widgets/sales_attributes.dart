import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:template/common/index.dart';

class SalesAttributes extends StatefulWidget {
  const SalesAttributes({
    super.key,
    this.values = const {},
  });

  final Map<String, List<String>> values;

  @override
  State<SalesAttributes> createState() => _SalesAttributesState();
}

class _SalesAttributesState extends State<SalesAttributes> {

  late Map<String, List<String>> values;


  @override
  void initState() {
    super.initState();
    values = widget.values;
  }

  Widget _buildAttriobuteSale({
    required MapEntry<String, List<String>> attribute
  }) {
    if(attribute.key.isEmpty) {
      return <Widget>[
        TextField(
          decoration: InputDecoration(
            border: InputBorder.none,
            labelText: "添加規格類型"
          ),    
        ),

        TextWidget.label("推薦常用的規格類型"),

        Wrap(
          children: [
            ButtonWidget.ghost("顏色", onTap: () {}),
            ButtonWidget.ghost("尺碼", onTap: () {}),
            ButtonWidget.ghost("容量", onTap: () {}),
            ButtonWidget.ghost("份數", onTap: () {}),
            ButtonWidget.ghost("大小", onTap: () {}),
            ButtonWidget.ghost("高度", onTap: () {}),
            ButtonWidget.ghost("總量", onTap: () {}),
          ]
        ),


      ].toColumn();
    }
    else {
      return <Widget>[

        <Widget>[
          TextWidget.body(attribute.key),
          ButtonWidget.ghost(
            "刪除", 
            onTap: () {},
          ),
        ].toRow(),

        for(var value in attribute.value)
        <Widget>[
          TextWidget.body(value),
          ButtonWidget.ghost(
            "刪除", 
            onTap: () {},
          ),
        ].toRow(),

        TextField(
          decoration: InputDecoration(
            labelText: "輸入具體的${attribute.key}"
          ),    
        ),

      ].toColumn();
    } 
  }


  Widget _buidMainView() {
    return SingleChildScrollView(
      child: <Widget>[

        for(var attribute in values.entries)
        _buildAttriobuteSale(
          attribute: attribute
        ),

        if(values.length > 1) 
        ButtonWidget.outline(
          "新增規格類型", 
          onTap: () {}
        )

      ].toColumn(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buidMainView(),
      bottomSheet: SheetButtonWidget(
        onTap: () {}, 
        text: "下一步 設置價格與庫存",
        withBackNav: true
      ),
    );
  }
}