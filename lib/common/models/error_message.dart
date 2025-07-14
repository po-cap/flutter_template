class ErrorMessageModel {

  int status;
  String? type;
  String? title;
  String? detail;
  String? instance;
  Map<String, dynamic>? params;

  ErrorMessageModel({
    required this.status,
    this.type,
    this.title,
    this.detail,
    this.instance,
    this.params,
  });

  factory ErrorMessageModel.fromJson(Map<String, dynamic> json) {
    return ErrorMessageModel(
      status: json['status'],
      type: json['type'],
      title: json['title'],
      detail: json['detail'],
      instance: json['instance'],
      params: json['invalid_params'],
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'type': type,
    'title': title,
    'detail': detail,
    'instance': instance,
    'invalid_params': params,
  };
}