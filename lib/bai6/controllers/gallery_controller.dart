import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import '../models/image_item.dart';
import '../utils/database_helper.dart';

class GalleryController {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<List<ImageItem>> getAllImages() async {
    return await _dbHelper.getAllImages();
  }

  // Tạo ảnh giả lập (tạo file ảnh với dữ liệu byte ngẫu nhiên)
  Future<bool> addSimulatedImage() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final imgDir = Directory('${dir.path}/gallery');
      if (!await imgDir.exists()) {
        await imgDir.create(recursive: true);
      }

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filePath = '${imgDir.path}/img_$timestamp.png';

      // Tạo ảnh PNG đơn giản với màu ngẫu nhiên
      final pngBytes = _generateSimplePng();
      final file = File(filePath);
      await file.writeAsBytes(pngBytes);

      final image = ImageItem(path: filePath);
      final id = await _dbHelper.insertImage(image);
      return id > 0;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteImage(int id, String path) async {
    try {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (_) {}
    final result = await _dbHelper.deleteImage(id);
    return result > 0;
  }

  // Tạo file PNG đơn giản với màu gradient ngẫu nhiên
  Uint8List _generateSimplePng() {
    final random = Random();
    final width = 200;
    final height = 200;

    // Tạo ảnh BMP đơn giản (dễ tạo hơn PNG)
    // Sử dụng raw RGBA rồi encode
    final r1 = random.nextInt(256);
    final g1 = random.nextInt(256);
    final b1 = random.nextInt(256);
    final r2 = random.nextInt(256);
    final g2 = random.nextInt(256);
    final b2 = random.nextInt(256);

    // Tạo PPM format (đơn giản, có thể đọc được)
    final buffer = StringBuffer();
    buffer.writeln('P3');
    buffer.writeln('$width $height');
    buffer.writeln('255');

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final t = x / width;
        final r = (r1 + (r2 - r1) * t).round();
        final g = (g1 + (g2 - g1) * t).round();
        final b = (b1 + (b2 - b1) * t).round();
        buffer.write('$r $g $b ');
      }
      buffer.writeln();
    }

    return Uint8List.fromList(buffer.toString().codeUnits);
  }
}
