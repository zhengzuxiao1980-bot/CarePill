import 'dart:io';
import 'dart:typed_data';

import 'package:image/image.dart' as img;

import '../core/app_constants.dart';
import '../core/app_logger.dart';

/// 拍照后的图片处理（docs/03 §6：压缩与方向纠正，省 token 与流量）。
Future<Uint8List?> compressForVision(String path) async {
  try {
    final bytes = await File(path).readAsBytes();
    var decoded = img.decodeImage(bytes);
    if (decoded == null) {
      return null;
    }
    // EXIF 方向纠正（手机竖拍常带旋转标记）。
    decoded = img.bakeOrientation(decoded);
    final maxEdge = kVisionImageMaxEdge;
    final w = decoded.width;
    final h = decoded.height;
    if (w > maxEdge || h > maxEdge) {
      final scale = maxEdge / (w > h ? w : h);
      decoded = img.copyResize(
        decoded,
        width: (w * scale).round(),
        height: (h * scale).round(),
      );
    }
    return Uint8List.fromList(img.encodeJpg(decoded, quality: kVisionImageQuality));
  } catch (e) {
    AppLog.w('图片压缩失败：$e');
    return null;
  }
}
