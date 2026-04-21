class Item {
  final int? id;
  final String name;

  Item({this.id, required this.name});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name};
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(id: map['id'] as int?, name: map['name'] as String);
  }

  Item copyWith({int? id, String? name}) {
    return Item(id: id ?? this.id, name: name ?? this.name);
  }
}
