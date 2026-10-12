// Run from the project root: dart run tools/generate_brand_assets.dart
import 'dart:convert';
import 'dart:io';

import 'package:image/image.dart' as img;

void main() {
  final source = img.decodePng(File('icon.png').readAsBytesSync())!;
  void png(String path, int size, {double inset = 0, bool opaque = false}) {
    final canvas = img.Image(
      width: size,
      height: size,
      numChannels: opaque ? 3 : 4,
    );
    img.fill(canvas, color: img.ColorRgba8(246, 251, 255, opaque ? 255 : 0));
    final edge = (size * (1 - 2 * inset)).round();
    final resized = img.copyResize(
      source,
      width: edge,
      height: edge,
      maintainAspect: true,
      interpolation: img.Interpolation.average,
    );
    img.compositeImage(
      canvas,
      resized,
      dstX: (size - resized.width) ~/ 2,
      dstY: (size - resized.height) ~/ 2,
    );
    final file = File(path)..parent.createSync(recursive: true);
    file.writeAsBytesSync(img.encodePng(canvas));
  }

  png('assets/brand/icon.png', 512, opaque: true);
  const res = 'android/app/src/main/res';
  for (final (density, scale) in [
    ('mdpi', 1.0),
    ('hdpi', 1.5),
    ('xhdpi', 2.0),
    ('xxhdpi', 3.0),
    ('xxxhdpi', 4.0),
  ]) {
    png(
      '$res/mipmap-$density/ic_launcher.png',
      (48 * scale).round(),
      opaque: true,
    );
    // The entire square artwork fits inside the 66dp adaptive-icon safe circle.
    png(
      '$res/mipmap-$density/ic_launcher_foreground.png',
      (108 * scale).round(),
      inset: 0.29,
    );
    png('$res/drawable-$density/brand_splash.png', (160 * scale).round());
    // Android 12 uses a 288dp canvas with a 192dp safe circle.
    png(
      '$res/drawable-$density/brand_splash_android12.png',
      (288 * scale).round(),
      inset: 0.275,
    );
  }
  const icons = 'ios/Runner/Assets.xcassets/AppIcon.appiconset';
  final catalog = jsonDecode(
    File('$icons/Contents.json').readAsStringSync(encoding: utf8),
  ) as Map<String, dynamic>;
  for (final entry in catalog['images'] as List<dynamic>) {
    final icon = entry as Map<String, dynamic>;
    final size = double.parse((icon['size'] as String).split('x').first);
    final scale = double.parse((icon['scale'] as String).replaceAll('x', ''));
    png('$icons/${icon['filename']}', (size * scale).round(), opaque: true);
  }
  for (var scale = 1; scale <= 3; scale++) {
    final suffix = scale == 1 ? '' : '@${scale}x';
    png(
      'ios/Runner/Assets.xcassets/LaunchImage.imageset/LaunchImage$suffix.png',
      160 * scale,
    );
  }
  stdout.writeln(
    'Generated Android, iOS and in-app brand assets from icon.png.',
  );
}
