import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:kitty_community_app/app/core/utils/extensions/logger_extension.dart';
import 'package:path_provider/path_provider.dart';

class ImageHelper {
  static Future<File> compressImage(File sourceFile, int quality) async {
    File? compressedFile;
    try {
      final Directory extDir = await getTemporaryDirectory();
      final appImageDir =
          await Directory('${extDir.path}/app_images').create(recursive: true);
      final String targetPath =
          '${appImageDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final compressResult = await FlutterImageCompress.compressAndGetFile(
        sourceFile.absolute.path,
        targetPath,
        quality: quality,
        minHeight: 1600,
        minWidth: 1080,
      );
      if (compressResult != null) {
        compressedFile = File(compressResult.path);
      }
      // Nếu vẫn lớn hơn 2MB thì giảm chất lượng ảnh

      if (compressedFile == null) {
        return File(sourceFile.path);
      } else {
        if (compressedFile.readAsBytesSync().lengthInBytes > 2000000) {
          return await compressImage(compressedFile, 90);
        }
      }
      // var compressedSize = await _calculateImageSize(compressedFile);
      logger.w(
        'Resize successfully: ${sourceFile.readAsBytesSync().lengthInBytes / 1000000}MB to ${compressedFile.readAsBytesSync().lengthInBytes / 1000000}MB',
      );
      return compressedFile;
    } catch (e) {
      return sourceFile;
    }
  }
}
