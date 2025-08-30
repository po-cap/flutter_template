

class AddressModel {

  final String receiver;
  final String phone;
  final String city;
  final String district;
  final String street;
  final String zipCode;
  final String type;
  final String? store;

  AddressModel({
    required this.receiver,
    required this.phone,
    required this.city, 
    required this.district, 
    required this.street, 
    required this.zipCode, 
    required this.type, 
    required this.store
  });


  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      receiver: json['receiver'],
      phone: json['phone'],
      city: json['city'], 
      district: json['district'], 
      street: json['street'], 
      zipCode: json['zipCode'], 
      type: json['type'], 
      store: json['store']
    );
  }

  Map<String, dynamic> toJson() => {
    'receiver': receiver,
    'phone': phone,
    'city': city, 
    'district': district, 
    'street': street, 
    'zipCode': zipCode, 
    'type': type, 
    'store': store
  };

  @override
  String toString() {
    if(type == 'seven') {
      return 'Seven店到店，$store，$zipCode $city $street';
    } else if(type == 'family') {
      return '全家店到店，$store，$zipCode $city $street';
    } else {
      return '$zipCode $city$district$street';
    }
  }
}