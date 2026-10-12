import 'dart:io';

void main(List<String> args) {
  final candidates = args.isNotEmpty
      ? args
      : [
          'build/app/intermediates/merged_manifest/release/processReleaseMainManifest/AndroidManifest.xml',
          'build/app/intermediates/merged_manifests/release/processReleaseManifest/AndroidManifest.xml',
        ];
  final file = candidates
      .map(File.new)
      .where((f) => f.existsSync())
      .firstOrNull;
  if (file == null) {
    stderr.writeln(
      'Release merged manifest missing. Build the release APK first.',
    );
    exitCode = 1;
    return;
  }
  final xml = file.readAsStringSync();
  final queries =
      RegExp(r'<queries>[\s\S]*?</queries>').firstMatch(xml)?.group(0) ?? '';
  final checks = {
    'INTERNET': RegExp(
      r'<uses-permission[^>]*android:name="android.permission.INTERNET"',
    ).hasMatch(xml),
    'RECORD_AUDIO': RegExp(
      r'<uses-permission[^>]*android:name="android.permission.RECORD_AUDIO"',
    ).hasMatch(xml),
    'BLUETOOTH_CONNECT': xml.contains('android.permission.BLUETOOTH_CONNECT'),
    'RecognitionService': queries.contains('android.speech.RecognitionService'),
    'TTS_SERVICE': queries.contains('android.intent.action.TTS_SERVICE'),
  };
  for (final check in checks.entries) {
    if (!check.value) {
      stderr.writeln('Missing release capability: ${check.key}');
      exitCode = 1;
    }
  }
  if (exitCode == 0) {
    stdout.writeln('Release network and speech manifest checks passed.');
  }
}
