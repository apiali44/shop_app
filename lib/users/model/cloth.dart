class Cloth {
  int? item_id;
  String? item_name;
  double? item_rating;
  List<String>? item_tag;
  double? item_price;
  List<String>? item_size;
  List<String>? item_colors;
  String? item_desc;
  String? item_image;

  Cloth({
    this.item_id,
    this.item_name,
    this.item_rating,
    this.item_tag,
    this.item_price,
    this.item_size,
    this.item_colors,
    this.item_desc,
    this.item_image,
});

  factory Cloth.fromJson(Map<String, dynamic> json) => Cloth(
    item_id: int.parse(json["item_id"]),
    item_name: json["item_name"],
    item_rating: double.parse(json["item_rating"]),
    item_tag: json["item_tag"].toString().split(', '),
    item_price: double.parse(json["item_price"]),
    item_size: json["item_sizes"].toString().split(', '),
    item_colors: json["item_colors"].toString().split(', '),
    item_desc: json["item_desc"],
    item_image: json["item_image"]

  );
}