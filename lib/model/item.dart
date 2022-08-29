class Item {
  final String name;
  final double price;
  final double kg;

  Item(
    this.name,
    this.price,
    this.kg,
  );

  Map<String, dynamic> toJson() {
    return {
      'cost': price.toString(),
      'kg': kg.toString(),
    };
  }
}
