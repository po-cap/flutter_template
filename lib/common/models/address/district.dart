// models/district.dart
class DistrictModel {
  final String name;
  final String zipCode;

  DistrictModel({
    required this.name,
    required this.zipCode,
  });

  factory DistrictModel.fromJson(Map<String, dynamic> json) {
    return DistrictModel(
      name: json['name'],
      zipCode: json['zipCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'zipCode': zipCode,
    };
  }

  @override
  String toString() {
    return name;
  }
}