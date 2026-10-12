import 'package:collection/collection.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';

class MemoryController extends AsyncNotifier<List<Map<String, dynamic>>> {
  @override
  Future<List<Map<String, dynamic>>> build() =>
      ref.watch(memoryServiceProvider).all();
  Future<Future<void> Function()> save(String content, {String? id}) async {
    final store = ref.read(agentStoreProvider);
    final service = ref.read(memoryServiceProvider);
    Map<String, dynamic>? before;
    late Map<String, dynamic> after;
    await store.transaction(() async {
      before = id == null ? null : await store.get('memory:$id');
      after = await service.save(content, id: id);
    });
    ref.invalidateSelf();
    return () async {
      await store.transaction(() async {
        final key = 'memory:${after['id']}';
        if (!const DeepCollectionEquality().equals(
          await store.get(key),
          after,
        )) {
          throw StateError('undo_conflict');
        }
        await service.delete(after['id'] as String);
        if (before != null) await store.put(key, 'memory', before!);
      });
      if (ref.mounted) ref.invalidateSelf();
    };
  }

  Future<void> delete(String id) async {
    await ref
        .read(agentStoreProvider)
        .transaction(() => ref.read(memoryServiceProvider).delete(id));
    ref.invalidateSelf();
  }

  Future<void> deleteAll() async {
    await ref
        .read(agentStoreProvider)
        .transaction(() => ref.read(memoryServiceProvider).deleteAll());
    ref.invalidateSelf();
  }
}

final memoryControllerProvider =
    AsyncNotifierProvider<MemoryController, List<Map<String, dynamic>>>(
      MemoryController.new,
    );
