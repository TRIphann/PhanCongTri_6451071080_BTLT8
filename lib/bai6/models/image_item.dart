class ImageItem {
  final int? id;
  final String path;

  ImageItem({this.id, required this.path});

  Map<String, dynamic> toMap() {
    return {'id': id, 'path': path};
  }

  factory ImageItem.fromMap(Map<String, dynamic> map) {
    return ImageItem(
      id: map['id'] as int?,
      path: map['path'] as String,
    );
  }
}
