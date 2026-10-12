///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

part of 'strings.g.dart';

// Path: <root>
typedef TranslationsZh = Translations; // ignore: unused_element
class Translations with BaseTranslations<AppLocale, Translations> {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  _meta = meta ?? TranslationMetadata(
		    locale: AppLocale.zh,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  );

	/// Metadata for the translations of <zh>.
	final TranslationMetadata<AppLocale, Translations> _meta;
	@override TranslationMetadata<AppLocale, Translations> get $meta => _meta;

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations
	late final Translations$barcode$zh barcode = Translations$barcode$zh._(_root);
	late final Translations$agentV2$zh agentV2 = Translations$agentV2$zh._(_root);
	late final Translations$ruleIntent$zh ruleIntent = Translations$ruleIntent$zh._(_root);
	late final Translations$toolRegistry$zh toolRegistry = Translations$toolRegistry$zh._(_root);
	late final Translations$modelsController$zh modelsController = Translations$modelsController$zh._(_root);
	late final Translations$stats$zh stats = Translations$stats$zh._(_root);
	late final Translations$agentService$zh agentService = Translations$agentService$zh._(_root);
	late final Translations$modelSetup$zh modelSetup = Translations$modelSetup$zh._(_root);
	late final Translations$modelSelection$zh modelSelection = Translations$modelSelection$zh._(_root);
	late final Translations$reminderScheduler$zh reminderScheduler = Translations$reminderScheduler$zh._(_root);
	late final Translations$speechService$zh speechService = Translations$speechService$zh._(_root);
	late final Translations$deviceChannel$zh deviceChannel = Translations$deviceChannel$zh._(_root);
	late final Translations$assistant$zh assistant = Translations$assistant$zh._(_root);
	late final Translations$cabinet$zh cabinet = Translations$cabinet$zh._(_root);
	late final Translations$draftConfirm$zh draftConfirm = Translations$draftConfirm$zh._(_root);
	late final Translations$medicationDetail$zh medicationDetail = Translations$medicationDetail$zh._(_root);
	late final Translations$medicationForm$zh medicationForm = Translations$medicationForm$zh._(_root);
	late final Translations$photoCapture$zh photoCapture = Translations$photoCapture$zh._(_root);
	late final Translations$onboarding$zh onboarding = Translations$onboarding$zh._(_root);
	late final Translations$about$zh about = Translations$about$zh._(_root);
	late final Translations$modelEdit$zh modelEdit = Translations$modelEdit$zh._(_root);
	late final Translations$modelManage$zh modelManage = Translations$modelManage$zh._(_root);
	late final Translations$romGuide$zh romGuide = Translations$romGuide$zh._(_root);
	late final Translations$settings$zh settings = Translations$settings$zh._(_root);
	late final Translations$appShell$zh appShell = Translations$appShell$zh._(_root);
	late final Translations$appTheme$zh appTheme = Translations$appTheme$zh._(_root);
	late final Translations$reminderFullscreen$zh reminderFullscreen = Translations$reminderFullscreen$zh._(_root);
	late final Translations$today$zh today = Translations$today$zh._(_root);
	late final Translations$common$zh common = Translations$common$zh._(_root);
	late final Translations$units$zh units = Translations$units$zh._(_root);
	late final Translations$notifications$zh notifications = Translations$notifications$zh._(_root);
	late final Translations$time$zh time = Translations$time$zh._(_root);
	late final Translations$weekdays$zh weekdays = Translations$weekdays$zh._(_root);
	late final Translations$ai$zh ai = Translations$ai$zh._(_root);
	late final Translations$enums$zh enums = Translations$enums$zh._(_root);
}

// Path: barcode
class Translations$barcode$zh {
	Translations$barcode$zh._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '扫码查药'
	String get title => '扫码查药';

	/// zh: '扫条码添加'
	String get entry => '扫条码添加';

	/// zh: '免费查询 openFDA 药品资料，主要覆盖美国市场。国内药盒可能查不到，可改用拍照识别或手动填写。无需配置 AI。'
	String get coverage => '免费查询 openFDA 药品资料，主要覆盖美国市场。国内药盒可能查不到，可改用拍照识别或手动填写。无需配置 AI。';

	/// zh: '扫码在手机本地完成，只向 openFDA 发送商品条码，不上传照片。追溯码、批号和序列号不会发送。'
	String get privacy => '扫码在手机本地完成，只向 openFDA 发送商品条码，不上传照片。追溯码、批号和序列号不会发送。';

	/// zh: 'Android 扫码使用 Google ML Kit 在设备上处理图像，该组件可能发送使用与性能诊断数据。'
	String get sdkPrivacy => 'Android 扫码使用 Google ML Kit 在设备上处理图像，该组件可能发送使用与性能诊断数据。';

	/// zh: '打开相机扫码'
	String get scan => '打开相机扫码';

	/// zh: '对准药盒的商品条码，或包含商品编号的二维码。'
	String get aim => '对准药盒的商品条码，或包含商品编号的二维码。';

	/// zh: '相机暂时无法使用。请在系统设置中允许相机权限，或返回输入条码数字。'
	String get cameraError => '相机暂时无法使用。请在系统设置中允许相机权限，或返回输入条码数字。';

	/// zh: '此设备不支持相机扫码，请输入药盒上的条码数字。'
	String get cameraUnsupported => '此设备不支持相机扫码，请输入药盒上的条码数字。';

	/// zh: '也可输入条码数字'
	String get manual => '也可输入条码数字';

	/// zh: '药盒上的 8、12、13 或 14 位商品条码'
	String get hint => '药盒上的 8、12、13 或 14 位商品条码';

	/// zh: '查询药品'
	String get lookup => '查询药品';

	/// zh: '正在查询药品资料…'
	String get loading => '正在查询药品资料…';

	/// zh: '未查到这件药品。免费数据源覆盖有限，不代表药品不存在或有问题。请核对条码，或使用下方其他添加方式。'
	String get notFound => '未查到这件药品。免费数据源覆盖有限，不代表药品不存在或有问题。请核对条码，或使用下方其他添加方式。';

	/// zh: '条码位数或校验位不正确，请重新扫描或核对数字。'
	String get invalid => '条码位数或校验位不正确，请重新扫描或核对数字。';

	/// zh: '这个码未包含可查询的商品编号。请扫描商品条码；普通网址二维码暂不支持。'
	String get unsupported => '这个码未包含可查询的商品编号。请扫描商品条码；普通网址二维码暂不支持。';

	/// zh: '这是 20 位追溯码，当前免费数据源不支持查询。请找药盒上的商品条码，或改用拍照识别／手动填写。'
	String get traceability => '这是 20 位追溯码，当前免费数据源不支持查询。请找药盒上的商品条码，或改用拍照识别／手动填写。';

	/// zh: '网络未连通，请检查网络后重试。也可以先手动添加。'
	String get network => '网络未连通，请检查网络后重试。也可以先手动添加。';

	/// zh: '查询超时，请稍后重试。也可以先手动添加。'
	String get timeout => '查询超时，请稍后重试。也可以先手动添加。';

	/// zh: '免费服务的查询额度暂时用完，请稍后再试，或改用其他添加方式。'
	String get rateLimited => '免费服务的查询额度暂时用完，请稍后再试，或改用其他添加方式。';

	/// zh: '药品查询服务暂不可用，请稍后重试。也可以先手动添加。'
	String get unavailable => '药品查询服务暂不可用，请稍后重试。也可以先手动添加。';

	/// zh: '请对照药盒核对'
	String get results => '请对照药盒核对';

	/// zh: '资料仅供录入参考，不代表批准或真伪鉴定。请核对药名、厂家与规格；条码不能确定您的服药用量和时间。'
	String get review => '资料仅供录入参考，不代表批准或真伪鉴定。请核对药名、厂家与规格；条码不能确定您的服药用量和时间。';

	/// zh: '通用名：$value'
	String generic({required Object value}) => '通用名：${value}';

	/// zh: '厂家：$value'
	String manufacturer({required Object value}) => '厂家：${value}';

	/// zh: '资料来源：openFDA（美国药品标签）'
	String get source => '资料来源：openFDA（美国药品标签）';

	/// zh: '核对并填写用药信息'
	String get use => '核对并填写用药信息';

	/// zh: '已从条码资料预填药名。请填写剂型、计量单位和规格，并按医嘱设置用量与时间；默认不设置定时提醒。'
	String get prefill => '已从条码资料预填药名。请填写剂型、计量单位和规格，并按医嘱设置用量与时间；默认不设置定时提醒。';

	/// zh: '请填写实际计量单位，例如片、粒或毫升。'
	String get missingUnit => '请填写实际计量单位，例如片、粒或毫升。';

	/// zh: '发现多个条码，请选择'
	String get choose => '发现多个条码，请选择';

	/// zh: '商品条码：$value'
	String code({required Object value}) => '商品条码：${value}';
}

// Path: agentV2
class Translations$agentV2$zh {
	Translations$agentV2$zh._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '已记住的内容'
	String get memories => '已记住的内容';

	/// zh: '已记住'
	String get remembered => '已记住';

	/// zh: '已忘记这条内容'
	String get memoryDeleted => '已忘记这条内容';

	/// zh: '还没有保存的记忆'
	String get memoryEmpty => '还没有保存的记忆';

	/// zh: '用户自述'
	String get memorySource => '用户自述';

	/// zh: '请明确要修改或忘记哪一条记忆。'
	String get memoryConflict => '请明确要修改或忘记哪一条记忆。';

	/// zh: '只有您明确要求记住、更正或忘记时，我才会修改长期记忆。'
	String get explicitOnly => '只有您明确要求记住、更正或忘记时，我才会修改长期记忆。';

	/// zh: '参数不完整或格式不正确，请再说明一下。'
	String get invalidArgs => '参数不完整或格式不正确，请再说明一下。';

	/// zh: '找到了多个可能的记录，请确认药品、日期和计划时刻。'
	String get ambiguous => '找到了多个可能的记录，请确认药品、日期和计划时刻。';

	/// zh: '没有找到对应记录。'
	String get notFound => '没有找到对应记录。';

	/// zh: '操作已经完成，但暂时没能生成完整回答。您可以查看结果或撤销。'
	String get committed => '操作已经完成，但暂时没能生成完整回答。您可以查看结果或撤销。';

	/// zh: '这条记录后来发生了变化，无法直接撤销，请查看最新记录。'
	String get undoConflict => '这条记录后来发生了变化，无法直接撤销，请查看最新记录。';

	/// zh: '撤销'
	String get undo => '撤销';

	/// zh: '去核对'
	String get reviewDraft => '去核对';

	/// zh: '重试'
	String get retry => '重试';

	/// zh: '取消'
	String get cancel => '取消';

	/// zh: '保存'
	String get save => '保存';

	/// zh: '删除'
	String get delete => '删除';

	/// zh: '删除全部记忆'
	String get deleteAll => '删除全部记忆';

	/// zh: '编辑'
	String get edit => '编辑';

	/// zh: '聊天和对话摘要将被清空，已保存的长期记忆和服药记录仍会保留。'
	String get clearHint => '聊天和对话摘要将被清空，已保存的长期记忆和服药记录仍会保留。';

	/// zh: '按住说话'
	String get hold => '按住说话';

	/// zh: '正在听，松开发送，上滑取消'
	String get recording => '正在听，松开发送，上滑取消';

	/// zh: '松开取消'
	String get cancelRecording => '松开取消';

	/// zh: '正在完成识别…'
	String get finalizing => '正在完成识别…';

	/// zh: '录音太短，请按住再说一次。'
	String get tooShort => '录音太短，请按住再说一次。';

	/// zh: '已达到录音时长上限，松开即可发送。'
	String get maxRecording => '已达到录音时长上限，松开即可发送。';

	/// zh: '没有听到内容，请再试一次。'
	String get noSpeech => '没有听到内容，请再试一次。';

	/// zh: '设备没有可用的语音服务，请使用键盘输入。'
	String get speechUnavailable => '设备没有可用的语音服务，请使用键盘输入。';

	/// zh: '请在系统设置中允许麦克风和语音识别权限。'
	String get permissionDenied => '请在系统设置中允许麦克风和语音识别权限。';

	/// zh: '系统未安装当前语言的语音支持，请在系统设置中添加。'
	String get languageMissing => '系统未安装当前语言的语音支持，请在系统设置中添加。';

	/// zh: '语音识别失败，已保留听到的文字，您可以修改后发送。'
	String get speechFailed => '语音识别失败，已保留听到的文字，您可以修改后发送。';

	/// zh: '暂时无法播报，您可以阅读屏幕上的回答。'
	String get ttsFailed => '暂时无法播报，您可以阅读屏幕上的回答。';

	/// zh: '上下文窗口（tokens）'
	String get contextWindow => '上下文窗口（tokens）';

	/// zh: '内容超过当前模型的上下文容量，请缩短文字或调整模型窗口设置。'
	String get contextTooLong => '内容超过当前模型的上下文容量，请缩短文字或调整模型窗口设置。';

	/// zh: '模型密钥无效或权限不足，请检查模型设置。'
	String get authFailed => '模型密钥无效或权限不足，请检查模型设置。';

	/// zh: '已取消'
	String get cancelled => '已取消';

	/// zh: '查看更早的消息'
	String get loadEarlier => '查看更早的消息';

	/// zh: '正在回复…'
	String get thinking => '正在回复…';

	/// zh: '记录已保存，提醒同步暂未完成，请稍后重试。'
	String get syncFailed => '记录已保存，提醒同步暂未完成，请稍后重试。';

	/// zh: '要记住的内容'
	String get memoryBody => '要记住的内容';

	/// zh: '删除已保存的长期记忆？聊天和服药记录不会删除。'
	String get confirmDeleteMemories => '删除已保存的长期记忆？聊天和服药记录不会删除。';

	/// zh: '语音与权限设置'
	String get speechSettings => '语音与权限设置';

	/// zh: '正在准备录音…'
	String get preparing => '正在准备录音…';

	/// zh: '正在播报…'
	String get speaking => '正在播报…';
}

// Path: ruleIntent
class Translations$ruleIntent$zh {
	Translations$ruleIntent$zh._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '我看了看：${arg1}。'
	String statusReply({required Object arg1}) => '我看了看：${arg1}。';

	/// zh: '今天暂时没查到吃药安排。'
	String get noSchedule => '今天暂时没查到吃药安排。';

	/// zh: '今天的药都记完了，没有下一顿了。'
	String get allDone => '今天的药都记完了，没有下一顿了。';

	/// zh: '下一顿是${arg1}的${arg2}，到时候我提醒您。'
	String nextReply({required Object arg1, required Object arg2}) => '下一顿是${arg1}的${arg2}，到时候我提醒您。';

	/// zh: '记上了！忘记按按钮没关系，跟我说一声就行。'
	String get recordedReply => '记上了！忘记按按钮没关系，跟我说一声就行。';

	/// zh: '好的，我记下了。'
	String get acknowledged => '好的，我记下了。';
}

// Path: toolRegistry
class Translations$toolRegistry$zh {
	Translations$toolRegistry$zh._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '共 ${arg1} 次：吃了 ${arg2} 次，漏了 ${arg3} 次，还没到点或没吃的 ${arg4} 次'
	String statusSummary({required Object arg1, required Object arg2, required Object arg3, required Object arg4}) => '共 ${arg1} 次：吃了 ${arg2} 次，漏了 ${arg3} 次，还没到点或没吃的 ${arg4} 次';

	/// zh: '今天没有还没吃的药了'
	String get allDone => '今天没有还没吃的药了';

	/// zh: '只能记今天和昨天的药，更早的请到"今日"页补记'
	String get recordingWindow => '只能记今天和昨天的药，更早的请到"今日"页补记';

	/// zh: '${arg1} 今天没有待吃的任务（可能已记上）'
	String noPending({required Object arg1}) => '${arg1} 今天没有待吃的任务（可能已记上）';

	/// zh: '记上了（${arg1}）'
	String recorded({required Object arg1}) => '记上了（${arg1}）';

	/// zh: '记为"这一次不吃了"'
	String get skipped => '记为"这一次不吃了"';

	/// zh: '已记成草稿，等主人确认后保存'
	String get draftSaved => '已记成草稿，等主人确认后保存';

	/// zh: '记了新药"${arg1}"的草稿，点开核对保存'
	String draftCreated({required Object arg1}) => '记了新药"${arg1}"的草稿，点开核对保存';
}

// Path: modelsController
class Translations$modelsController$zh {
	Translations$modelsController$zh._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '配置不存在'
	String get missingConfig => '配置不存在';

	/// zh: '还没填密钥'
	String get missingKey => '还没填密钥';
}

// Path: stats
class Translations$stats$zh {
	Translations$stats$zh._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '这 ${arg1} 天没有安排吃药任务。'
	String emptySummary({required Object arg1}) => '这 ${arg1} 天没有安排吃药任务。';

	/// zh: '这 ${arg1} 天一共该吃 ${arg2} 次，记上了 ${arg3} 次，漏了 ${arg4} 次，都吃到了 ${arg5}%。'
	String summary({required Object arg1, required Object arg2, required Object arg3, required Object arg4, required Object arg5}) => '这 ${arg1} 天一共该吃 ${arg2} 次，记上了 ${arg3} 次，漏了 ${arg4} 次，都吃到了 ${arg5}%。';

	/// zh: '吃药日历'
	String get title => '吃药日历';

	/// zh: '最近 7 天'
	String get lastWeek => '最近 7 天';

	/// zh: '还没有吃药安排'
	String get empty => '还没有吃药安排';

	/// zh: '最近 30 天（绿=都吃了 黄=有跳过 红=有漏吃）'
	String get lastMonth => '最近 30 天（绿=都吃了 黄=有跳过 红=有漏吃）';

	/// zh: '${arg1}月${arg2}日：${arg3}/${arg4}'
	String daySummary({required Object arg1, required Object arg2, required Object arg3, required Object arg4}) => '${arg1}月${arg2}日：${arg3}/${arg4}';

	/// zh: '生成给家人看的周报'
	String get weeklyReport => '生成给家人看的周报';

	/// zh: '先在"设置 → AI 模型"里添加一个模型。'
	String get setupModel => '先在"设置 → AI 模型"里添加一个模型。';

	/// zh: '关闭'
	String get close => '关闭';

	/// zh: '漏了的（近 7 天）'
	String get missedTitle => '漏了的（近 7 天）';

	/// zh: '漏了别慌：想起来就补上，千万别一次吃两顿的量。'
	String get missedHint => '漏了别慌：想起来就补上，千万别一次吃两顿的量。';

	/// zh: '${arg1} 没吃'
	String notTaken({required Object arg1}) => '${arg1} 没吃';
}

// Path: agentService
class Translations$agentService$zh {
	Translations$agentService$zh._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '我想想哈，过会儿再问我一次。'
	String get tryLater => '我想想哈，过会儿再问我一次。';

	/// zh: '这个问题我没弄明白，您再换句话说说？'
	String get notUnderstood => '这个问题我没弄明白，您再换句话说说？';

	/// zh: '今天没有安排吃药任务'
	String get noSchedule => '今天没有安排吃药任务';
}

// Path: modelSetup
class Translations$modelSetup$zh {
	Translations$modelSetup$zh._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '选择供应商'
	String get provider => '选择供应商';

	/// zh: '连接供应商'
	String get connect => '连接供应商';

	/// zh: '选择模型'
	String get model => '选择模型';

	/// zh: '测试并完成'
	String get finish => '测试并完成';

	/// zh: '第 ${step} 步，共 4 步'
	String progress({required Object step}) => '第 ${step} 步，共 4 步';

	/// zh: '下一步'
	String get next => '下一步';

	/// zh: '其他方式'
	String get other => '其他方式';

	/// zh: '自定义兼容服务'
	String get custom => '自定义兼容服务';

	/// zh: '先选一家提供 AI 的服务。接下来我们会一步步帮您完成设置。'
	String get intro => '先选一家提供 AI 的服务。接下来我们会一步步帮您完成设置。';

	/// zh: '请先选择一家供应商。'
	String get chooseProvider => '请先选择一家供应商。';

	/// zh: '获取密钥'
	String get getKey => '获取密钥';

	/// zh: '1. 打开供应商官网并登录 2. 创建 API 密钥 3. 复制密钥，回到这里粘贴'
	String get keySteps => '1. 打开供应商官网并登录\n2. 创建 API 密钥\n3. 复制密钥，回到这里粘贴';

	/// zh: 'AI 服务可能收费，具体以供应商的价格和账户额度为准。'
	String get cost => 'AI 服务可能收费，具体以供应商的价格和账户额度为准。';

	/// zh: '打开官方申请页面'
	String get openWebsite => '打开官方申请页面';

	/// zh: '复制官网地址'
	String get copyUrl => '复制官网地址';

	/// zh: '地址已复制'
	String get copied => '地址已复制';

	/// zh: '暂时打不开浏览器，请复制地址后打开。'
	String get openFailed => '暂时打不开浏览器，请复制地址后打开。';

	/// zh: '粘贴密钥'
	String get paste => '粘贴密钥';

	/// zh: '剪贴板里还没有文字。'
	String get emptyClipboard => '剪贴板里还没有文字。';

	/// zh: '显示密钥'
	String get showKey => '显示密钥';

	/// zh: '隐藏密钥'
	String get hideKey => '隐藏密钥';

	/// zh: '已保存密钥；留空继续使用'
	String get storedKey => '已保存密钥；留空继续使用';

	/// zh: '请填写供应商提供的密钥。'
	String get enterKey => '请填写供应商提供的密钥。';

	/// zh: '更换供应商或地址后，请重新填写对应的密钥。'
	String get keyChanged => '更换供应商或地址后，请重新填写对应的密钥。';

	/// zh: 'Ollama 不需要申请密钥。手机连接电脑上的 Ollama 时，请填写电脑的局域网地址，例如 http://192.168.1.10:11434/v1，并确保两台设备在同一网络、电脑已允许局域网访问。127.0.0.1 只代表当前设备。'
	String get localHint => 'Ollama 不需要申请密钥。手机连接电脑上的 Ollama 时，请填写电脑的局域网地址，例如 http://192.168.1.10:11434/v1，并确保两台设备在同一网络、电脑已允许局域网访问。127.0.0.1 只代表当前设备。';

	/// zh: '填写服务商提供的 OpenAI 兼容接口地址和密钥。地址应包含服务要求的路径，例如 /v1，不包含 /chat/completions。'
	String get customHint => '填写服务商提供的 OpenAI 兼容接口地址和密钥。地址应包含服务要求的路径，例如 /v1，不包含 /chat/completions。';

	/// zh: '请填写完整的 http:// 或 https:// 接口地址，不要包含空格、账号、查询参数或 #。'
	String get invalidUrl => '请填写完整的 http:// 或 https:// 接口地址，不要包含空格、账号、查询参数或 #。';

	/// zh: '推荐'
	String get recommended => '推荐';

	/// zh: '填写其他模型 ID'
	String get customModel => '填写其他模型 ID';

	/// zh: '已为您选好推荐模型，也可以选择其他模型。'
	String get modelHint => '已为您选好推荐模型，也可以选择其他模型。';

	/// zh: '可以聊天'
	String get chat => '可以聊天';

	/// zh: '可以识别药盒'
	String get vision => '可以识别药盒';

	/// zh: '可以聊天；此预设未启用看图'
	String get chatOnly => '可以聊天；此预设未启用看图';

	/// zh: '请按服务商提供的模型 ID 填写。未知模型默认仅用于聊天，高级设置中可以调整能力。'
	String get unknown => '请按服务商提供的模型 ID 填写。未知模型默认仅用于聊天，高级设置中可以调整能力。';

	/// zh: '高级设置'
	String get advanced => '高级设置';

	/// zh: '回答随机程度（可选）'
	String get temperature => '回答随机程度（可选）';

	/// zh: '上下文须至少为 2048；最大输出须为正整数，并比上下文至少少 2048。'
	String get invalidBudget => '上下文须至少为 2048；最大输出须为正整数，并比上下文至少少 2048。';

	/// zh: '测试连接'
	String get test => '测试连接';

	/// zh: '正在测试连接…'
	String get testing => '正在测试连接…';

	/// zh: '保存并完成'
	String get save => '保存并完成';

	/// zh: '先保存，稍后测试'
	String get saveLater => '先保存，稍后测试';

	/// zh: '正在保存…'
	String get saving => '正在保存…';

	/// zh: '确认下面的信息，然后测试能否连接。测试只发送一条简短消息，不会发送您的用药信息。'
	String get review => '确认下面的信息，然后测试能否连接。测试只发送一条简短消息，不会发送您的用药信息。';

	/// zh: '尚未测试连接'
	String get notTested => '尚未测试连接';

	/// zh: '连接成功，可以保存了'
	String get connected => '连接成功，可以保存了';

	/// zh: '暂时没有连上'
	String get testFailed => '暂时没有连上';

	/// zh: '连接测试只验证对话接口；图片识别能力尚未测试。'
	String get visionUntested => '连接测试只验证对话接口；图片识别能力尚未测试。';

	/// zh: '配置已保存，您可以稍后测试连接。'
	String get savedUntested => '配置已保存，您可以稍后测试连接。';

	/// zh: '配置已保存，连接测试成功。'
	String get savedConnected => '配置已保存，连接测试成功。';

	/// zh: '暂时无法读取这份配置，请返回后重试。'
	String get loadFailed => '暂时无法读取这份配置，请返回后重试。';

	/// zh: '密钥无效或没有访问权限，请回到上一步检查，或重新申请密钥。'
	String get authError => '密钥无效或没有访问权限，请回到上一步检查，或重新申请密钥。';

	/// zh: '没连上，请检查网络和接口地址后重试。'
	String get networkError => '没连上，请检查网络和接口地址后重试。';

	/// zh: '连接超时，请检查网络，稍后再试。'
	String get timeoutError => '连接超时，请检查网络，稍后再试。';

	/// zh: '请求太频繁或额度不足，请到供应商官网检查额度，稍后重试。'
	String get quotaError => '请求太频繁或额度不足，请到供应商官网检查额度，稍后重试。';

	/// zh: '请检查接口地址和模型 ID，并确认该服务支持 OpenAI 兼容对话。'
	String get configError => '请检查接口地址和模型 ID，并确认该服务支持 OpenAI 兼容对话。';
}

// Path: modelSelection
class Translations$modelSelection$zh {
	Translations$modelSelection$zh._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '通了'
	String get connected => '通了';

	/// zh: '没连上：${arg1}'
	String connectionFailed({required Object arg1}) => '没连上：${arg1}';

	/// zh: '能看图'
	String get visionReady => '能看图';

	/// zh: '看图没成功：${arg1}'
	String visionFailed({required Object arg1}) => '看图没成功：${arg1}';

	/// zh: '超时了：地址或网络有点慢'
	String get timeout => '超时了：地址或网络有点慢';

	/// zh: '连不上：检查地址和网络'
	String get offline => '连不上：检查地址和网络';

	/// zh: '网络问题：${arg1}'
	String networkError({required Object arg1}) => '网络问题：${arg1}';

	/// zh: '地址/密钥/模型名有一项不对'
	String get invalidConfig => '地址/密钥/模型名有一项不对';

	/// zh: '限流了：额度或频率超了'
	String get rateLimited => '限流了：额度或频率超了';

	/// zh: '模型返回异常：${arg1}'
	String modelError({required Object arg1}) => '模型返回异常：${arg1}';

	/// zh: '出了点问题：${arg1}'
	String unknownError({required Object arg1}) => '出了点问题：${arg1}';
}

// Path: reminderScheduler
class Translations$reminderScheduler$zh {
	Translations$reminderScheduler$zh._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '该吃药了'
	String get dueTitle => '该吃药了';

	/// zh: '刚刚没记上：${arg1}'
	String snoozedBody({required Object arg1}) => '刚刚没记上：${arg1}';

	/// zh: '提醒测试'
	String get testTitle => '提醒测试';

	/// zh: '到点了会这样提醒您。能听到就说明设置好了。'
	String get testBody => '到点了会这样提醒您。能听到就说明设置好了。';

	/// zh: '到点了，该吃药了（共 ${arg1} 种）'
	String dueBody({required Object arg1}) => '到点了，该吃药了（共 ${arg1} 种）';

	/// zh: '还没记上呢'
	String get unrecordedTitle => '还没记上呢';

	/// zh: '刚才提醒的药还没打卡（${arg1} 种）。点开看看。'
	String unrecordedBody({required Object arg1}) => '刚才提醒的药还没打卡（${arg1} 种）。点开看看。';
}

// Path: speechService
class Translations$speechService$zh {
	Translations$speechService$zh._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '${arg1}了，该吃${arg2}了。'
	String announcement({required Object arg1, required Object arg2}) => '${arg1}了，该吃${arg2}了。';
}

// Path: deviceChannel
class Translations$deviceChannel$zh {
	Translations$deviceChannel$zh._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '小米手机设置引导'
	String get xiaomiTitle => '小米手机设置引导';

	/// zh: '华为/荣耀手机设置引导'
	String get huaweiTitle => '华为/荣耀手机设置引导';

	/// zh: 'OPPO 手机设置引导'
	String get oppoTitle => 'OPPO 手机设置引导';

	/// zh: 'vivo 手机设置引导'
	String get vivoTitle => 'vivo 手机设置引导';

	/// zh: '手机设置引导'
	String get title => '手机设置引导';

	/// zh: '① 允许"自启动"：手机管家里找到"CarePill"，打开自启动开关。'
	String get autoStart => '① 允许"自启动"：手机管家里找到"CarePill"，打开自启动开关。';

	/// zh: '② 电池策略选"无限制"/关掉"省电限制"，别让系统把它关掉。'
	String get battery => '② 电池策略选"无限制"/关掉"省电限制"，别让系统把它关掉。';

	/// zh: '③ 通知权限打开，锁屏通知选"显示"。'
	String get notifications => '③ 通知权限打开，锁屏通知选"显示"。';

	/// zh: '小米手机建议：在"神隐模式"里把"CarePill"设为无限制。'
	String get xiaomiHint => '小米手机建议：在"神隐模式"里把"CarePill"设为无限制。';
}

// Path: assistant
class Translations$assistant$zh {
	Translations$assistant$zh._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '今天吃了吗'
	String get quickStatus => '今天吃了吗';

	/// zh: '下一顿吃什么'
	String get quickNext => '下一顿吃什么';

	/// zh: '我这个药怎么吃'
	String get quickUsage => '我这个药怎么吃';

	/// zh: '没听清，再按住说一次。'
	String get notHeard => '没听清，再按住说一次。';

	/// zh: '您说的是：'
	String get heardTitle => '您说的是：';

	/// zh: '算了'
	String get cancel => '算了';

	/// zh: '发送'
	String get send => '发送';

	/// zh: 'AI 助手'
	String get title => 'AI 助手';

	/// zh: '清空对话'
	String get clearTooltip => '清空对话';

	/// zh: '清空对话？'
	String get clearTitle => '清空对话？';

	/// zh: '聊过的内容会全部删掉。'
	String get clearMessage => '聊过的内容会全部删掉。';

	/// zh: '清空'
	String get clear => '清空';

	/// zh: '有问题，直接问我'
	String get welcome => '有问题，直接问我';

	/// zh: '随时都在'
	String get available => '随时都在';

	/// zh: '在听：${arg1}'
	String listening({required Object arg1}) => '在听：${arg1}';

	/// zh: '还差一步：告诉我用哪个 AI'
	String get setupTitle => '还差一步：告诉我用哪个 AI';

	/// zh: '让家人跟着例子填一下就行。填好之前，手动管理不受影响。'
	String get setupHint => '让家人跟着例子填一下就行。填好之前，手动管理不受影响。';

	/// zh: '去添加模型'
	String get addModel => '去添加模型';

	/// zh: '有事直接问我'
	String get emptyTitle => '有事直接问我';

	/// zh: '"今天吃了吗""下一个吃什么" 按住下面的麦克风说话，或者打字。'
	String get emptyHint => '"今天吃了吗""下一个吃什么"\n按住下面的麦克风说话，或者打字。';

	/// zh: '不对'
	String get correct => '不对';

	/// zh: '不对，'
	String get correctionPrefix => '不对，';

	/// zh: '想问什么就说…'
	String get inputHint => '想问什么就说…';

	/// zh: '撤销'
	String get undo => '撤销';
}

// Path: cabinet
class Translations$cabinet$zh {
	Translations$cabinet$zh._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '药箱'
	String get title => '药箱';

	/// zh: '药箱还是空的'
	String get emptyTitle => '药箱还是空的';

	/// zh: '可以手动填写、扫商品条码，或拍药盒识别后添加。'
	String get emptyHint => '可以手动填写、扫商品条码，或拍药盒识别后添加。';

	/// zh: '加一个药'
	String get add => '加一个药';

	/// zh: '正在吃的药'
	String get activeTitle => '正在吃的药';

	/// zh: '${arg1} 种'
	String count({required Object arg1}) => '${arg1} 种';

	/// zh: '没有安排吃药时间'
	String get noSchedule => '没有安排吃药时间';

	/// zh: '怎么加药？'
	String get addTitle => '怎么加药？';

	/// zh: '手动填一填'
	String get manual => '手动填一填';

	/// zh: '拍药盒（当前模型可能不支持看图）'
	String get photoUncertain => '拍药盒（当前模型可能不支持看图）';

	/// zh: '拍药盒，我来认'
	String get photo => '拍药盒，我来认';

	/// zh: '拍照识别（要先配好看图的模型）'
	String get photoSetup => '拍照识别（要先配好看图的模型）';
}

// Path: draftConfirm
class Translations$draftConfirm$zh {
	Translations$draftConfirm$zh._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '核对药品信息'
	String get title => '核对药品信息';

	/// zh: '没问题，保存'
	String get save => '没问题，保存';

	/// zh: '药名看不太清，请核对'
	String get uncertainName => '药名看不太清，请核对';

	/// zh: '药名'
	String get name => '药名';

	/// zh: '剂型'
	String get form => '剂型';

	/// zh: '单位（片/粒/毫升）'
	String get unit => '单位（片/粒/毫升）';

	/// zh: '规格（可不填）'
	String get spec => '规格（可不填）';

	/// zh: '吃药时间没认准，请核对'
	String get uncertainTime => '吃药时间没认准，请核对';

	/// zh: '什么时候吃（识别出的）'
	String get times => '什么时候吃（识别出的）';

	/// zh: '没认出吃药时间。保存后去"编辑"里加时间，或者不定时。'
	String get noTimes => '没认出吃药时间。保存后去"编辑"里加时间，或者不定时。';

	/// zh: '删除这个时间'
	String get removeTime => '删除这个时间';

	/// zh: '说明书原文（对照照片核对）'
	String get originalText => '说明书原文（对照照片核对）';

	/// zh: '核对无误再点"保存"。认错了的字直接改。'
	String get reviewHint => '核对无误再点"保存"。认错了的字直接改。';

	/// zh: '药名不能空。'
	String get missingName => '药名不能空。';

	/// zh: '保存好了！到点我会提醒您。'
	String get savedScheduled => '保存好了！到点我会提醒您。';

	/// zh: '保存好了。想设提醒的话，去"编辑"里加时间。'
	String get savedUnscheduled => '保存好了。想设提醒的话，去"编辑"里加时间。';
}

// Path: medicationDetail
class Translations$medicationDetail$zh {
	Translations$medicationDetail$zh._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '药品不存在'
	String get notFound => '药品不存在';

	/// zh: '药品详情'
	String get title => '药品详情';

	/// zh: '剂型'
	String get form => '剂型';

	/// zh: '规格'
	String get spec => '规格';

	/// zh: '一次吃'
	String get perDose => '一次吃';

	/// zh: '备注'
	String get notes => '备注';

	/// zh: '这个药是拍照识别进来的，用之前请核对一遍。'
	String get photoHint => '这个药是拍照识别进来的，用之前请核对一遍。';

	/// zh: '什么时候吃'
	String get times => '什么时候吃';

	/// zh: '还没有安排。点下面的"编辑"加一个。'
	String get noSchedule => '还没有安排。点下面的"编辑"加一个。';

	/// zh: '暂停'
	String get pause => '暂停';

	/// zh: '恢复'
	String get resume => '恢复';

	/// zh: '编辑'
	String get edit => '编辑';

	/// zh: '停用这个药'
	String get archive => '停用这个药';

	/// zh: '恢复在用'
	String get reactivate => '恢复在用';

	/// zh: '恢复了，到点会提醒。'
	String get resumed => '恢复了，到点会提醒。';

	/// zh: '暂停了，不再提醒。'
	String get paused => '暂停了，不再提醒。';

	/// zh: '停用"${arg1}"？'
	String archiveTitle({required Object arg1}) => '停用"${arg1}"？';

	/// zh: '停用后不再提醒，历史吃药记录会保留。以后还能恢复。'
	String get archiveMessage => '停用后不再提醒，历史吃药记录会保留。以后还能恢复。';

	/// zh: '停用'
	String get archiveConfirm => '停用';

	/// zh: '好了。'
	String get done => '好了。';
}

// Path: medicationForm
class Translations$medicationForm$zh {
	Translations$medicationForm$zh._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '编辑药品'
	String get editTitle => '编辑药品';

	/// zh: '加一个药（第${arg1}步，共3步）'
	String addTitle({required Object arg1}) => '加一个药（第${arg1}步，共3步）';

	/// zh: '下一步'
	String get next => '下一步';

	/// zh: '先给药起个名字，比如"降压药"。'
	String get missingName => '先给药起个名字，比如"降压药"。';

	/// zh: '至少留一个吃药的时间。'
	String get missingTime => '至少留一个吃药的时间。';

	/// zh: '保存'
	String get save => '保存';

	/// zh: '保存修改'
	String get saveChanges => '保存修改';

	/// zh: '这个药叫什么？'
	String get nameLabel => '这个药叫什么？';

	/// zh: '比如：降压药 / 苯磺酸氨氯地平片'
	String get nameHint => '比如：降压药 / 苯磺酸氨氯地平片';

	/// zh: '是什么剂型？'
	String get formLabel => '是什么剂型？';

	/// zh: '一次多少（单位）'
	String get unitLabel => '一次多少（单位）';

	/// zh: '片 / 粒 / 毫升'
	String get unitHint => '片 / 粒 / 毫升';

	/// zh: '规格（可不填）'
	String get specLabel => '规格（可不填）';

	/// zh: '5mg×30片'
	String get specHint => '5mg×30片';

	/// zh: '医生交代了什么？（可不填）'
	String get notesLabel => '医生交代了什么？（可不填）';

	/// zh: '比如：不能停药'
	String get notesHint => '比如：不能停药';

	/// zh: '什么时候吃？'
	String get frequencyLabel => '什么时候吃？';

	/// zh: '每天'
	String get daily => '每天';

	/// zh: '每周几天'
	String get weekdays => '每周几天';

	/// zh: '隔几天'
	String get interval => '隔几天';

	/// zh: '不定时（需要时吃）'
	String get asNeeded => '不定时（需要时吃）';

	/// zh: '每几天吃一次'
	String get intervalLabel => '每几天吃一次';

	/// zh: '间隔天数'
	String get intervalDays => '间隔天数';

	/// zh: '${arg1} 天'
	String days({required Object arg1}) => '${arg1} 天';

	/// zh: '加一个时间'
	String get addTime => '加一个时间';

	/// zh: '饭前还是饭后？'
	String get mealLabel => '饭前还是饭后？';

	/// zh: '不固定'
	String get mealAny => '不固定';

	/// zh: '按需要吃的药不进提醒；想记一笔的时候在"今日"页点它就行。'
	String get asNeededHint => '按需要吃的药不进提醒；想记一笔的时候在"今日"页点它就行。';

	/// zh: '每周${arg1}'
	String weeklySummary({required Object arg1}) => '每周${arg1}';

	/// zh: '每 ${arg1} 天一次'
	String intervalSummary({required Object arg1}) => '每 ${arg1} 天一次';

	/// zh: '需要时吃'
	String get asNeededSummary => '需要时吃';

	/// zh: '核对一遍'
	String get reviewTitle => '核对一遍';

	/// zh: '${arg1}（${arg2}） 单位 ${arg3}${arg4} ${arg5}${arg6}${arg7}'
	String reviewSummary({required Object arg1, required Object arg2, required Object arg3, required Object arg4, required Object arg5, required Object arg6, required Object arg7}) => '${arg1}（${arg2}）\n单位 ${arg3}${arg4}\n${arg5}${arg6}${arg7}';

	/// zh: '，规格 ${arg1}'
	String specSummary({required Object arg1}) => '，规格 ${arg1}';

	/// zh: '保存后，到点我会提醒您（如果定了时间）。'
	String get reviewHint => '保存后，到点我会提醒您（如果定了时间）。';

	/// zh: '保存好了！'
	String get saved => '保存好了！';

	/// zh: '第 ${arg1} 次服药时间'
	String doseTime({required Object arg1}) => '第 ${arg1} 次服药时间';

	/// zh: '这次吃多少'
	String get doseAmount => '这次吃多少';

	/// zh: '第 ${arg1} 次剂量'
	String doseNumber({required Object arg1}) => '第 ${arg1} 次剂量';

	/// zh: '删除这个时间'
	String get removeTime => '删除这个时间';
}

// Path: photoCapture
class Translations$photoCapture$zh {
	Translations$photoCapture$zh._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '先配置一个可用的模型，再来拍药盒。'
	String get setupFirst => '先配置一个可用的模型，再来拍药盒。';

	/// zh: '当前模型可能不支持看图'
	String get unverifiedTitle => '当前模型可能不支持看图';

	/// zh: '这个模型用于普通对话，看图识别可能失败。您也可以手动加药。'
	String get unverifiedMessage => '这个模型用于普通对话，看图识别可能失败。您也可以手动加药。';

	/// zh: '先不拍'
	String get cancel => '先不拍';

	/// zh: '继续试试'
	String get continueScan => '继续试试';

	/// zh: '照片有点问题，再拍一次试试。'
	String get invalidPhoto => '照片有点问题，再拍一次试试。';

	/// zh: '照片有点模糊，没看清。再拍一次，离近一点。'
	String get blurryPhoto => '照片有点模糊，没看清。再拍一次，离近一点。';

	/// zh: '识别没成功，再试一次。'
	String get failed => '识别没成功，再试一次。';

	/// zh: '这个药'
	String get unnamedMedicine => '这个药';

	/// zh: '认出来了'
	String get recognizedTitle => '认出来了';

	/// zh: '看着像"${arg1}"。 去核对一下每个字对不对，改好了再保存。'
	String recognizedMessage({required Object arg1}) => '看着像"${arg1}"。\n去核对一下每个字对不对，改好了再保存。';

	/// zh: '不保存'
	String get discard => '不保存';

	/// zh: '去核对'
	String get review => '去核对';

	/// zh: '拍药盒'
	String get title => '拍药盒';

	/// zh: '我看着呢，等一下…'
	String get loading => '我看着呢，等一下…';

	/// zh: '拍药盒上有字的那一面'
	String get photoTitle => '拍药盒上有字的那一面';

	/// zh: '光线亮一点，离近一点。 拍完我来认，认错了您改。'
	String get photoHint => '光线亮一点，离近一点。\n拍完我来认，认错了您改。';

	/// zh: '拍照'
	String get camera => '拍照';

	/// zh: '从相册选'
	String get gallery => '从相册选';

	/// zh: '当前模型可能不支持看图；继续前需要您确认。'
	String get unverifiedHint => '当前模型可能不支持看图；继续前需要您确认。';

	/// zh: '认出来的信息只是草稿，核对保存后才生效。'
	String get draftHint => '认出来的信息只是草稿，核对保存后才生效。';
}

// Path: onboarding
class Translations$onboarding$zh {
	Translations$onboarding$zh._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '帮您记住每一次吃药。 到点我叫您；忘了吃没吃，问我。'
	String get welcome => '帮您记住每一次吃药。\n到点我叫您；忘了吃没吃，问我。';

	/// zh: '开始'
	String get start => '开始';

	/// zh: '第一步：告诉 CarePill 用哪个 AI'
	String get modelTitle => '第一步：告诉 CarePill 用哪个 AI';

	/// zh: '这一步让家里人帮忙弄一次就行。跳过也不影响提醒和手动记账，AI 问答后面随时能加。'
	String get modelHint => '这一步让家里人帮忙弄一次就行。跳过也不影响提醒和手动记账，AI 问答后面随时能加。';

	/// zh: '跟着这四步就能完成：'
	String get requirements => '跟着这四步就能完成：';

	/// zh: '选择供应商 → 按提示申请密钥 → 选择模型 → 测试并保存。 常用服务的地址和模型已帮您填好，不懂技术也可以一步步完成。'
	String get requirementsHint => '选择供应商 → 按提示申请密钥 → 选择模型 → 测试并保存。\n\n常用服务的地址和模型已帮您填好，不懂技术也可以一步步完成。';

	/// zh: '去添加模型'
	String get addModel => '去添加模型';

	/// zh: '暂时跳过'
	String get skip => '暂时跳过';

	/// zh: '第二步：加第一个药'
	String get medicineTitle => '第二步：加第一个药';

	/// zh: 'AI 配置已保存。可以先手动添加药品，连接可用时也可以拍药盒识别。'
	String get modelReady => 'AI 配置已保存。可以先手动添加药品，连接可用时也可以拍药盒识别。';

	/// zh: '手动填就行：药叫什么、几点吃、一次多少。'
	String get manualHint => '手动填就行：药叫什么、几点吃、一次多少。';

	/// zh: '手动加药'
	String get manual => '手动加药';

	/// zh: '拍药盒（当前模型可能不支持看图）'
	String get photoUncertain => '拍药盒（当前模型可能不支持看图）';

	/// zh: '拍药盒，我来认'
	String get photo => '拍药盒，我来认';

	/// zh: '拍药盒（需要先配好看图的模型）'
	String get photoSetup => '拍药盒（需要先配好看图的模型）';

	/// zh: '先不加，直接进去看看'
	String get finish => '先不加，直接进去看看';
}

// Path: about
class Translations$about$zh {
	Translations$about$zh._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '隐私与免责说明'
	String get title => '隐私与免责说明';

	/// zh: '您的数据在哪里？'
	String get dataTitle => '您的数据在哪里？';

	/// zh: 'CarePill 没有账号、不用登录。药品、吃药记录、对话，全都只存在这台手机里，我们看不到，也拿不走。'
	String get dataBody => 'CarePill 没有账号、不用登录。药品、吃药记录、对话，全都只存在这台手机里，我们看不到，也拿不走。';

	/// zh: 'AI 是谁在回答？'
	String get aiTitle => 'AI 是谁在回答？';

	/// zh: 'AI 回答由您自己添加的模型服务生成（填的那个地址），提问内容和拍的照片会发给该服务商处理，受它的隐私政策约束。密钥只存在手机的安全存储里，不上传、不导出（除非您明确要求）。'
	String get aiBody => 'AI 回答由您自己添加的模型服务生成（填的那个地址），提问内容和拍的照片会发给该服务商处理，受它的隐私政策约束。密钥只存在手机的安全存储里，不上传、不导出（除非您明确要求）。';

	/// zh: 'AI 说的能全信吗？'
	String get adviceTitle => 'AI 说的能全信吗？';

	/// zh: '不能。AI 说的仅供参考，吃药请听医生的。 · 拍照认出来的用法用量只是草稿，必须人工核对保存； · 加量、减量、换药、停药，请务必问医生或药师； · 胸痛、喘不上气、摔倒这些情况，马上去医院或拨打 120。'
	String get adviceBody => '不能。AI 说的仅供参考，吃药请听医生的。\n\n· 拍照认出来的用法用量只是草稿，必须人工核对保存；\n· 加量、减量、换药、停药，请务必问医生或药师；\n· 胸痛、喘不上气、摔倒这些情况，马上去医院或拨打 120。';

	/// zh: '提醒不是百分百保险'
	String get remindersTitle => '提醒不是百分百保险';

	/// zh: '部分手机会限制后台运行，可能导致提醒不准时。请按"设置 → 手机设置引导"操作，并用"提醒测试"验证。'
	String get remindersBody => '部分手机会限制后台运行，可能导致提醒不准时。请按"设置 → 手机设置引导"操作，并用"提醒测试"验证。';
}

// Path: modelEdit
class Translations$modelEdit$zh {
	Translations$modelEdit$zh._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '支持对话、看图和工具调用；到 ${apiKeysUrl} 申请密钥'
	String deepseekHint({required Object apiKeysUrl}) => '支持对话、看图和工具调用；到 ${apiKeysUrl} 申请密钥';

	/// zh: '支持对话和工具调用，不支持看图；到 ${apiKeysUrl} 申请密钥'
	String deepseekProHint({required Object apiKeysUrl}) => '支持对话和工具调用，不支持看图；到 ${apiKeysUrl} 申请密钥';

	/// zh: 'DeepSeek 配置需要更新'
	String get deepseekUpdateTitle => 'DeepSeek 配置需要更新';

	/// zh: '当前模型 ID 已退役。可改用 ${model}，支持对话和药盒识别。更新后请点击保存。'
	String deepseekUpdateHint({required Object model}) => '当前模型 ID 已退役。可改用 ${model}，支持对话和药盒识别。更新后请点击保存。';

	/// zh: '填入新版 DeepSeek 配置'
	String get deepseekUpdate => '填入新版 DeepSeek 配置';

	/// zh: '通义千问（DashScope 兼容）'
	String get qwenName => '通义千问（DashScope 兼容）';

	/// zh: '阿里云百炼控制台申请密钥'
	String get qwenHint => '阿里云百炼控制台申请密钥';

	/// zh: 'Kimi（月之暗面）'
	String get kimiName => 'Kimi（月之暗面）';

	/// zh: 'platform.moonshot.cn 申请密钥'
	String get kimiHint => 'platform.moonshot.cn 申请密钥';

	/// zh: '智谱 GLM'
	String get glmName => '智谱 GLM';

	/// zh: 'open.bigmodel.cn 申请密钥'
	String get glmHint => 'open.bigmodel.cn 申请密钥';

	/// zh: 'OpenRouter（海外聚合）'
	String get openrouterName => 'OpenRouter（海外聚合）';

	/// zh: 'openrouter.ai 申请密钥'
	String get openrouterHint => 'openrouter.ai 申请密钥';

	/// zh: '本地 Ollama'
	String get ollamaName => '本地 Ollama';

	/// zh: '本机运行 Ollama，无需密钥（密钥填 ollama）'
	String get ollamaHint => '本机运行 Ollama，无需密钥（密钥填 ollama）';

	/// zh: '添加模型'
	String get addTitle => '添加模型';

	/// zh: '编辑模型'
	String get editTitle => '编辑模型';

	/// zh: '保存'
	String get save => '保存';

	/// zh: '常用服务示例（点一下自动填）'
	String get examples => '常用服务示例（点一下自动填）';

	/// zh: '填入'
	String get fill => '填入';

	/// zh: '名字（随便起）'
	String get nameLabel => '名字（随便起）';

	/// zh: '比如：女儿的 DeepSeek'
	String get nameHint => '比如：女儿的 DeepSeek';

	/// zh: '接口地址（一般带 /v1）'
	String get urlLabel => '接口地址（一般带 /v1）';

	/// zh: '密钥（API Key）'
	String get keyLabel => '密钥（API Key）';

	/// zh: '密钥（留空 = 不改）'
	String get keyUnchangedLabel => '密钥（留空 = 不改）';

	/// zh: '模型名'
	String get modelLabel => '模型名';

	/// zh: '用途'
	String get usage => '用途';

	/// zh: '支持看图'
	String get vision => '支持看图';

	/// zh: '拍照识别用'
	String get visionHint => '拍照识别用';

	/// zh: '支持函数调用'
	String get tools => '支持函数调用';

	/// zh: 'AI 帮忙打卡用；不确定就开着，错了会自动降级。'
	String get toolsHint => 'AI 帮忙打卡用；不确定就开着，错了会自动降级。';

	/// zh: '设为对话默认'
	String get defaultChat => '设为对话默认';

	/// zh: '回答最长字数（可选）'
	String get maxTokens => '回答最长字数（可选）';

	/// zh: '如 500'
	String get maxTokensHint => '如 500';

	/// zh: '密钥只存在这台手机的安全存储里，不上传、不导出（除非您明确要求）。'
	String get keyPrivacy => '密钥只存在这台手机的安全存储里，不上传、不导出（除非您明确要求）。';

	/// zh: '名字、地址、模型名都要填。'
	String get requiredFields => '名字、地址、模型名都要填。';

	/// zh: '密钥还没填（本地 Ollama 可填 ollama）。'
	String get requiredKey => '密钥还没填（本地 Ollama 可填 ollama）。';

	/// zh: '保存了。点"测试一下"确认能用。'
	String get saved => '保存了。点"测试一下"确认能用。';
}

// Path: modelManage
class Translations$modelManage$zh {
	Translations$modelManage$zh._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: 'AI 模型'
	String get title => 'AI 模型';

	/// zh: '还没有添加 AI 模型'
	String get emptyTitle => '还没有添加 AI 模型';

	/// zh: 'DeepSeek、通义千问、Kimi、智谱、OpenRouter、本地 Ollama 都可以。照着例子填三样：地址、密钥、模型名。'
	String get emptyHint => 'DeepSeek、通义千问、Kimi、智谱、OpenRouter、本地 Ollama 都可以。照着例子填三样：地址、密钥、模型名。';

	/// zh: '添加一个'
	String get add => '添加一个';

	/// zh: '点"设为对话默认"后，AI 助手就用它。能看图的模型还能用来拍药盒。'
	String get hint => '点"设为对话默认"后，AI 助手就用它。能看图的模型还能用来拍药盒。';

	/// zh: '对话默认'
	String get defaultChat => '对话默认';

	/// zh: '${arg1} · ${arg2} · 密钥${arg3}'
	String summary({required Object arg1, required Object arg2, required Object arg3}) => '${arg1} · ${arg2} · 密钥${arg3}';

	/// zh: '已填'
	String get keySet => '已填';

	/// zh: '没填'
	String get keyMissing => '没填';

	/// zh: '测试一下'
	String get test => '测试一下';

	/// zh: '编辑'
	String get edit => '编辑';

	/// zh: '删除'
	String get delete => '删除';

	/// zh: '设为对话默认'
	String get setDefault => '设为对话默认';

	/// zh: '通了！${arg1}'
	String connected({required Object arg1}) => '通了！${arg1}';

	/// zh: '删除"${arg1}"？'
	String deleteTitle({required Object arg1}) => '删除"${arg1}"？';

	/// zh: '配置和密钥会一起删掉。'
	String get deleteMessage => '配置和密钥会一起删掉。';
}

// Path: romGuide
class Translations$romGuide$zh {
	Translations$romGuide$zh._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '手机厂商为了省电，会把提醒类 App 关掉。照下面三步设置一次，提醒就稳了。'
	String get intro => '手机厂商为了省电，会把提醒类 App 关掉。照下面三步设置一次，提醒就稳了。';

	/// zh: '"CarePill"还没加入电池优化白名单，点下面去设置。'
	String get batteryHint => '"CarePill"还没加入电池优化白名单，点下面去设置。';

	/// zh: '提醒权限状态'
	String get permissions => '提醒权限状态';

	/// zh: '通知权限'
	String get notifications => '通知权限';

	/// zh: '精确闹钟'
	String get exactAlarms => '精确闹钟';

	/// zh: '锁屏全屏提醒'
	String get fullScreen => '锁屏全屏提醒';

	/// zh: '电池优化：已放行'
	String get batteryAllowed => '电池优化：已放行';

	/// zh: '去关闭电池优化'
	String get disableBattery => '去关闭电池优化';

	/// zh: '去开通知权限'
	String get enableNotifications => '去开通知权限';

	/// zh: '开好了记得回来。'
	String get returnHint => '开好了记得回来。';

	/// zh: '去开精确闹钟权限'
	String get enableAlarms => '去开精确闹钟权限';

	/// zh: '设好后，回"设置"点一次"提醒测试"确认真的会响。'
	String get testHint => '设好后，回"设置"点一次"提醒测试"确认真的会响。';

	/// zh: '${arg1}：${arg2}'
	String permissionStatus({required Object arg1, required Object arg2}) => '${arg1}：${arg2}';

	/// zh: '已允许'
	String get allowed => '已允许';

	/// zh: '未允许'
	String get notAllowed => '未允许';
}

// Path: settings
class Translations$settings$zh {
	Translations$settings$zh._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '设置'
	String get title => '设置';

	/// zh: '把 CarePill 调成适合您的样子'
	String get intro => '把 CarePill 调成适合您的样子';

	/// zh: '显示'
	String get display => '显示';

	/// zh: '字体大小'
	String get fontSize => '字体大小';

	/// zh: '标准'
	String get standard => '标准';

	/// zh: '大'
	String get large => '大';

	/// zh: '特大'
	String get extraLarge => '特大';

	/// zh: '提醒'
	String get reminders => '提醒';

	/// zh: '到点前提前'
	String get leadTime => '到点前提前';

	/// zh: '分钟'
	String get minutes => '分钟';

	/// zh: '没反应就再叫'
	String get repeatCount => '没反应就再叫';

	/// zh: '次'
	String get times => '次';

	/// zh: '升级提醒间隔'
	String get repeatInterval => '升级提醒间隔';

	/// zh: '过了多久算漏吃'
	String get gracePeriod => '过了多久算漏吃';

	/// zh: '深夜静音时段（暂未生效）'
	String get quietTitle => '深夜静音时段（暂未生效）';

	/// zh: '当前按需药也会按正常通知规则提醒；此设置仅保存配置，暂不影响提醒。'
	String get quietHint => '当前按需药也会按正常通知规则提醒；此设置仅保存配置，暂不影响提醒。';

	/// zh: '手机总把提醒关掉？点下面的"提醒测试"试试，再按手机型号设置一下。'
	String get reminderHint => '手机总把提醒关掉？点下面的"提醒测试"试试，再按手机型号设置一下。';

	/// zh: '响了响了…'
	String get testing => '响了响了…';

	/// zh: '提醒测试（现在试一次）'
	String get testReminder => '提醒测试（现在试一次）';

	/// zh: '手机设置引导（防杀后台）'
	String get phoneGuide => '手机设置引导（防杀后台）';

	/// zh: '语音'
	String get speech => '语音';

	/// zh: '语音播报'
	String get tts => '语音播报';

	/// zh: '到点念出来'
	String get ttsHint => '到点念出来';

	/// zh: '语速'
	String get speechRate => '语速';

	/// zh: '慢'
	String get slow => '慢';

	/// zh: '快'
	String get fast => '快';

	/// zh: '正常'
	String get normal => '正常';

	/// zh: '试听'
	String get preview => '试听';

	/// zh: '该吃降压药了，一次一片。'
	String get speechSample => '该吃降压药了，一次一片。';

	/// zh: 'AI 模型'
	String get models => 'AI 模型';

	/// zh: '选择供应商，跟着引导连接自己的 AI。密钥只存在本机，也可以先保存、稍后测试。'
	String get modelsHint => '选择供应商，跟着引导连接自己的 AI。密钥只存在本机，也可以先保存、稍后测试。';

	/// zh: '管理模型'
	String get manageModels => '管理模型';

	/// zh: '数据'
	String get data => '数据';

	/// zh: '吃药日历和统计'
	String get stats => '吃药日历和统计';

	/// zh: '导出备份（JSON）'
	String get exportBackup => '导出备份（JSON）';

	/// zh: '从备份恢复（会覆盖现在的数据）'
	String get restoreBackup => '从备份恢复（会覆盖现在的数据）';

	/// zh: '导出日志（给家人看）'
	String get exportLogs => '导出日志（给家人看）';

	/// zh: '重新看一遍新手引导'
	String get onboarding => '重新看一遍新手引导';

	/// zh: '关于'
	String get about => '关于';

	/// zh: '隐私与免责说明'
	String get privacy => '隐私与免责说明';

	/// zh: 'CarePill v1.0.0 · 无账号 · 数据全在本机 AI 回答由你自己添加的模型服务生成，处理过程受该服务商隐私政策约束。'
	String get aboutHint => 'CarePill v1.0.0 · 无账号 · 数据全在本机\nAI 回答由你自己添加的模型服务生成，处理过程受该服务商隐私政策约束。';

	/// zh: '发了测试提醒。看到/听到了就说明没问题；没响就点"手机设置引导"。'
	String get testSent => '发了测试提醒。看到/听到了就说明没问题；没响就点"手机设置引导"。';

	/// zh: '备份已生成（不含密钥）：${arg1}'
	String backupSaved({required Object arg1}) => '备份已生成（不含密钥）：${arg1}';

	/// zh: '从备份恢复？'
	String get restoreTitle => '从备份恢复？';

	/// zh: '恢复会用备份文件里的数据覆盖现在的药品、计划和打卡记录。确定继续？'
	String get restoreMessage => '恢复会用备份文件里的数据覆盖现在的药品、计划和打卡记录。确定继续？';

	/// zh: '恢复'
	String get restore => '恢复';

	/// zh: '备份文件'
	String get backupFile => '备份文件';

	/// zh: '恢复好了，任务和提醒已重新排好。'
	String get restored => '恢复好了，任务和提醒已重新排好。';

	/// zh: '日志没开（开发模式）'
	String get logsDisabled => '日志没开（开发模式）';

	/// zh: '日志在：${arg1}'
	String logsPath({required Object arg1}) => '日志在：${arg1}';
}

// Path: appShell
class Translations$appShell$zh {
	Translations$appShell$zh._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '今日'
	String get today => '今日';

	/// zh: '药箱'
	String get cabinet => '药箱';

	/// zh: 'AI助手'
	String get assistant => 'AI助手';

	/// zh: '设置'
	String get settings => '设置';
}

// Path: appTheme
class Translations$appTheme$zh {
	Translations$appTheme$zh._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '已吃'
	String get taken => '已吃';

	/// zh: '没吃'
	String get missed => '没吃';

	/// zh: '不吃'
	String get skipped => '不吃';

	/// zh: '待吃'
	String get pending => '待吃';
}

// Path: reminderFullscreen
class Translations$reminderFullscreen$zh {
	Translations$reminderFullscreen$zh._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '${arg1}的${arg2}，一次${arg3}'
	String doseDescription({required Object arg1, required Object arg2, required Object arg3}) => '${arg1}的${arg2}，一次${arg3}';

	/// zh: '${arg1}了，该吃${arg2}了：${arg3}。'
	String announcement({required Object arg1, required Object arg2, required Object arg3}) => '${arg1}了，该吃${arg2}了：${arg3}。';

	/// zh: '药'
	String get medicine => '药';

	/// zh: '该吃药了'
	String get title => '该吃药了';

	/// zh: '这里的药已经记上了。 点左上角返回。'
	String get alreadyRecorded => '这里的药已经记上了。\n点左上角返回。';

	/// zh: '吃了'
	String get taken => '吃了';

	/// zh: '都吃了'
	String get allTaken => '都吃了';

	/// zh: '等会儿再提醒'
	String get snooze => '等会儿再提醒';

	/// zh: '今天不吃了'
	String get skip => '今天不吃了';

	/// zh: '有一项没记上：${arg1}'
	String partialFailure({required Object arg1}) => '有一项没记上：${arg1}';

	/// zh: '记上了！${arg1}次都记好啦。'
	String recorded({required Object arg1}) => '记上了！${arg1}次都记好啦。';

	/// zh: '好，等会儿再叫您。'
	String get snoozed => '好，等会儿再叫您。';

	/// zh: '今天不吃了？'
	String get skipTitle => '今天不吃了？';

	/// zh: '医生交代要按时吃的药，尽量别停哦。确定这次不吃了？'
	String get skipMessage => '医生交代要按时吃的药，尽量别停哦。确定这次不吃了？';

	/// zh: '不吃了'
	String get skipConfirm => '不吃了';
}

// Path: today
class Translations$today$zh {
	Translations$today$zh._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: 'CarePill · 今日'
	String get title => 'CarePill · 今日';

	/// zh: '今天还没有安排吃药'
	String get emptyTitle => '今天还没有安排吃药';

	/// zh: '去"药箱"加一个药，选好几点吃，到点我提醒您。'
	String get emptyHint => '去"药箱"加一个药，选好几点吃，到点我提醒您。';

	/// zh: '去加药'
	String get add => '去加药';

	/// zh: '今天'
	String get today => '今天';

	/// zh: '按时吃，安心过'
	String get tagline => '按时吃，安心过';

	/// zh: '下一次服药'
	String get nextDose => '下一次服药';

	/// zh: '有 ${arg1} 次药好像没吃。想起了就点"补上"，千万别一次吃两顿的量。'
	String missedHint({required Object arg1}) => '有 ${arg1} 次药好像没吃。想起了就点"补上"，千万别一次吃两顿的量。';

	/// zh: '${arg1}${arg2}${arg3}'
	String doseSummary({required Object arg1, required Object arg2, required Object arg3}) => '${arg1}${arg2}${arg3}';

	/// zh: ' · 需要时吃'
	String get asNeededSuffix => ' · 需要时吃';

	/// zh: '这一顿好像忘了。想起来就点下面的"补上"。'
	String get missedDoseHint => '这一顿好像忘了。想起来就点下面的"补上"。';

	/// zh: '吃了'
	String get taken => '吃了';

	/// zh: '这次不吃'
	String get skip => '这次不吃';

	/// zh: '补上'
	String get catchUp => '补上';

	/// zh: '点错了？撤销'
	String get undo => '点错了？撤销';

	/// zh: '补记'
	String get catchUpSource => '补记';

	/// zh: 'AI 帮忙记的'
	String get aiSource => 'AI 帮忙记的';

	/// zh: '语音记的'
	String get voiceSource => '语音记的';

	/// zh: '${arg1} ${arg2} 记上的${arg3}'
	String recordedAt({required Object arg1, required Object arg2, required Object arg3}) => '${arg1} ${arg2} 记上的${arg3}';

	/// zh: '记上了！${arg1}，${arg2}，${arg3}${arg4}。'
	String recorded({required Object arg1, required Object arg2, required Object arg3, required Object arg4}) => '记上了！${arg1}，${arg2}，${arg3}${arg4}。';

	/// zh: '这次不吃了？'
	String get skipTitle => '这次不吃了？';

	/// zh: '${arg1} ${arg2}这次先不吃了。医生交代不能停的药，别跳过哦。'
	String skipMessage({required Object arg1, required Object arg2}) => '${arg1} ${arg2}这次先不吃了。医生交代不能停的药，别跳过哦。';

	/// zh: '改回"待吃"了。'
	String get undone => '改回"待吃"了。';
}

// Path: common
class Translations$common$zh {
	Translations$common$zh._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '网络有点慢，过一会儿再试试。'
	String get timeout => '网络有点慢，过一会儿再试试。';

	/// zh: '网络不太好，过会儿再问我。'
	String get networkError => '网络不太好，过会儿再问我。';

	/// zh: '还差一步：告诉我用哪个 AI。去"设置 → AI 模型"，跟着例子填一下就好。'
	String get modelMissing => '还差一步：告诉我用哪个 AI。去"设置 → AI 模型"，跟着例子填一下就好。';

	/// zh: '这个模型不会干这个，换一个模型试试。'
	String get capabilityMissing => '这个模型不会干这个，换一个模型试试。';

	/// zh: '模型那边回了错，检查一下地址、密钥、模型名。'
	String get modelError => '模型那边回了错，检查一下地址、密钥、模型名。';

	/// zh: '它说的话我没看懂，再问一次试试。'
	String get parseError => '它说的话我没看懂，再问一次试试。';

	/// zh: '问得太快啦，歇一会儿再来。'
	String get rateLimited => '问得太快啦，歇一会儿再来。';

	/// zh: '填的内容有点不对，检查一下再保存。'
	String get validationError => '填的内容有点不对，检查一下再保存。';

	/// zh: '数据出了点问题，重启一下 App 试试。'
	String get databaseError => '数据出了点问题，重启一下 App 试试。';

	/// zh: '出了点小状况，再试一次。'
	String get unknownError => '出了点小状况，再试一次。';

	/// zh: '减少${arg1}'
	String decrease({required Object arg1}) => '减少${arg1}';

	/// zh: '增加${arg1}'
	String increase({required Object arg1}) => '增加${arg1}';

	/// zh: '马上就好…'
	String get loading => '马上就好…';

	/// zh: '再试一次'
	String get retry => '再试一次';

	/// zh: '撤销'
	String get undo => '撤销';

	/// zh: '确定'
	String get confirm => '确定';

	/// zh: '先不'
	String get cancel => '先不';

	/// zh: '字号'
	String get fontSize => '字号';

	/// zh: '中'
	String get standardBadge => '中';

	/// zh: '特'
	String get extraLargeBadge => '特';

	/// zh: '大'
	String get largeBadge => '大';

	/// zh: '语言 / Language'
	String get language => '语言 / Language';

	/// zh: '选择界面和提醒使用的语言'
	String get languageHint => '选择界面和提醒使用的语言';

	/// zh: '简体中文'
	String get chinese => '简体中文';

	/// zh: 'English'
	String get english => 'English';

	/// zh: '语言已更改，但提醒更新失败。请稍后重新测试提醒。'
	String get languageFailed => '语言已更改，但提醒更新失败。请稍后重新测试提醒。';
}

// Path: units
class Translations$units$zh {
	Translations$units$zh._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '片'
	String get tablet => '片';

	/// zh: '粒'
	String get capsule => '粒';

	/// zh: '毫升'
	String get ml => '毫升';

	/// zh: '喷'
	String get spray => '喷';

	/// zh: '支'
	String get vial => '支';

	/// zh: '贴'
	String get patch => '贴';

	/// zh: '${amount}${unit}'
	String dose({required Object amount, required Object unit}) => '${amount}${unit}';

	/// zh: '(one) {${amount}片} (other) {${amount}片}'
	String tabletCount({required num n, required Object amount}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(n,
		one: '${amount}片',
		other: '${amount}片',
	);

	/// zh: '(one) {${amount}粒} (other) {${amount}粒}'
	String capsuleCount({required num n, required Object amount}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(n,
		one: '${amount}粒',
		other: '${amount}粒',
	);

	/// zh: '(one) {${amount}喷} (other) {${amount}喷}'
	String sprayCount({required num n, required Object amount}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(n,
		one: '${amount}喷',
		other: '${amount}喷',
	);

	/// zh: '(one) {${amount}支} (other) {${amount}支}'
	String vialCount({required num n, required Object amount}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(n,
		one: '${amount}支',
		other: '${amount}支',
	);

	/// zh: '(one) {${amount}贴} (other) {${amount}贴}'
	String patchCount({required num n, required Object amount}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(n,
		one: '${amount}贴',
		other: '${amount}贴',
	);
}

// Path: notifications
class Translations$notifications$zh {
	Translations$notifications$zh._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '吃药提醒'
	String get channelName => '吃药提醒';

	/// zh: '到点提醒吃药，响铃加语音播报'
	String get channelDescription => '到点提醒吃药，响铃加语音播报';
}

// Path: time
class Translations$time$zh {
	Translations$time$zh._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '今天'
	String get today => '今天';

	/// zh: '明天'
	String get tomorrow => '明天';

	/// zh: '昨天'
	String get yesterday => '昨天';

	/// zh: '刚刚'
	String get justNow => '刚刚';

	/// zh: '马上'
	String get soon => '马上';

	/// zh: '过了 ${count} 分钟'
	String minutesAgo({required Object count}) => '过了 ${count} 分钟';

	/// zh: '${count} 分钟后'
	String minutesFromNow({required Object count}) => '${count} 分钟后';

	/// zh: '${hours} 小时'
	String hours({required Object hours}) => '${hours} 小时';

	/// zh: '${hours} 小时 ${minutes} 分'
	String hoursMinutes({required Object hours, required Object minutes}) => '${hours} 小时 ${minutes} 分';

	/// zh: '过了 ${duration}'
	String ago({required Object duration}) => '过了 ${duration}';

	/// zh: '${duration} 后'
	String fromNow({required Object duration}) => '${duration} 后';

	/// zh: '凌晨'
	String get earlyMorning => '凌晨';

	/// zh: '早上'
	String get morning => '早上';

	/// zh: '上午'
	String get lateMorning => '上午';

	/// zh: '中午'
	String get noon => '中午';

	/// zh: '下午'
	String get afternoon => '下午';

	/// zh: '晚上'
	String get evening => '晚上';

	/// zh: '${period} ${hour} 点'
	String onHour({required Object period, required Object hour}) => '${period} ${hour} 点';

	/// zh: '${period} ${hour} 点半'
	String halfHour({required Object period, required Object hour}) => '${period} ${hour} 点半';

	/// zh: '${period} ${hour} 点 ${minute} 分'
	String withMinutes({required Object period, required Object hour, required Object minute}) => '${period} ${hour} 点 ${minute} 分';

	/// zh: '${month} 月 ${day} 日'
	String date({required Object month, required Object day}) => '${month} 月 ${day} 日';
}

// Path: weekdays
class Translations$weekdays$zh {
	Translations$weekdays$zh._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '周一'
	String get mon => '周一';

	/// zh: '周二'
	String get tue => '周二';

	/// zh: '周三'
	String get wed => '周三';

	/// zh: '周四'
	String get thu => '周四';

	/// zh: '周五'
	String get fri => '周五';

	/// zh: '周六'
	String get sat => '周六';

	/// zh: '周日'
	String get sun => '周日';
}

// Path: ai
class Translations$ai$zh {
	Translations$ai$zh._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: 'AI 说的仅供参考，吃药请听医生的。'
	String get disclaimer => 'AI 说的仅供参考，吃药请听医生的。';

	/// zh: '请用简体中文回答。'
	String get responseLanguage => '请用简体中文回答。';
}

// Path: enums
class Translations$enums$zh {
	Translations$enums$zh._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final Translations$enums$medicationForm$zh medicationForm = Translations$enums$medicationForm$zh._(_root);
	late final Translations$enums$medicationStatus$zh medicationStatus = Translations$enums$medicationStatus$zh._(_root);
	late final Translations$enums$medicationSource$zh medicationSource = Translations$enums$medicationSource$zh._(_root);
	late final Translations$enums$frequencyType$zh frequencyType = Translations$enums$frequencyType$zh._(_root);
	late final Translations$enums$scheduleStatus$zh scheduleStatus = Translations$enums$scheduleStatus$zh._(_root);
	late final Translations$enums$mealRelation$zh mealRelation = Translations$enums$mealRelation$zh._(_root);
	late final Translations$enums$doseStatus$zh doseStatus = Translations$enums$doseStatus$zh._(_root);
	late final Translations$enums$markSource$zh markSource = Translations$enums$markSource$zh._(_root);
	late final Translations$enums$modelUsage$zh modelUsage = Translations$enums$modelUsage$zh._(_root);
	late final Translations$enums$draftSource$zh draftSource = Translations$enums$draftSource$zh._(_root);
	late final Translations$enums$draftStatus$zh draftStatus = Translations$enums$draftStatus$zh._(_root);
	late final Translations$enums$chatRole$zh chatRole = Translations$enums$chatRole$zh._(_root);
}

// Path: enums.medicationForm
class Translations$enums$medicationForm$zh {
	Translations$enums$medicationForm$zh._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '片剂'
	String get tablet => '片剂';

	/// zh: '胶囊'
	String get capsule => '胶囊';

	/// zh: '口服液'
	String get liquid => '口服液';

	/// zh: '贴膏'
	String get patch => '贴膏';

	/// zh: '喷剂'
	String get spray => '喷剂';

	/// zh: '注射'
	String get injection => '注射';

	/// zh: '其他'
	String get other => '其他';
}

// Path: enums.medicationStatus
class Translations$enums$medicationStatus$zh {
	Translations$enums$medicationStatus$zh._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '在用'
	String get active => '在用';

	/// zh: '已停用'
	String get archived => '已停用';
}

// Path: enums.medicationSource
class Translations$enums$medicationSource$zh {
	Translations$enums$medicationSource$zh._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '手动录入'
	String get manual => '手动录入';

	/// zh: '拍照识别'
	String get aiPhoto => '拍照识别';
}

// Path: enums.frequencyType
class Translations$enums$frequencyType$zh {
	Translations$enums$frequencyType$zh._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '每天'
	String get daily => '每天';

	/// zh: '每周几天'
	String get weekdays => '每周几天';

	/// zh: '隔几天'
	String get intervalDays => '隔几天';

	/// zh: '按需要'
	String get asNeeded => '按需要';
}

// Path: enums.scheduleStatus
class Translations$enums$scheduleStatus$zh {
	Translations$enums$scheduleStatus$zh._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '进行中'
	String get active => '进行中';

	/// zh: '已暂停'
	String get paused => '已暂停';
}

// Path: enums.mealRelation
class Translations$enums$mealRelation$zh {
	Translations$enums$mealRelation$zh._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '餐前'
	String get before => '餐前';

	/// zh: '餐中'
	String get with_ => '餐中';

	/// zh: '餐后'
	String get after => '餐后';
}

// Path: enums.doseStatus
class Translations$enums$doseStatus$zh {
	Translations$enums$doseStatus$zh._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '待服'
	String get pending => '待服';

	/// zh: '已服'
	String get taken => '已服';

	/// zh: '已跳过'
	String get skipped => '已跳过';

	/// zh: '漏服'
	String get missed => '漏服';
}

// Path: enums.markSource
class Translations$enums$markSource$zh {
	Translations$enums$markSource$zh._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '手动点击'
	String get tap => '手动点击';

	/// zh: '通知按钮'
	String get notification => '通知按钮';

	/// zh: '语音'
	String get voice => '语音';

	/// zh: 'AI 代办'
	String get ai => 'AI 代办';

	/// zh: '补记'
	String get catchUp => '补记';
}

// Path: enums.modelUsage
class Translations$enums$modelUsage$zh {
	Translations$enums$modelUsage$zh._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '对话'
	String get chat => '对话';

	/// zh: '看图'
	String get vision => '看图';

	/// zh: '对话+看图'
	String get both => '对话+看图';
}

// Path: enums.draftSource
class Translations$enums$draftSource$zh {
	Translations$enums$draftSource$zh._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '拍照'
	String get photo => '拍照';

	/// zh: '对话'
	String get chat => '对话';
}

// Path: enums.draftStatus
class Translations$enums$draftStatus$zh {
	Translations$enums$draftStatus$zh._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '待确认'
	String get pending => '待确认';

	/// zh: '已保存'
	String get confirmed => '已保存';

	/// zh: '已放弃'
	String get discarded => '已放弃';
}

// Path: enums.chatRole
class Translations$enums$chatRole$zh {
	Translations$enums$chatRole$zh._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '我'
	String get user => '我';

	/// zh: 'CarePill'
	String get assistant => 'CarePill';

	/// zh: '工具'
	String get tool => '工具';
}
