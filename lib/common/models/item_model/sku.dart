class SkuModel {
  int id;
  String name;
  Map<String,String> specs;
  double price;
  String? photo;
  int quantity;

  SkuModel({
    required this.id,
    required this.name,
    required this.specs,
    required this.price,
    required this.quantity,
    this.photo
  });

  factory SkuModel.standard() {
    return SkuModel(
      id: 0, 
      name: "", 
      specs: {}, 
      price: 0, 
      quantity: 0
    );
  }


  factory SkuModel.fromJson(Map<String, dynamic> json) {
    return SkuModel(
      id: json['id'],
      name: json['name'],
      specs: json['specs'],
      price: json['price'],
      photo: json['photo'],
      quantity: json['availableStock'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'specs': specs,
    'price': price,
    'photo': photo,
    'availableStock': quantity
  };
}


extension SkuModelListExtension on List<SkuModel> {

  /// item 的顯示價格
  String displayPrice() {
    
    // 如果一個 sku 都沒有
    if(isEmpty) {
      return "NTD\$0";
    }
    // 如果只有一個 sku
    else if (length == 1) {
      return "NTD\$${this[0].price.toInt().toString()}";
    }
    // 如果也多個 sku
    else {
      var prices = map((e) => e.price.toInt()).toList();
      prices.sort();

      var min = prices[0];
      var max = prices[prices.length - 1];
      if(min == max) {
        return "NTD\$${min.toString()}";
      }
      else {
        return "NTD\$${min.toString()}~NTD\$${max.toString()}";
      }
    }
  }

}