import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:template/common/index.dart';

class TabDeliveryView extends StatefulWidget {
  const TabDeliveryView({
    super.key, 
    required this.receiverController, 
    required this.phoneController, 
    required this.streetController, 
    required this.onCityChanged, 
    required this.onDistrictChanged
  });


  final TextEditingController receiverController;
  final TextEditingController phoneController;
  final TextEditingController streetController;
  final Function(CityModel?) onCityChanged;
  final Function(DistrictModel?) onDistrictChanged;



  @override
  State<TabDeliveryView> createState() => _TabDeliveryViewState();
}

class _TabDeliveryViewState extends State<TabDeliveryView> {
  
  late List<CityModel> cities = [];

  CityModel? selectedCity;

  DistrictModel? selectedDistrict;

  void initData() async {
    cities = await Address.load();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initData();
  }

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
    return SingleChildScrollView(
      child: <Widget>[
      
        _buildField(
          label: "收件人", 
          child: InputWidget(
            controller: widget.receiverController,
            cleanable: false,
          ),
        ),
        _buildField(
          label: "手機號碼",
          child: InputWidget(
            controller: widget.phoneController,
            cleanable: false,
          ),
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
                selectedDistrict = null;
                widget.onCityChanged(val);
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
                widget.onDistrictChanged(val);
              });
            }
          )
        ),
        _buildField(
          label: "詳細地址",
          child: InputWidget(
            controller: widget.streetController,
            cleanable: false,
            minLines: 2,
            maxLines: 2,
          ),
        ),
      
      
      
      ].toColumn()
      .paddingHorizontal(AppSpace.page),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return _buildView(context);
  }
}