

class AssetModel {
  String url;
  String name;
  double size;

  AssetModel({
    required this.url, 
    required this.name, 
    required this.size
  });

  factory AssetModel.fromJson(Map<String, dynamic> json) {
    return AssetModel(
      url: json['url'],
      name: json['name'],
      size: json['size']
    );
  }

  Map<String, dynamic> toJson() => {
    'url': url,
    'name': name,
    'size': size
  };
}