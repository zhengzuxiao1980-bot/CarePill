import 'dart:io';

import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

/// 分级日志 + 滚动文件留痕（docs/04 §10）。
///
/// - debug 构建才输出 verbose；release 文件只保留 warning/error；
/// - AI 请求正文、对话内容和图片数据不进入文件日志；
/// - 不接任何第三方崩溃 SDK，崩溃写入本地日志，随"导出日志"一起分享。
class AppLog {
  AppLog._();

  static Logger _console = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      colors: false,
      dateTimeFormat: DateTimeFormat.none,
    ),
    level: Level.info,
  );

  static IOSink? _fileSink;
  static String? _logDirectory;
  static bool _verbose = false;

  /// 当前日志目录（设置页"导出日志"用）。
  static String? get logDirectory => _logDirectory;

  /// [logDirectory] 为空时不写文件（单测环境）。
  static void init({bool verbose = false, String? logDirectory}) {
    _verbose = verbose;
    _console = Logger(
      printer: PrettyPrinter(
        methodCount: 0,
        colors: false,
        dateTimeFormat: verbose
            ? DateTimeFormat.onlyTimeAndSinceStart
            : DateTimeFormat.none,
      ),
      level: verbose ? Level.all : Level.info,
    );
    if (logDirectory == null) {
      return;
    }
    try {
      final dir = Directory(logDirectory);
      _logDirectory = logDirectory;
      if (!dir.existsSync()) {
        dir.createSync(recursive: true);
      }
      // 简单滚动：每天一个文件，保留最近 7 天。
      final name = 'pillpal-${DateFormat('yyyyMMdd').format(DateTime.now())}.log';
      final file = File('${dir.path}${Platform.pathSeparator}$name');
      _fileSink = file.openWrite(mode: FileMode.append);
      pruneOldLogs(dir, keepDays: 7);
    } catch (e) {
      _console.w('日志文件初始化失败: $e');
    }
  }

  static void pruneOldLogs(Directory dir, {int keepDays = 7}) {
    final cutoff = DateTime.now().subtract(Duration(days: keepDays));
    for (final f in dir.listSync()) {
      if (f is File && f.path.endsWith('.log')) {
        final modified = f.lastModifiedSync();
        if (modified.isBefore(cutoff)) {
          try {
            f.deleteSync();
          } catch (_) {}
        }
      }
    }
  }

  static String get _stamp => DateFormat('HH:mm:ss.SSS').format(DateTime.now());

  static void _persist(String line) {
    final sink = _fileSink;
    if (sink == null) {
      return;
    }
    sink.writeln(line);
    // 不 flush 每条；关键事件由调用方 await flush()
  }

  static Future<void> flush() async {
    await _fileSink?.flush();
  }

  static void d(String message) {
    if (!_verbose) {
      return;
    }
    _console.d('[$_stamp] $message');
    // Debug 日志可能包含用户主动输入，Release 或文件留痕中不保存。
  }

  static void i(String message) {
    _console.i('[$_stamp] $message');
  }

  static void w(String message, [Object? error, StackTrace? stackTrace]) {
    _console.w('[$_stamp] $message ${error ?? ''}');
    _persist('W [$_stamp] $message error=$error');
    if (stackTrace != null) {
      _persist('W [$_stamp] $stackTrace');
    }
  }

  static void e(String message, [Object? error, StackTrace? stackTrace]) {
    _console.e('[$_stamp] $message ${error ?? ''}');
    _persist('E [$_stamp] $message error=$error');
    if (stackTrace != null) {
      _persist('E [$_stamp] $stackTrace');
    }
  }

  /// 崩溃捕获入口（docs/04 §10）。
  static void recordCrash(String source, Object error, StackTrace stackTrace) {
    _persist('CRASH [$source] $error');
    _persist('CRASH [$source] $stackTrace');
  }

  /// 密钥脱敏：日志中绝不出现完整 key（docs/03 §10）。
  static String maskSecret(String secret) {
    if (secret.length <= 6) {
      return '***';
    }
    return '${secret.substring(0, 3)}***${secret.substring(secret.length - 3)}';
  }

  /// 截断长文本（AI 响应日志）。
  static String snippet(String text, [int max = 500]) =>
      text.length <= max ? text : '${text.substring(0, max)}…(共${text.length}字)';

  static void dispose() {
    _fileSink?.close();
    _fileSink = null;
  }
}
