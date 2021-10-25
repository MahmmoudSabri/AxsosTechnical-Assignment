class Order {
  final String? status, delivery_day, seller_name, is_first, total;

  Order({
    this.status,
    this.delivery_day,
    this.seller_name,
    this.is_first,
    this.total,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return new Order(
      status: json['status'].toString(),
      delivery_day: json['delivery_day'].toString(),
      seller_name: json['seller_name'].toString(),
      is_first: json['is_first'].toString(),
      total: json['total'].toString(),

    );
  }
}