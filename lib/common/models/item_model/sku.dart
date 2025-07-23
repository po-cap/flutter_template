



class SkuModel {
  int id;
  String name;
  Map<String,String> specs;
  double price;
  String? photo;
  int availableStock;

  SkuModel({
    required this.id,
    required this.name,
    required this.specs,
    required this.price,
    required this.availableStock,
    this.photo
  });

  //factory SkuModel.fromSA(SalesAttributeModel sa) {
  //  return SkuModel(
  //    id: 0,
  //    name: sa.name,
  //    specs: {},
  //    price: 0,
  //    availableStock: 0,
  //  );
  //}

  factory SkuModel.fromJson(Map<String, dynamic> json) {
    return SkuModel(
      id: json['id'],
      name: json['name'],
      specs: json['specs'],
      price: json['price'],
      photo: json['photo'],
      availableStock: json['availableStock'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'specs': specs,
    'price': price,
    'photo': photo,
    'availableStock': availableStock
  };
}