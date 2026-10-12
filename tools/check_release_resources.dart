import 'dart:io';

/// 检查最终 APK，不能用合并前的资源目录代替资源压缩后的结果。
Future<void> main(List<String> args) async {
  final apk = File(
    args.isEmpty ? 'build/app/outputs/flutter-apk/app-release.apk' : args[0],
  );
  final aapt = args.length > 1 ? args[1] : _findAapt2();
  if (!apk.existsSync() || aapt == null) {
    stderr.writeln(
      'Build the Release APK and configure ANDROID_HOME / ANDROID_SDK_ROOT, '
      'or pass: dart run tools/check_release_resources.dart <apk> <aapt2>.',
    );
    exitCode = 1;
    return;
  }
  final dump = await Process.run(aapt, ['dump', 'resources', apk.path]);
  if (dump.exitCode != 0) {
    stderr.writeln('Cannot inspect APK resources: ${dump.stderr}');
    exitCode = 1;
    return;
  }
  final output = dump.stdout as String;
  for (final resource in ['drawable/ic_notification', 'raw/alert_long']) {
    // Require both the resource name and a packaged file, not an empty table entry.
    final entry = RegExp(
      r'^\s*resource 0x[0-9a-f]+ ' +
          RegExp.escape(resource) +
          r'\s*\r?\n\s*\([^\r\n]*\) \(file\) [^\r\n]+',
      multiLine: true,
    );
    if (!entry.hasMatch(output)) {
      stderr.writeln('Missing packaged notification resource: $resource');
      exitCode = 1;
    }
  }
  if (exitCode == 0) {
    stdout.writeln(
      'Release notification icon and sound resource checks passed.',
    );
  }
}

String? _findAapt2() {
  final localProperties = File('android/local.properties');
  final localSdk = localProperties.existsSync()
      ? RegExp(r'^sdk\.dir=(.+)$', multiLine: true)
            .firstMatch(localProperties.readAsStringSync())
            ?.group(1)
            ?.trim()
            .replaceAllMapped(RegExp(r'\\(.)'), (m) => m[1]!)
      : null;
  final sdk =
      Platform.environment['ANDROID_SDK_ROOT'] ??
      Platform.environment['ANDROID_HOME'] ??
      localSdk;
  if (sdk == null) return null;
  final buildTools = Directory('$sdk/build-tools');
  if (!buildTools.existsSync()) return null;
  final versions = buildTools.listSync().whereType<Directory>().toList()
    ..sort((a, b) => b.path.compareTo(a.path));
  final name = Platform.isWindows ? 'aapt2.exe' : 'aapt2';
  return versions
      .map((dir) => File('${dir.path}/$name'))
      .where((file) => file.existsSync())
      .firstOrNull
      ?.path;
}
