import 'dart:convert';

import 'package:template/common/index.dart';
import 'package:flutter/services.dart';

class Address {
  static Future<List<CityModel>> load() async {
    
    // 
    final jsonString = await rootBundle.loadString(AssetsJson.address);
    final jsonData   = json.decode(jsonString);
    
    // 
    List<CityModel> cities = [];
    for (var data in jsonData) {
      cities.add(
        CityModel.fromJson(data) 
      );
    }
    
    return cities;
  }
}