// models/city.dart
import 'district.dart';

class CityModel {
  final String name;
  final List<DistrictModel> districts;

  CityModel({
    required this.name,
    required this.districts,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) {
    var districtsList = json['districts'] as List;
    List<DistrictModel> districts = districtsList
        .map((district) => DistrictModel.fromJson(district))
        .toList();

    return CityModel(
      name: json['name'],
      districts: districts,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'districts': districts.map((district) => district.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return name;
  }
}