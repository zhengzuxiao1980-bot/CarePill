# ADR-002: 领域服务面向仓库接口 + 测试用内存 fake（不依赖宿主 SQLite）

日期 / 状态: 2026-09-28 / 已采纳

## 背景

docs/04 §6 要求领域层单测是"纯 Dart 秒级回归安全网"；但仓库层直接绑定
Drift/SQLite 时，跑单测需要在宿主机可用的 SQLite 原生库——Windows 开发机
上 `sqlite3` 包的 native-assets 钩子要联网下载 DLL，离线/受限网络环境会直接
阻塞 `flutter test`。

## 决策

- 每个仓库在 `lib/data/repositories/` 内同时定义**抽象接口 + Drift 实现**
  （如 `MedicationRepository` / `DriftMedicationRepository`）；
- 领域服务只依赖抽象接口；
- 单测（`test/fakes/fakes.dart`）提供 `InMemory*` 内存实现，不触碰
  SQLite；Drift 行↔领域模型的映射仍集中在 Drift 实现里；
- `BackupService` 等跨仓库服务同样只依赖接口（清空走
  `repository.clearAll()`，不直接持有 `AppDatabase`）。

## 备选与否决原因

**单测直接用 Drift `NativeDatabase.memory()`**：能顺带覆盖 SQL 正确性。
否决原因：宿主机需要 SQLite 原生库（本机网络下载失败），且启动一个真库
的测试比纯内存 map 慢一个数量级，违背"秒级回归"的意图。SQL 正确性改由
真机冒烟（docs/04 §11 发布 checklist）与集成阶段覆盖。

## 后果

- 好处：全部 58 个单测在任何机器离线可跑；服务与存储解耦，替换存储后端
  （docs/04 §8）有现成接缝。
- 代价：Drift 查询本身（where/orderBy 语义）没有单测覆盖，映射错误只能靠
  真机验证发现。
- 重新评估条件：CI 可用 Linux runner（`sqlite3_flutter_libs` 在 Linux 有
  官方二进制）时，可加一层"Drift 内存库集成测试"补上 SQL 覆盖。
