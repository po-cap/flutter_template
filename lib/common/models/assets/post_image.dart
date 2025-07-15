

class PostImageRes {
  String url;
  String name;
  double size;

  PostImageRes({
    required this.url, 
    required this.name, 
    required this.size
  });

  factory PostImageRes.fromJson(Map<String, dynamic> json) {
    return PostImageRes(
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