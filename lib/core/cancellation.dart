import 'dart:async';

/// Platform independent cancellation, including late plugin/network callbacks.
class CancellationSignal {
  final _done = Completer<void>();
  bool get isCancelled => _done.isCompleted;
  Future<void> get whenCancelled => _done.future;
  void cancel() {
    if (!isCancelled) _done.complete();
  }

  void check() {
    if (isCancelled) throw const OperationCancelled();
  }
}

class OperationCancelled implements Exception {
  const OperationCancelled();
}
