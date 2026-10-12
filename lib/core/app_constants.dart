/// 业务与技术常量集中定义。
///
/// docs/04 §7：业务常量集中在 core/constants，禁止散落默认值。
library;

/// 任务展开天数：每日展开未来 7 天并注册闹钟（docs/06 §1）。
const int kExpansionDays = 7;

/// 升级提醒注册的时间窗：只对接下来 48 小时内的任务注册升级闹钟，
/// 更远的任务等每日展开时再注册，避免 alarm 数量失控。
const int kEscalationRegistrationHorizonHours = 48;

/// Agent 执行环最大模型轮次，防失控（docs/03 §4）。
const int kAgentMaxRounds = 5;

/// 单个工具执行超时（docs/03 §4）。
const Duration kToolTimeout = Duration(seconds: 10);

/// 单次模型请求超时。
const Duration kAiRequestTimeout = Duration(seconds: 60);

/// 视觉识别 JSON 解析失败重试次数（docs/03 §6）。
const int kVisionRetryLimit = 1;

/// 发送给视觉模型前图片的最长边（像素），控制 token 与流量。
const int kVisionImageMaxEdge = 1600;

/// 发送给视觉模型前 JPEG 压缩质量。
const int kVisionImageQuality = 82;

/// 通知渠道 ID / 名称（docs/06 §2）。
const String kReminderChannelId = 'pillpal_reminders';

/// 提醒测试通知的 ID（固定，避免与业务提醒冲突被批量取消）。
const int kTestReminderNotificationId = 20260000;

/// 数据备份 JSON 的 schemaVersion（docs/05 §4）。
const int kBackupSchemaVersion = 2;

/// 默认宽限期（分钟），设置项缺省时使用（docs/06 §3）。
const int kDefaultGracePeriodMinutes = 60;

/// 默认升级提醒：到点后 15 分钟再响，共 3 次（docs/06 §3）。
const int kDefaultEscalationCount = 3;
const int kDefaultEscalationIntervalMinutes = 15;

/// 默认提醒提前量（分钟）。
const int kDefaultReminderLeadMinutes = 0;

/// 按需药静默时段默认值（docs/06 §6）：22:00–7:00 只留通知不闹铃。
const String kDefaultQuietStart = '22:00';
const String kDefaultQuietEnd = '07:00';

/// 字体三档的正文基准字号（docs/07 §3）：标准 18 / 大 20（默认）/ 特大 24。
const double kFontStandardBase = 18;
const double kFontLargeBase = 20;
const double kFontXlargeBase = 24;

/// UI 尺寸规范（docs/07 §3）。
const double kMinTapTarget = 64;
const double kPrimaryButtonHeight = 96;
