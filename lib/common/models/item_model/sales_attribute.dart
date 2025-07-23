import 'package:template/common/models/item_model/sales_attribute_value.dart';

class SalesAttributeModel {
  String name;
  List<SalesAttributeValueModel> values;
  double price;
  int quantity;
  
  SalesAttributeModel({
    required this.name,
    required this.values,
    this.price = 0,
    this.quantity = 0
  });

}
