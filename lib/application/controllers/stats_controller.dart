import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/stats.dart';
import '../providers.dart';

/// 统计页数据（docs/02 F9：日历、依从率、漏服清单）。
class StatsBundle {
  const StatsBundle({
    required this.stats7,
    required this.stats30,
    required this.calendar,
  });

  final AdherenceStats stats7;
  final AdherenceStats stats30;
  final List<DayHealthEntry> calendar;
}

class StatsController extends AsyncNotifier<StatsBundle> {
  @override
  Future<StatsBundle> build() async {
    final dose = ref.watch(doseServiceProvider);
    final stats7 = await dose.adherence(days: 7);
    final stats30 = await dose.adherence(days: 30);
    final calendar = await dose.calendar(days: 30);
    return StatsBundle(
      stats7: stats7,
      stats30: stats30,
      calendar: calendar,
    );
  }
}

final statsControllerProvider =
    AsyncNotifierProvider<StatsController, StatsBundle>(StatsController.new);
