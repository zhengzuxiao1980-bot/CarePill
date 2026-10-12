import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/controllers/memory_controller.dart';
import '../../i18n/strings.g.dart';
import '../widgets/common.dart';

class MemoryPage extends ConsumerWidget {
  const MemoryPage({super.key});
  Future<void> _edit(
    BuildContext context,
    WidgetRef ref, {
    Map<String, dynamic>? memory,
  }) async {
    final input = TextEditingController(
      text: memory?['content'] as String? ?? '',
    );
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(tr.agentV2.memoryBody),
        content: TextField(controller: input, maxLines: 5, maxLength: 2000),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(tr.agentV2.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, input.text.trim()),
            child: Text(tr.agentV2.save),
          ),
        ],
      ),
    );
    // Dialog route disposal follows its closing animation.
    unawaited(
      Future<void>.delayed(const Duration(milliseconds: 400), input.dispose),
    );
    if (result == null || result.isEmpty || !context.mounted) return;
    try {
      final undo = await ref
          .read(memoryControllerProvider.notifier)
          .save(result, id: memory?['id'] as String?);
      if (context.mounted) {
        UndoBar.show(
          context,
          message: '${tr.agentV2.remembered}：$result',
          onUndo: () async {
            try {
              await undo();
            } catch (_) {
              if (context.mounted) {
                UndoBar.show(context, message: tr.agentV2.undoConflict);
              }
            }
          },
        );
      }
    } catch (e) {
      if (context.mounted) UndoBar.show(context, message: friendlyError(e));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Localizations.localeOf(context);
    final memories = ref.watch(memoryControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(tr.agentV2.memories),
        actions: [
          IconButton(
            tooltip: tr.agentV2.deleteAll,
            icon: const Icon(Icons.delete_sweep),
            onPressed: () async {
              if (await confirmDangerous(
                context,
                title: tr.agentV2.deleteAll,
                message: tr.agentV2.confirmDeleteMemories,
                confirmLabel: tr.agentV2.delete,
              )) {
                await ref.read(memoryControllerProvider.notifier).deleteAll();
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _edit(context, ref),
        child: const Icon(Icons.add),
      ),
      body: memories.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(friendlyError(e))),
        data: (rows) => rows.isEmpty
            ? Center(child: Text(tr.agentV2.memoryEmpty))
            : ListView.builder(
                padding: const EdgeInsets.only(bottom: 100),
                itemCount: rows.length,
                itemBuilder: (context, index) {
                  final m = rows[index];
                  return Card(
                    margin: const EdgeInsets.all(12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            m['content'] as String,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          Text(tr.agentV2.memorySource),
                          Wrap(
                            children: [
                              TextButton.icon(
                                onPressed: () => _edit(context, ref, memory: m),
                                icon: const Icon(Icons.edit),
                                label: Text(tr.agentV2.edit),
                              ),
                              TextButton.icon(
                                onPressed: () => ref
                                    .read(memoryControllerProvider.notifier)
                                    .delete(m['id'] as String),
                                icon: const Icon(Icons.delete_outline),
                                label: Text(tr.agentV2.delete),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
