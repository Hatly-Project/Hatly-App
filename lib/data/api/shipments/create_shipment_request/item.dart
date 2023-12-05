import 'dart:convert';

class Item {
  double? price;
  double? weight;

  String? photo;
  String? link;
  String? name;

  Item({this.price, this.photo, this.link, this.name, this.weight});

  factory Item.fromMap(Map<String, dynamic> data) => Item(
        price: (data['price'] as num?)?.toDouble(),
        weight: (data['itemWeight'] as num?)?.toDouble(),
        photo: data['photo'] as String?,
        link: data['link'] as String?,
        name: data['name'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'price': price,
        'itemWeight': weight,
        'photo': photo,
        'link': link,
        'name': name,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Item].
  factory Item.fromJson(String data) {
    return Item.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Item] to a JSON string.
  String toJson() => json.encode(toMap());
}
