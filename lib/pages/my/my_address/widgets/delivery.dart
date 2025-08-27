import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:template/common/index.dart';

class TabDeliveryView extends StatefulWidget {
  const TabDeliveryView({super.key});

  @override
  State<TabDeliveryView> createState() => _TabDeliveryViewState();
}

class _TabDeliveryViewState extends State<TabDeliveryView> {
  
  late List<CityModel> cities = [];

  CityModel? selectedCity;

  DistrictModel? selectedDistrict;

  Widget _buildField({
    required String label,
    required Widget child
  }) {
    return <Widget>[
      TextWidget.body(label)
      .paddingLeft(AppSpace.listItem)
      .paddingBottom(4),
      child
    ].toColumn(
      crossAxisAlignment: CrossAxisAlignment.start
    ).paddingBottom(AppSpace.listItem * 2);
  }

    // 主视图
  Widget _buildView(BuildContext context) {
    return <Widget>[
    
      _buildField(
        label: "收件人", 
        child: InputWidget(),
      ),
      _buildField(
        label: "手機號碼",
        child: InputWidget(),
      ).paddingBottom(AppSpace.listItem * 5),
    
      _buildField(
        label: "城市",
        child: DropdownWidget(
          value: selectedCity,
          label: "请選擇城市",
          items: cities,
          onChanged: (val) {
            setState(() {
              selectedCity = val;
            });
          }
        ),
      ),
      _buildField(
        label: "區域",
        child: DropdownWidget(
          value: selectedDistrict,
          label: "请選擇區域",
          items: selectedCity?.districts,
          onChanged: (val) {
            setState(() {
              selectedDistrict = val;
            });
          }
        )
      ),
      _buildField(
        label: "詳細地址",
        child: InputWidget(
          minLines: 2,
          maxLines: 2,
        ),
      ),
    
    
    
    ].toColumn()
    .paddingHorizontal(AppSpace.page);
  }
  
  @override
  Widget build(BuildContext context) {
    return _buildView(context);
  }
}