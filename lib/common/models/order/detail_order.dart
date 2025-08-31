class DetailOrderModel {
  final int id;
  final String displayName;
  final String cover;
  final String description;
  final String skuName;
  final double unitPrice;
  final int quantity;
  final double discountAmount;
  final double shippingFee;
  final double totalAmount;
  final DateTime orderAt;
  final DateTime? paidAt;
  final DateTime? shippedAt;
  final DateTime? deliveredAt;
  final DateTime? cancelledAt;
  final DateTime? completeAt;
  final DateTime? refundAt;
  final String? shippingProvider;
  final String? trackingNumber;
  final String recipientName;
  final String recipientPhone;
  final String address;

  DetailOrderModel({
    required this.id, 
    required this.displayName, 
    required this.cover, 
    required this.description, 
    required this.skuName, 
    required this.unitPrice, 
    required this.quantity, 
    required this.discountAmount, 
    required this.shippingFee, 
    required this.totalAmount, 
    required this.orderAt, 
    required this.paidAt, 
    required this.shippedAt, 
    required this.deliveredAt, 
    required this.cancelledAt, 
    required this.completeAt, 
    required this.refundAt, 
    required this.shippingProvider, 
    required this.trackingNumber, 
    required this.recipientName, 
    required this.recipientPhone, 
    required this.address
  });

  factory DetailOrderModel.fromJson(Map<String, dynamic> json) {
    return DetailOrderModel(
      id: json['id'],
      displayName: json['displayName'],
      cover: json['cover'],
      description: json['description'],
      skuName: json['skuName'],
      unitPrice: json['unitPrice'],
      quantity: json['quantity'],
      discountAmount: json['discountAmount'],
      shippingFee: json['shippingFee'],
      totalAmount: json['totalAmount'],
      orderAt: DateTime.parse(json['orderAt']),
      paidAt: json['paidAt'] != null ? DateTime.parse(json['paidAt']) : null,
      shippedAt: json['shippedAt'] != null ? DateTime.parse(json['shippedAt']) : null,
      deliveredAt: json['deliveredAt'] != null ? DateTime.parse(json['deliveredAt']) : null,
      cancelledAt: json['cancelledAt'] != null ? DateTime.parse(json['cancelledAt']) : null,
      completeAt: json['completeAt'] != null ? DateTime.parse(json['completeAt']) : null,
      refundAt: json['refundAt'] != null ? DateTime.parse(json['refundAt']) : null,
      shippingProvider: json['shippingProvider'],
      trackingNumber: json['trackingNumber'],
      recipientName: json['recipientName'],
      recipientPhone: json['recipientPhone'],
      address: json['address']
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'displayName': displayName,
    'cover': cover,
    'description': description,
    'skuName': skuName,
    'unitPrice': unitPrice,
    'quantity': quantity,
    'discountAmount': discountAmount,
    'shippingFee': shippingFee,
    'totalAmount': totalAmount,
    'orderAt': orderAt.toIso8601String(),
    'paidAt': paidAt?.toIso8601String(),
    'shippedAt': shippedAt?.toIso8601String(),
    'deliveredAt': deliveredAt?.toIso8601String(),
    'cancelledAt': cancelledAt?.toIso8601String(),
    'completeAt': completeAt?.toIso8601String(),
    'refundAt': refundAt?.toIso8601String(),
    'shippingProvider': shippingProvider,
    'trackingNumber': trackingNumber,
    'recipientName': recipientName,
    'recipientPhone': recipientPhone,
    'address': address
  };
}