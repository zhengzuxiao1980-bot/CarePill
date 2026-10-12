/// 统一异常层次（docs/04 §10）。
///
/// 领域层只抛类型化异常，不带 UI 文案；
/// UI 层负责把异常翻译成口语文案（docs/07 §5）。
library;

sealed class AppException implements Exception {
  const AppException(this.cause, [this.stackTrace]);

  /// 底层原因（日志用，不直达老人）。
  final Object? cause;
  final StackTrace? stackTrace;

  @override
  String toString() => '$runtimeType(cause: $cause)';
}

/// 网络异常：请求模型服务 / 下载失败等。
final class NetworkException extends AppException {
  const NetworkException({
    required this.kind,
    Object? cause,
    StackTrace? stackTrace,
  }) : super(cause, stackTrace);

  final NetworkErrorKind kind;
}

enum NetworkErrorKind { timeout, connection, server, unknown }

/// AI 相关异常：能力缺失、协议错误、解析失败等。
final class AiException extends AppException {
  const AiException(this.code, {Object? cause, StackTrace? stackTrace})
    : super(cause, stackTrace);

  final AiErrorCode code;
}

enum AiErrorCode {
  /// 未配置可用模型。
  notConfigured,

  /// 当前模型不具备所需能力（视觉 / 函数调用）。
  capabilityMissing,

  /// 服务端返回协议错误（HTTP 4xx/5xx、结构不符）。
  protocol,

  /// 输出内容无法解析（JSON 等）。
  parse,

  /// 限流 / 配额问题。
  rateLimited,
  authentication,
  contextLength,
}

/// 数据库异常。
final class DatabaseException extends AppException {
  const DatabaseException(super.cause, [StackTrace? stackTrace]);
}

/// 输入校验异常（表单、AI 抽取字段校验等）。
final class ValidationException extends AppException {
  const ValidationException(this.field, {Object? cause}) : super(cause);

  /// 哪个字段不合法，如 `time`、`dose`。
  final String field;
}
