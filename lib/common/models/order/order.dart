

class OrderModel {

  /// 訂單編號
  final int id;
  
  /// 訂單日期
  final DateTime orderAt;
  /// 支付日期
  final DateTime? paidAt;
  /// 運送日期
  final DateTime? shippedAt;
  /// 完成日期
  final DateTime? completeAt;

  /// 運送商
  final String? shippingProvider;
  /// 運單編號
  final String? trackingNumber; 

  /// 收件人
  final String recipientName;
  /// 收件人電話
  final String recipeientPhone;
  /// 收件人地址
  final String address;

  /// 訂單金額
  final double orderAmount;
  /// 折扣
  final double discountAmount;
  /// 運費
  final double shippingFee;
  /// 總金額
  final double totalAmount;

  /// 商品
  final Map<String, dynamic> item;
  /// 庫存單元
  final Map<String, dynamic> sku;
  /// 數量
  final int quantity;


  OrderModel({
    required this.id, 
    required this.orderAt, 
    required this.paidAt, 
    required this.shippedAt, 
    required this.completeAt, 
    required this.shippingProvider, 
    required this.trackingNumber, 
    required this.recipientName, 
    required this.recipeientPhone, 
    required this.address, 
    required this.orderAmount, 
    required this.discountAmount, 
    required this.shippingFee, 
    required this.totalAmount, 
    required this.item, 
    required this.sku, 
    required this.quantity
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
    id: json['id'],
    orderAt: DateTime.parse(json['orderAt']),
    paidAt: json['paidAt'] != null ? DateTime.parse(json['paidAt']) : null,
    shippedAt: json['shippedAt'] != null ? DateTime.parse(json['shippedAt']) : null,
    completeAt: json['completeAt'] != null ? DateTime.parse(json['completeAt']) : null,
    shippingProvider: json['shippingProvider'],
    trackingNumber: json['trackingNumber'],
    recipientName: json['recipientName'],
    recipeientPhone: json['recipientPhone'],
    address: json['address'],
    orderAmount: json['orderAmount'],
    discountAmount: json['discountAmount'],
    shippingFee: json['shippingFee'],
    totalAmount: json['totalAmount'],
    item: json['item'],
    sku: json['sku'],
    quantity: json['quantity']
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'orderAt': orderAt.toIso8601String(),
    'paidAt': paidAt?.toIso8601String(),
    'shippedAt': shippedAt?.toIso8601String(),
    'completeAt': completeAt?.toIso8601String(),
    'shippingProvider': shippingProvider,
    'trackingNumber': trackingNumber,
    'recipientName': recipientName,
    'recipientPhone': recipeientPhone,
    'address': address,
    'orderAmount': orderAmount,
    'discountAmount': discountAmount,
    'shippingFee': shippingFee,
    'totalAmount': totalAmount,
    'item': item,
    'sku': sku,
    'quantity': quantity
  };  
}