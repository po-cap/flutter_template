class ImageModel {
  final String url;
  final double width;
  final double height;

  ImageModel({
    required this.url,
    required this.width,
    required this.height
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      url: json['url'],
      width: json['width'],
      height: json['height']
    );
  }

  Map<String, dynamic> toJson() => {
    'url': url,
    'width': width,
    'height': height
  };
}