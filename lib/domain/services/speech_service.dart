import '../../i18n/strings.g.dart';

enum SpeechIssue {
  unavailable,
  permissionDenied,
  languageMissing,
  noSpeech,
  network,
  engine,
  cancelled,
}

enum SpeechOwner { assistant, reminder }

enum PlaybackStatus { completed, cancelled, disabled, failed }

class SpeechResult {
  const SpeechResult({this.text = '', this.issue, this.usedPartial = false});
  final String text;
  final SpeechIssue? issue;
  final bool usedPartial;
  bool get canSend => text.trim().isNotEmpty && issue == null;
}

class SpeechAvailability {
  const SpeechAvailability({this.issue});
  final SpeechIssue? issue;
  bool get available => issue == null;
}

class SpeechPlaybackResult {
  const SpeechPlaybackResult(this.status, {this.issue});
  final PlaybackStatus status;
  final SpeechIssue? issue;
}

abstract interface class SpeechService {
  Future<SpeechPlaybackResult> speak(
    String text, {
    SpeechOwner owner = SpeechOwner.assistant,
  });
  Future<void> stopSpeak({SpeechOwner? owner});
  Future<bool> isListeningAvailable();
  Future<SpeechAvailability> startListening({
    void Function(String)? onPartial,
    void Function()? onLimit,
    void Function(SpeechIssue)? onIssue,
  });
  Future<SpeechResult> finishListening();
  Future<void> cancelListening();

  /// Compatibility entry point for callers outside the push-to-talk UI.
  Future<String?> listen({
    void Function(String partial)? onPartial,
    Duration timeout,
  });
  Future<void> stopListening();
}

String speechIssueText(SpeechIssue issue) => switch (issue) {
  SpeechIssue.unavailable => tr.agentV2.speechUnavailable,
  SpeechIssue.permissionDenied => tr.agentV2.permissionDenied,
  SpeechIssue.languageMissing => tr.agentV2.languageMissing,
  SpeechIssue.noSpeech => tr.agentV2.noSpeech,
  SpeechIssue.cancelled => tr.agentV2.cancelled,
  _ => tr.agentV2.speechFailed,
};
String reminderSpeechText({
  required String timeText,
  required List<String> medicationLines,
}) => tr.speechService.announcement(
  arg1: timeText,
  arg2: medicationLines.join('、'),
);
