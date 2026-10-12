import 'package:uuid/uuid.dart';

import '../../core/exceptions.dart';
import '../../data/repositories/agent_store.dart';
import '../../i18n/strings.g.dart';

class MemoryService {
  MemoryService(this.store);
  final AgentStore store;
  Future<List<Map<String, dynamic>>> all() async {
    final rows = await store.list('memory');
    rows.sort(
      (a, b) => (b['updatedAt'] as String).compareTo(a['updatedAt'] as String),
    );
    return rows;
  }

  static bool isExplicit(String text, {bool forget = false}) {
    if (!forget &&
        RegExp(
          r"(不要|别|不用|不必|不想).{0,8}(记住|记着|记下来)|(?:do not|don't|never).{0,8}(remember|memorize)",
          caseSensitive: false,
        ).hasMatch(text)) {
      return false;
    }
    if (forget) {
      return RegExp(
        r'(?:^|请|帮我|麻烦|你)(?:把.{0,50})?(?:忘记|忘掉)|删除.{0,30}记忆|不再记|不要再记|\b(?:forget (?:my|that|this|the|what)|(?:delete|remove).{0,30}memor)',
        caseSensitive: false,
      ).hasMatch(text.trim());
    }
    return RegExp(
      r'(?:^|请|帮我|麻烦|你要|你得)(?:把.{0,30})?(?:记住|记着|记下来|记在心里)|记忆.{0,20}(?:改|更正|更新)|(?:更正|更新|修改).{0,20}记忆|(?:^|please\s+|you\s+)(?:remember|memorize|keep in mind)|\b(?:save|update|correct).{0,30}memor',
      caseSensitive: false,
    ).hasMatch(text.trim());
  }

  Future<Map<String, dynamic>> save(
    String content, {
    String? id,
    String? sourceMessageId,
    String? sourceText,
  }) async {
    final text = content.trim();
    if (text.isEmpty || text.length > 2000) {
      throw const ValidationException('memory');
    }
    final old = id == null ? null : await store.get('memory:$id');
    if (id != null && old == null) throw const ValidationException('memory_id');
    if (old != null) {
      await suppress(old);
    } else {
      final meta = await store.context();
      meta['memoryRevision'] = (meta['memoryRevision'] as int? ?? 0) + 1;
      await store.put('context', 'context', meta);
    }
    final now = DateTime.now().toIso8601String();
    final value = <String, dynamic>{
      'id': id ?? const Uuid().v4(),
      'source': 'user_reported',
      'content': text,
      'sourceMessageId': sourceMessageId,
      'sourceText': sourceText ?? text,
      'createdAt': old?['createdAt'] ?? now,
      'updatedAt': now,
    };
    await store.put('memory:${value['id']}', 'memory', value);
    return value;
  }

  Future<void> suppress(Map<String, dynamic> memory) async {
    final context = await store.context();
    final ids = Set<String>.from(context['suppressed'] as List? ?? []);
    final source = memory['sourceMessageId'] as String?;
    if (source != null) {
      ids.add(source);
      if (source.startsWith('u:')) ids.add('a:${source.substring(2)}');
    }
    context['suppressed'] = ids.toList();
    context['summary'] = '';
    context['covered'] = context['cutoff'] ?? 0;
    context['memoryRevision'] = (context['memoryRevision'] as int? ?? 0) + 1;
    await store.put('context', 'context', context);
  }

  Future<void> delete(String id) async {
    final old = await store.get('memory:$id');
    if (old != null) {
      await suppress(old);
      await store.remove('memory:$id');
    }
  }

  Future<void> deleteAll() async {
    for (final m in await all()) {
      await delete(m['id'] as String);
    }
  }

  Future<List<Map<String, dynamic>>> search(
    String query, {
    int limit = 20,
  }) async {
    final rows = await all();
    final terms = _terms(query);
    int score(Map<String, dynamic> m) {
      final content = (m['content'] as String).toLowerCase();
      return terms.where(content.contains).length;
    }

    rows.sort((a, b) {
      final s = score(b).compareTo(score(a));
      return s != 0
          ? s
          : (b['updatedAt'] as String).compareTo(a['updatedAt'] as String);
    });
    return rows.take(limit).toList();
  }

  Set<String> _terms(String text) {
    final result = RegExp(
      r'[a-z0-9]+',
      caseSensitive: false,
    ).allMatches(text.toLowerCase()).map((m) => m.group(0)!).toSet();
    for (final m in RegExp(r'[\u4e00-\u9fff]+').allMatches(text)) {
      final s = m.group(0)!;
      if (s.length == 1) result.add(s);
      for (var i = 0; i < s.length - 1; i++) {
        result.add(s.substring(i, i + 2));
      }
    }
    return result;
  }

  Future<Map<String, dynamic>> tool(
    String name,
    Map<String, dynamic> args, {
    required String userText,
    required String sourceMessageId,
  }) async {
    if (name == 'search_memories') {
      return {
        'memories': await search(args['query'] as String? ?? userText),
        'source': 'user_reported',
      };
    }
    if (sourceMessageId.isEmpty ||
        !isExplicit(userText, forget: name == 'forget_memory')) {
      return {'error': tr.agentV2.explicitOnly};
    }
    final id = args['id'] as String?;
    if (id != null) {
      final rows = await all();
      final target = rows.where((r) => r['id'] == id).firstOrNull;
      if (target == null) return {'error': tr.agentV2.memoryConflict};
      // A model-selected ID is insufficient when the user's target is ambiguous.
      final literal = rows
          .where(
            (r) =>
                userText.contains(r['id'] as String) ||
                userText.contains(r['content'] as String),
          )
          .toList();
      if (literal.isNotEmpty &&
          (literal.length != 1 || literal.single['id'] != id)) {
        return {'error': tr.agentV2.memoryConflict};
      }
      if (literal.isEmpty && rows.length > 1) {
        final terms = _terms(userText)
            .where(
              (t) => !{
                'my',
                'the',
                'i',
                'a',
                'is',
                'to',
                '我',
                '我的',
                '记住',
                '记忆',
                '忘记',
                '请把',
              }.contains(t),
            )
            .toSet();
        int score(Map<String, dynamic> row) => terms
            .where((t) => (row['content'] as String).toLowerCase().contains(t))
            .length;
        final best = rows.map(score).fold<int>(0, (a, b) => a > b ? a : b);
        final candidates = rows.where((r) => score(r) == best).toList();
        if (best == 0 ||
            candidates.length != 1 ||
            candidates.single['id'] != id) {
          return {
            'error': tr.agentV2.memoryConflict,
            'candidates': rows
                .map((r) => {'id': r['id'], 'content': r['content']})
                .toList(),
          };
        }
      }
    }
    if (id == null &&
        name == 'save_memory' &&
        RegExp(
          r'(更正|更新|修改).{0,20}记忆|记忆.{0,20}(改|更正|更新)|\b(update|correct).{0,30}memor',
          caseSensitive: false,
        ).hasMatch(userText)) {
      return {'error': tr.agentV2.memoryConflict};
    }
    if (name == 'forget_memory') {
      if (id == null || await store.get('memory:$id') == null) {
        return {'error': tr.agentV2.memoryConflict};
      }
      await delete(id);
      return {'forgotten': true, 'id': id};
    }
    final content = args['content'] as String? ?? '';
    // Store the user's own assertion, never a model-generated inference.
    if (content.trim().isEmpty || !userText.contains(content)) {
      return {'error': tr.agentV2.explicitOnly};
    }
    final duplicates = (await all())
        .where((m) => m['content'] == content)
        .toList();
    final resolved =
        id ?? (duplicates.isEmpty ? null : duplicates.first['id'] as String);
    final saved = await save(
      content,
      id: resolved,
      sourceMessageId: sourceMessageId,
      sourceText: userText,
    );
    return {'saved': true, 'memory': saved};
  }
}
