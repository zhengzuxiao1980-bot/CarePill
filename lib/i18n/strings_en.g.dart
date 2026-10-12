///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'strings.g.dart';

// Path: <root>
class TranslationsEn with BaseTranslations<AppLocale, Translations> implements Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsEn({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  _meta = meta ?? TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  );

	/// Metadata for the translations of <en>.
	final TranslationMetadata<AppLocale, Translations> _meta;
	@override TranslationMetadata<AppLocale, Translations> get $meta => _meta;

	late final TranslationsEn _root = this; // ignore: unused_field

	@override
	TranslationsEn $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsEn(meta: meta ?? this.$meta);

	// Translations
	@override late final _Translations$barcode$en barcode = _Translations$barcode$en._(_root);
	@override late final _Translations$agentV2$en agentV2 = _Translations$agentV2$en._(_root);
	@override late final _Translations$ruleIntent$en ruleIntent = _Translations$ruleIntent$en._(_root);
	@override late final _Translations$toolRegistry$en toolRegistry = _Translations$toolRegistry$en._(_root);
	@override late final _Translations$modelsController$en modelsController = _Translations$modelsController$en._(_root);
	@override late final _Translations$stats$en stats = _Translations$stats$en._(_root);
	@override late final _Translations$agentService$en agentService = _Translations$agentService$en._(_root);
	@override late final _Translations$modelSetup$en modelSetup = _Translations$modelSetup$en._(_root);
	@override late final _Translations$modelSelection$en modelSelection = _Translations$modelSelection$en._(_root);
	@override late final _Translations$reminderScheduler$en reminderScheduler = _Translations$reminderScheduler$en._(_root);
	@override late final _Translations$speechService$en speechService = _Translations$speechService$en._(_root);
	@override late final _Translations$deviceChannel$en deviceChannel = _Translations$deviceChannel$en._(_root);
	@override late final _Translations$assistant$en assistant = _Translations$assistant$en._(_root);
	@override late final _Translations$cabinet$en cabinet = _Translations$cabinet$en._(_root);
	@override late final _Translations$draftConfirm$en draftConfirm = _Translations$draftConfirm$en._(_root);
	@override late final _Translations$medicationDetail$en medicationDetail = _Translations$medicationDetail$en._(_root);
	@override late final _Translations$medicationForm$en medicationForm = _Translations$medicationForm$en._(_root);
	@override late final _Translations$photoCapture$en photoCapture = _Translations$photoCapture$en._(_root);
	@override late final _Translations$onboarding$en onboarding = _Translations$onboarding$en._(_root);
	@override late final _Translations$about$en about = _Translations$about$en._(_root);
	@override late final _Translations$modelEdit$en modelEdit = _Translations$modelEdit$en._(_root);
	@override late final _Translations$modelManage$en modelManage = _Translations$modelManage$en._(_root);
	@override late final _Translations$romGuide$en romGuide = _Translations$romGuide$en._(_root);
	@override late final _Translations$settings$en settings = _Translations$settings$en._(_root);
	@override late final _Translations$appShell$en appShell = _Translations$appShell$en._(_root);
	@override late final _Translations$appTheme$en appTheme = _Translations$appTheme$en._(_root);
	@override late final _Translations$reminderFullscreen$en reminderFullscreen = _Translations$reminderFullscreen$en._(_root);
	@override late final _Translations$today$en today = _Translations$today$en._(_root);
	@override late final _Translations$common$en common = _Translations$common$en._(_root);
	@override late final _Translations$units$en units = _Translations$units$en._(_root);
	@override late final _Translations$notifications$en notifications = _Translations$notifications$en._(_root);
	@override late final _Translations$time$en time = _Translations$time$en._(_root);
	@override late final _Translations$weekdays$en weekdays = _Translations$weekdays$en._(_root);
	@override late final _Translations$ai$en ai = _Translations$ai$en._(_root);
	@override late final _Translations$enums$en enums = _Translations$enums$en._(_root);
}

// Path: barcode
class _Translations$barcode$en implements Translations$barcode$zh {
	_Translations$barcode$en._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Scan';
	@override String get entry => 'Add by barcode';
	@override String get coverage => 'Free lookup using openFDA, mainly covering the US market. Other medicines may not be found. You can use a photo or enter details manually. No AI setup required.';
	@override String get privacy => 'Codes are scanned on your phone. Only the product barcode is sent to openFDA; photos, traceability codes, batches and serial numbers are not sent.';
	@override String get sdkPrivacy => 'On Android, Google ML Kit processes images on the device and may send usage and performance diagnostics.';
	@override String get scan => 'Scan with camera';
	@override String get aim => 'Point at the product barcode, or a QR code containing a product identifier.';
	@override String get cameraError => 'Camera unavailable. Allow camera access in system settings, or go back to enter the barcode digits.';
	@override String get cameraUnsupported => 'Camera scanning is unavailable on this device. Enter the barcode digits instead.';
	@override String get manual => 'Or enter barcode digits';
	@override String get hint => '8, 12, 13 or 14 digit product barcode';
	@override String get lookup => 'Look up medicine';
	@override String get loading => 'Looking up medicine…';
	@override String get notFound => 'No matching medicine found. This free source has limited coverage; this does not mean the medicine is invalid. Check the code or try another way to add it below.';
	@override String get invalid => 'The barcode length or check digit is incorrect. Scan again or check the digits.';
	@override String get unsupported => 'This code has no supported product identifier. Scan the product barcode; ordinary website QR codes are not supported.';
	@override String get traceability => 'This is a 20 digit traceability code. The free source cannot look it up. Find the product barcode on the box, or use a photo or manual entry.';
	@override String get network => 'Could not connect. Check your network and retry, or add the medicine manually.';
	@override String get timeout => 'Lookup timed out. Try again later, or add the medicine manually.';
	@override String get rateLimited => 'The free service has reached its request limit. Try later, or use another way to add your medicine.';
	@override String get unavailable => 'The medicine lookup service is unavailable. Try later, or add the medicine manually.';
	@override String get results => 'Check against your medicine box';
	@override String get review => 'This information is for data entry, not proof of approval or authenticity. Check the name, maker and strength. A barcode cannot determine your dose or schedule.';
	@override String generic({required Object value}) => 'Generic name: ${value}';
	@override String manufacturer({required Object value}) => 'Manufacturer: ${value}';
	@override String get source => 'Source: openFDA (US drug labels)';
	@override String get use => 'Review details';
	@override String get prefill => 'The name was filled from barcode data. Check the form, dose unit and strength, then set your dose and schedule as prescribed. No timed reminders are set by default.';
	@override String get missingUnit => 'Enter the actual dose unit, such as tablet, capsule or mL.';
	@override String get choose => 'Multiple codes found. Choose one';
	@override String code({required Object value}) => 'Product barcode: ${value}';
}

// Path: agentV2
class _Translations$agentV2$en implements Translations$agentV2$zh {
	_Translations$agentV2$en._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get memories => 'Saved memories';
	@override String get remembered => 'Remembered';
	@override String get memoryDeleted => 'Memory forgotten';
	@override String get memoryEmpty => 'No saved memories yet';
	@override String get memorySource => 'User reported';
	@override String get memoryConflict => 'Please specify which memory to change or forget.';
	@override String get explicitOnly => 'I only change long-term memories when you explicitly ask me to remember, correct, or forget something.';
	@override String get invalidArgs => 'Some details are missing or invalid. Please clarify.';
	@override String get ambiguous => 'Several records match. Please specify the medicine, date and scheduled time.';
	@override String get notFound => 'No matching record found.';
	@override String get committed => 'The action was completed, but I could not finish the reply. You can review or undo it.';
	@override String get undoConflict => 'This record has changed since that action. Please review its current state before changing it.';
	@override String get undo => 'Undo';
	@override String get reviewDraft => 'Review draft';
	@override String get retry => 'Retry';
	@override String get cancel => 'Cancel';
	@override String get save => 'Save';
	@override String get delete => 'Delete';
	@override String get deleteAll => 'Delete all memories';
	@override String get edit => 'Edit';
	@override String get clearHint => 'Chat and conversation summaries will be cleared. Saved memories and dose records will be kept.';
	@override String get hold => 'Hold to speak';
	@override String get recording => 'Listening. Release to send; slide up to cancel.';
	@override String get cancelRecording => 'Release to cancel';
	@override String get finalizing => 'Finishing recognition…';
	@override String get tooShort => 'Recording was too short. Hold and try again.';
	@override String get maxRecording => 'Recording limit reached. Release to send.';
	@override String get noSpeech => 'No speech detected. Please try again.';
	@override String get speechUnavailable => 'No speech service is available. Please use the keyboard.';
	@override String get permissionDenied => 'Allow microphone and speech recognition access in system settings.';
	@override String get languageMissing => 'Install speech support for this language in system settings.';
	@override String get speechFailed => 'Recognition failed. Your text was kept so you can edit and send it.';
	@override String get ttsFailed => 'Audio is unavailable. You can read the reply on screen.';
	@override String get contextWindow => 'Context window (tokens)';
	@override String get contextTooLong => 'This exceeds the model context limit. Shorten the text or adjust the model window setting.';
	@override String get authFailed => 'The model key is invalid or lacks permission. Check model settings.';
	@override String get cancelled => 'Cancelled';
	@override String get loadEarlier => 'Load earlier messages';
	@override String get thinking => 'Replying…';
	@override String get syncFailed => 'The record was saved, but reminder sync is pending. Please retry later.';
	@override String get memoryBody => 'What to remember';
	@override String get confirmDeleteMemories => 'Delete saved memories? Chat and dose records will be kept.';
	@override String get speechSettings => 'Speech and permission settings';
	@override String get preparing => 'Preparing microphone…';
	@override String get speaking => 'Reading the reply…';
}

// Path: ruleIntent
class _Translations$ruleIntent$en implements Translations$ruleIntent$zh {
	_Translations$ruleIntent$en._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String statusReply({required Object arg1}) => 'Here is what I found: ${arg1}.';
	@override String get noSchedule => 'I could not find any medication scheduled today.';
	@override String get allDone => 'All of today\'s doses are recorded. There is no next dose.';
	@override String nextReply({required Object arg2, required Object arg1}) => 'Your next dose is ${arg2} at ${arg1}. I will remind you.';
	@override String get recordedReply => 'Recorded! You can tell me whenever you forget to tap the button.';
	@override String get acknowledged => 'Okay, I have recorded that.';
}

// Path: toolRegistry
class _Translations$toolRegistry$en implements Translations$toolRegistry$zh {
	_Translations$toolRegistry$en._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String statusSummary({required Object arg1, required Object arg2, required Object arg3, required Object arg4}) => '${arg1} doses: ${arg2} taken, ${arg3} missed, ${arg4} pending';
	@override String get allDone => 'No more pending doses today';
	@override String get recordingWindow => 'Only today\'s and yesterday\'s doses can be recorded here. Use Today for earlier doses.';
	@override String noPending({required Object arg1}) => 'No pending doses for ${arg1} today (they may already be recorded)';
	@override String recorded({required Object arg1}) => 'Recorded (${arg1})';
	@override String get skipped => 'Recorded as skipped';
	@override String get draftSaved => 'Saved as a draft. Please review it before saving.';
	@override String draftCreated({required Object arg1}) => 'Created a draft for “${arg1}”. Open it to review and save.';
}

// Path: modelsController
class _Translations$modelsController$en implements Translations$modelsController$zh {
	_Translations$modelsController$en._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get missingConfig => 'Configuration not found';
	@override String get missingKey => 'No API key yet';
}

// Path: stats
class _Translations$stats$en implements Translations$stats$zh {
	_Translations$stats$en._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String emptySummary({required Object arg1}) => 'No medication was scheduled in these ${arg1} days.';
	@override String summary({required Object arg1, required Object arg2, required Object arg3, required Object arg4, required Object arg5}) => 'Over ${arg1} days, ${arg2} doses were scheduled, ${arg3} were recorded and ${arg4} were missed. Adherence: ${arg5}%.';
	@override String get title => 'Medication calendar';
	@override String get lastWeek => 'Last 7 days';
	@override String get empty => 'No medication scheduled yet';
	@override String get lastMonth => 'Last 30 days (green: all taken, yellow: skipped, red: missed)';
	@override String daySummary({required Object arg1, required Object arg2, required Object arg3, required Object arg4}) => '${arg1}/${arg2}: ${arg3}/${arg4}';
	@override String get weeklyReport => 'Create a weekly report for family';
	@override String get setupModel => 'First add a model in Settings → AI models.';
	@override String get close => 'Close';
	@override String get missedTitle => 'Missed doses (last 7 days)';
	@override String get missedHint => 'If you missed a dose, do not take two doses together. Follow your prescriber\'s missed-dose instructions.';
	@override String notTaken({required Object arg1}) => '${arg1} not taken';
}

// Path: agentService
class _Translations$agentService$en implements Translations$agentService$zh {
	_Translations$agentService$en._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get tryLater => 'Please give me a moment and ask again.';
	@override String get notUnderstood => 'I did not understand. Could you say that another way?';
	@override String get noSchedule => 'No medication scheduled today';
}

// Path: modelSetup
class _Translations$modelSetup$en implements Translations$modelSetup$zh {
	_Translations$modelSetup$en._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get provider => 'Choose a provider';
	@override String get connect => 'Connect to the provider';
	@override String get model => 'Choose a model';
	@override String get finish => 'Test and finish';
	@override String progress({required Object step}) => 'Step ${step} of 4';
	@override String get next => 'Next';
	@override String get other => 'Other options';
	@override String get custom => 'Custom compatible service';
	@override String get intro => 'Choose an AI service first. We will help you set it up one step at a time.';
	@override String get chooseProvider => 'Please choose a provider first.';
	@override String get getKey => 'Get an API key';
	@override String get keySteps => '1. Open the provider website and sign in\n2. Create an API key\n3. Copy it, then return here to paste it';
	@override String get cost => 'AI services may charge for usage. Check the provider\'s pricing and your account balance.';
	@override String get openWebsite => 'Open official key page';
	@override String get copyUrl => 'Copy website address';
	@override String get copied => 'Address copied';
	@override String get openFailed => 'Could not open a browser. Copy the address to open it yourself.';
	@override String get paste => 'Paste API key';
	@override String get emptyClipboard => 'The clipboard has no text yet.';
	@override String get showKey => 'Show key';
	@override String get hideKey => 'Hide key';
	@override String get storedKey => 'Key saved; leave blank to keep it';
	@override String get enterKey => 'Enter the API key from your provider.';
	@override String get keyChanged => 'After changing the provider or address, enter its API key again.';
	@override String get localHint => 'Ollama does not need an API key. To connect your phone to Ollama on a computer, enter the computer\'s local network address, such as http://192.168.1.10:11434/v1. Both devices must share a network, and Ollama must allow network access. 127.0.0.1 means this device only.';
	@override String get customHint => 'Enter the OpenAI-compatible address and API key from your provider. Include the required path, such as /v1, but not /chat/completions.';
	@override String get invalidUrl => 'Enter a full http:// or https:// address without spaces, credentials, query parameters or #.';
	@override String get recommended => 'Recommended';
	@override String get customModel => 'Enter another model ID';
	@override String get modelHint => 'A recommended model is selected for you. You can also choose another one.';
	@override String get chat => 'Can chat';
	@override String get vision => 'Can recognize medicine photos';
	@override String get chatOnly => 'Can chat; photo recognition is not enabled in this preset';
	@override String get unknown => 'Use the model ID supplied by your provider. Unknown models start with chat only; adjust capabilities in advanced settings.';
	@override String get advanced => 'Advanced settings';
	@override String get temperature => 'Response randomness (optional)';
	@override String get invalidBudget => 'Context must be at least 2048. Output must be a positive integer, with at least 2048 tokens left in the context.';
	@override String get test => 'Test connection';
	@override String get testing => 'Testing connection…';
	@override String get save => 'Save and finish';
	@override String get saveLater => 'Save now, test later';
	@override String get saving => 'Saving…';
	@override String get review => 'Check these details, then test the connection. The test sends a short message, without your medication information.';
	@override String get notTested => 'Connection not tested';
	@override String get connected => 'Connected and ready to save';
	@override String get testFailed => 'Could not connect yet';
	@override String get visionUntested => 'This test checks the chat connection only. Photo recognition has not been tested.';
	@override String get savedUntested => 'Configuration saved. You can test the connection later.';
	@override String get savedConnected => 'Configuration saved and connection tested successfully.';
	@override String get loadFailed => 'Could not load this configuration. Go back and try again.';
	@override String get authError => 'The key is invalid or lacks access. Go back to check it or create a new key.';
	@override String get networkError => 'Could not connect. Check your network and service address, then retry.';
	@override String get timeoutError => 'The connection timed out. Check your network and try again later.';
	@override String get quotaError => 'Too many requests or not enough credit. Check your account on the provider\'s website and try later.';
	@override String get configError => 'Check the service address and model ID, and confirm it supports OpenAI-compatible chat.';
}

// Path: modelSelection
class _Translations$modelSelection$en implements Translations$modelSelection$zh {
	_Translations$modelSelection$en._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get connected => 'Connected';
	@override String connectionFailed({required Object arg1}) => 'Could not connect: ${arg1}';
	@override String get visionReady => 'Image recognition works';
	@override String visionFailed({required Object arg1}) => 'Image recognition failed: ${arg1}';
	@override String get timeout => 'Timed out. Check the address or try again later.';
	@override String get offline => 'Cannot connect. Check the address and network.';
	@override String networkError({required Object arg1}) => 'Network error: ${arg1}';
	@override String get invalidConfig => 'Check the address, API key and model name.';
	@override String get rateLimited => 'Request or usage limit reached.';
	@override String modelError({required Object arg1}) => 'Unexpected model response: ${arg1}';
	@override String unknownError({required Object arg1}) => 'Something went wrong: ${arg1}';
}

// Path: reminderScheduler
class _Translations$reminderScheduler$en implements Translations$reminderScheduler$zh {
	_Translations$reminderScheduler$en._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get dueTitle => 'Time for your medication';
	@override String snoozedBody({required Object arg1}) => 'Not recorded yet: ${arg1}';
	@override String get testTitle => 'Test reminder';
	@override String get testBody => 'This is how you will be reminded. If you can hear it, the setup is working.';
	@override String dueBody({required Object arg1}) => 'Time for your medication (${arg1} medications)';
	@override String get unrecordedTitle => 'Your dose is not recorded yet';
	@override String unrecordedBody({required Object arg1}) => '${arg1} medications from the last reminder are not recorded. Tap to check.';
}

// Path: speechService
class _Translations$speechService$en implements Translations$speechService$zh {
	_Translations$speechService$en._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String announcement({required Object arg1, required Object arg2}) => 'It is ${arg1}. Time to take ${arg2}.';
}

// Path: deviceChannel
class _Translations$deviceChannel$en implements Translations$deviceChannel$zh {
	_Translations$deviceChannel$en._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get xiaomiTitle => 'Xiaomi phone setup';
	@override String get huaweiTitle => 'Huawei / Honor phone setup';
	@override String get oppoTitle => 'OPPO phone setup';
	@override String get vivoTitle => 'vivo phone setup';
	@override String get title => 'Phone setup guide';
	@override String get autoStart => '1. Allow auto-start: find CarePill in your phone manager and enable auto-start.';
	@override String get battery => '2. Set battery usage to “Unrestricted” or disable battery restrictions for CarePill.';
	@override String get notifications => '3. Allow notifications, including notifications on the lock screen.';
	@override String get xiaomiHint => 'On Xiaomi phones, set CarePill to unrestricted in battery settings.';
}

// Path: assistant
class _Translations$assistant$en implements Translations$assistant$zh {
	_Translations$assistant$en._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get quickStatus => 'Did I take my medicine today?';
	@override String get quickNext => 'What is my next dose?';
	@override String get quickUsage => 'How do I take this medicine?';
	@override String get notHeard => 'I could not hear you. Hold the microphone and try again.';
	@override String get heardTitle => 'You said:';
	@override String get cancel => 'Cancel';
	@override String get send => 'Send';
	@override String get title => 'AI Assistant';
	@override String get clearTooltip => 'Clear conversation';
	@override String get clearTitle => 'Clear this conversation?';
	@override String get clearMessage => 'All messages in this conversation will be deleted.';
	@override String get clear => 'Clear';
	@override String get welcome => 'Ask me anything';
	@override String get available => 'Here for you';
	@override String listening({required Object arg1}) => 'Listening: ${arg1}';
	@override String get setupTitle => 'One more step: choose an AI model';
	@override String get setupHint => 'A family member can help you follow the examples. You can still manage medication manually.';
	@override String get addModel => 'Add a model';
	@override String get emptyTitle => 'I am here to help';
	@override String get emptyHint => '“Did I take my medicine today?” “What is my next dose?”\nHold the microphone below to speak, or type a message.';
	@override String get correct => 'That\'s not right';
	@override String get correctionPrefix => 'That\'s not right, ';
	@override String get inputHint => 'Ask a question…';
	@override String get undo => 'Undo';
}

// Path: cabinet
class _Translations$cabinet$en implements Translations$cabinet$zh {
	_Translations$cabinet$en._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Medicines';
	@override String get emptyTitle => 'Your medicine cabinet is empty';
	@override String get emptyHint => 'Enter details, scan a product barcode, or use a photo of the medicine box.';
	@override String get add => 'Add a medicine';
	@override String get activeTitle => 'Current medicines';
	@override String count({required Object arg1}) => '${arg1} medications';
	@override String get noSchedule => 'No doses scheduled';
	@override String get addTitle => 'How would you like to add it?';
	@override String get manual => 'Enter manually';
	@override String get photoUncertain => 'Scan a box (image support is unverified)';
	@override String get photo => 'Scan a medicine box';
	@override String get photoSetup => 'Set up an image model to scan a box';
}

// Path: draftConfirm
class _Translations$draftConfirm$en implements Translations$draftConfirm$zh {
	_Translations$draftConfirm$en._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Review medicine details';
	@override String get save => 'Looks right, save';
	@override String get uncertainName => 'The name is unclear. Please check it.';
	@override String get name => 'Medicine name';
	@override String get form => 'Medicine form';
	@override String get unit => 'Unit (tablet / capsule / mL)';
	@override String get spec => 'Strength / package size (optional)';
	@override String get uncertainTime => 'Dose times are unclear. Please check them.';
	@override String get times => 'Recognized dose times';
	@override String get noTimes => 'No dose times were recognized. Add times in Edit after saving, or leave it unscheduled.';
	@override String get removeTime => 'Remove this time';
	@override String get originalText => 'Original instructions (check against the photo)';
	@override String get reviewHint => 'Check the details before saving. Correct any text that was misread.';
	@override String get missingName => 'Please enter a medicine name.';
	@override String get savedScheduled => 'Saved! I will remind you when it is time.';
	@override String get savedUnscheduled => 'Saved. To set reminders, add times in Edit.';
}

// Path: medicationDetail
class _Translations$medicationDetail$en implements Translations$medicationDetail$zh {
	_Translations$medicationDetail$en._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get notFound => 'Medicine not found';
	@override String get title => 'Medicine details';
	@override String get form => 'Form';
	@override String get spec => 'Strength / package size';
	@override String get perDose => 'Dose unit';
	@override String get notes => 'Notes';
	@override String get photoHint => 'This medicine was added from a photo. Check the details before use.';
	@override String get times => 'When to take it';
	@override String get noSchedule => 'No schedule yet. Tap Edit below to add one.';
	@override String get pause => 'Pause';
	@override String get resume => 'Resume';
	@override String get edit => 'Edit';
	@override String get archive => 'Archive medicine';
	@override String get reactivate => 'Reactivate medicine';
	@override String get resumed => 'Resumed. Reminders are on.';
	@override String get paused => 'Paused. Reminders are off.';
	@override String archiveTitle({required Object arg1}) => 'Archive “${arg1}”?';
	@override String get archiveMessage => 'Reminders will stop. Your history will be kept, and you can reactivate it later.';
	@override String get archiveConfirm => 'Archive';
	@override String get done => 'Done.';
}

// Path: medicationForm
class _Translations$medicationForm$en implements Translations$medicationForm$zh {
	_Translations$medicationForm$en._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get editTitle => 'Edit medicine';
	@override String addTitle({required Object arg1}) => 'Add medicine (${arg1} of 3)';
	@override String get next => 'Next';
	@override String get missingName => 'Give the medicine a name, such as “Blood pressure pill”.';
	@override String get missingTime => 'Keep at least one dose time.';
	@override String get save => 'Save';
	@override String get saveChanges => 'Save changes';
	@override String get nameLabel => 'What is this medicine called?';
	@override String get nameHint => 'For example: blood pressure pill / amlodipine';
	@override String get formLabel => 'What form is it?';
	@override String get unitLabel => 'Dose unit';
	@override String get unitHint => 'tablet / capsule / mL';
	@override String get specLabel => 'Strength / package size (optional)';
	@override String get specHint => '5 mg × 30 tablets';
	@override String get notesLabel => 'Doctor\'s instructions (optional)';
	@override String get notesHint => 'For example: do not stop taking it';
	@override String get frequencyLabel => 'When do you take it?';
	@override String get daily => 'Every day';
	@override String get weekdays => 'Selected weekdays';
	@override String get interval => 'Every few days';
	@override String get asNeeded => 'As needed';
	@override String get intervalLabel => 'How many days between doses?';
	@override String get intervalDays => 'Days between doses';
	@override String days({required Object arg1}) => '${arg1} days';
	@override String get addTime => 'Add a time';
	@override String get mealLabel => 'Before or after meals?';
	@override String get mealAny => 'No preference';
	@override String get asNeededHint => 'As-needed medicines have no reminders. Tap them on Today whenever you want to record a dose.';
	@override String weeklySummary({required Object arg1}) => 'Every week: ${arg1}';
	@override String intervalSummary({required Object arg1}) => 'Every ${arg1} days';
	@override String get asNeededSummary => 'Take as needed';
	@override String get reviewTitle => 'Check the details';
	@override String reviewSummary({required Object arg1, required Object arg2, required Object arg3, required Object arg4, required Object arg5, required Object arg6, required Object arg7}) => '${arg1} (${arg2})\nUnit: ${arg3}${arg4}\n${arg5}${arg6}${arg7}';
	@override String specSummary({required Object arg1}) => ', ${arg1}';
	@override String get reviewHint => 'After saving, you will get reminders for any times you have set.';
	@override String get saved => 'Saved!';
	@override String doseTime({required Object arg1}) => 'Dose ${arg1}: time';
	@override String get doseAmount => 'Amount for this dose';
	@override String doseNumber({required Object arg1}) => 'Dose ${arg1}: amount';
	@override String get removeTime => 'Remove this time';
}

// Path: photoCapture
class _Translations$photoCapture$en implements Translations$photoCapture$zh {
	_Translations$photoCapture$en._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get setupFirst => 'Add a working AI model before scanning a medicine box.';
	@override String get unverifiedTitle => 'This model may not support images';
	@override String get unverifiedMessage => 'This model is set up for conversation. Image recognition may fail. You can also add medicines manually.';
	@override String get cancel => 'Cancel';
	@override String get continueScan => 'Try anyway';
	@override String get invalidPhoto => 'There is a problem with this photo. Please take another one.';
	@override String get blurryPhoto => 'The photo is too blurry to read. Try again a little closer.';
	@override String get failed => 'Recognition failed. Please try again.';
	@override String get unnamedMedicine => 'this medicine';
	@override String get recognizedTitle => 'Medicine recognized';
	@override String recognizedMessage({required Object arg1}) => 'This looks like “${arg1}”.\nCheck every detail and correct any mistakes before saving.';
	@override String get discard => 'Discard';
	@override String get review => 'Review details';
	@override String get title => 'Scan medicine';
	@override String get loading => 'Reading the photo…';
	@override String get photoTitle => 'Photograph the text on the box';
	@override String get photoHint => 'Use good light and move closer.\nI will read it, then you can check the details.';
	@override String get camera => 'Take a photo';
	@override String get gallery => 'Choose from photos';
	@override String get unverifiedHint => 'Image support is unverified. Please confirm before continuing.';
	@override String get draftHint => 'Recognized information stays a draft until you review and save it.';
}

// Path: onboarding
class _Translations$onboarding$en implements Translations$onboarding$zh {
	_Translations$onboarding$en._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get welcome => 'Helping you remember every dose.\nI will remind you when it is time. Ask me if you forget whether you took it.';
	@override String get start => 'Get started';
	@override String get modelTitle => 'Step 1: Choose an AI model';
	@override String get modelHint => 'A family member can help set this up once. You can skip it and still use reminders and manual records. Add AI later anytime.';
	@override String get requirements => 'Four steps to get connected:';
	@override String get requirementsHint => 'Choose a provider → Get an API key → Choose a model → Test and save.\n\nCommon service addresses and models are filled in for you. No technical experience needed.';
	@override String get addModel => 'Add a model';
	@override String get skip => 'Skip for now';
	@override String get medicineTitle => 'Step 2: Add your first medicine';
	@override String get modelReady => 'Your AI configuration is saved. Add medicine manually, or scan the box when the connection is available.';
	@override String get manualHint => 'Enter the medicine name, dose times and amount per dose.';
	@override String get manual => 'Add manually';
	@override String get photoUncertain => 'Scan a box (image support is unverified)';
	@override String get photo => 'Scan a medicine box';
	@override String get photoSetup => 'Set up an image model to scan a box';
	@override String get finish => 'Explore the app first';
}

// Path: about
class _Translations$about$en implements Translations$about$zh {
	_Translations$about$en._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Privacy and disclaimer';
	@override String get dataTitle => 'Where is your data?';
	@override String get dataBody => 'CarePill has no account or sign-in. Your medicines, dose records and conversations are stored only on this phone. We cannot access them.';
	@override String get aiTitle => 'Who provides the AI answers?';
	@override String get aiBody => 'Answers come from the AI service you configure. Your questions and photos are sent to that provider and are subject to its privacy policy. API keys stay in your phone\'s secure storage and are not uploaded or exported unless you explicitly request it.';
	@override String get adviceTitle => 'Can you rely on everything AI says?';
	@override String get adviceBody => 'No. AI answers are for reference. Follow your doctor\'s instructions.\n\n• Information read from photos is a draft and must be checked before saving.\n• Ask a doctor or pharmacist before changing a dose, switching medicines or stopping treatment.\n• For chest pain, trouble breathing or a fall, seek urgent medical care or call your local emergency number.';
	@override String get remindersTitle => 'Reminders are not guaranteed';
	@override String get remindersBody => 'Some phones restrict background apps, which can delay reminders. Follow Settings → Phone setup guide, then use Test reminder to check.';
}

// Path: modelEdit
class _Translations$modelEdit$en implements Translations$modelEdit$zh {
	_Translations$modelEdit$en._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String deepseekHint({required Object apiKeysUrl}) => 'Supports chat, images and tool calls. Get an API key at ${apiKeysUrl}';
	@override String deepseekProHint({required Object apiKeysUrl}) => 'Supports chat and tool calls, without image input. Get an API key at ${apiKeysUrl}';
	@override String get deepseekUpdateTitle => 'Update your DeepSeek configuration';
	@override String deepseekUpdateHint({required Object model}) => 'This model ID has been retired. Switch to ${model} for chat and medicine box recognition, then tap Save.';
	@override String get deepseekUpdate => 'Fill in current DeepSeek settings';
	@override String get qwenName => 'Qwen (DashScope compatible)';
	@override String get qwenHint => 'Get an API key from the Alibaba Cloud Model Studio console';
	@override String get kimiName => 'Kimi (Moonshot)';
	@override String get kimiHint => 'Get an API key at platform.moonshot.cn';
	@override String get glmName => 'GLM';
	@override String get glmHint => 'Get an API key at open.bigmodel.cn';
	@override String get openrouterName => 'OpenRouter';
	@override String get openrouterHint => 'Get an API key at openrouter.ai';
	@override String get ollamaName => 'Local Ollama';
	@override String get ollamaHint => 'Run Ollama locally. Enter ollama as the API key.';
	@override String get addTitle => 'Add model';
	@override String get editTitle => 'Edit model';
	@override String get save => 'Save';
	@override String get examples => 'Provider examples (tap to fill)';
	@override String get fill => 'Use this';
	@override String get nameLabel => 'Display name';
	@override String get nameHint => 'For example: Family DeepSeek';
	@override String get urlLabel => 'API address (usually ending in /v1)';
	@override String get keyLabel => 'API key';
	@override String get keyUnchangedLabel => 'API key (leave blank to keep it)';
	@override String get modelLabel => 'Model name';
	@override String get usage => 'Use for';
	@override String get vision => 'Supports images';
	@override String get visionHint => 'For scanning medicine photos';
	@override String get tools => 'Supports function calling';
	@override String get toolsHint => 'Lets AI record doses. Leave on if unsure; a fallback is available.';
	@override String get defaultChat => 'Use as default chat model';
	@override String get maxTokens => 'Response limit (tokens, optional)';
	@override String get maxTokensHint => 'For example: 500';
	@override String get keyPrivacy => 'Keys stay in this phone\'s secure storage. They are not uploaded or exported unless you explicitly request it.';
	@override String get requiredFields => 'Enter a display name, API address and model name.';
	@override String get requiredKey => 'Enter an API key (use ollama for local Ollama).';
	@override String get saved => 'Saved. Tap Test connection to check it works.';
}

// Path: modelManage
class _Translations$modelManage$en implements Translations$modelManage$zh {
	_Translations$modelManage$en._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'AI models';
	@override String get emptyTitle => 'No AI models yet';
	@override String get emptyHint => 'Use DeepSeek, Qwen, Kimi, GLM, OpenRouter or local Ollama. Follow an example to enter the address, API key and model name.';
	@override String get add => 'Add a model';
	@override String get hint => 'Set a default chat model for the AI assistant. Models with image support can also scan medicine boxes.';
	@override String get defaultChat => 'Default chat';
	@override String summary({required Object arg1, required Object arg2, required Object arg3}) => '${arg1} · ${arg2} · Key: ${arg3}';
	@override String get keySet => 'set';
	@override String get keyMissing => 'missing';
	@override String get test => 'Test connection';
	@override String get edit => 'Edit';
	@override String get delete => 'Delete';
	@override String get setDefault => 'Use as default chat model';
	@override String connected({required Object arg1}) => 'Connected! ${arg1}';
	@override String deleteTitle({required Object arg1}) => 'Delete “${arg1}”?';
	@override String get deleteMessage => 'The configuration and API key will both be deleted.';
}

// Path: romGuide
class _Translations$romGuide$en implements Translations$romGuide$zh {
	_Translations$romGuide$en._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get intro => 'Battery-saving features may stop reminder apps. Follow these three steps to help reminders arrive on time.';
	@override String get batteryHint => 'CarePill is still subject to battery optimization. Open settings below to allow it.';
	@override String get permissions => 'Reminder permissions';
	@override String get notifications => 'Notifications';
	@override String get exactAlarms => 'Exact alarms';
	@override String get fullScreen => 'Full-screen lock screen reminders';
	@override String get batteryAllowed => 'Battery optimization disabled';
	@override String get disableBattery => 'Disable battery optimization';
	@override String get enableNotifications => 'Allow notifications';
	@override String get returnHint => 'Return here after changing the setting.';
	@override String get enableAlarms => 'Allow exact alarms';
	@override String get testHint => 'After setup, go back to Settings and use Test reminder to check that it works.';
	@override String permissionStatus({required Object arg1, required Object arg2}) => '${arg1}: ${arg2}';
	@override String get allowed => 'Allowed';
	@override String get notAllowed => 'Not allowed';
}

// Path: settings
class _Translations$settings$en implements Translations$settings$zh {
	_Translations$settings$en._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Settings';
	@override String get intro => 'Make CarePill work for you';
	@override String get display => 'Display';
	@override String get fontSize => 'Text size';
	@override String get standard => 'Standard';
	@override String get large => 'Large';
	@override String get extraLarge => 'Extra large';
	@override String get reminders => 'Reminders';
	@override String get leadTime => 'Remind me in advance';
	@override String get minutes => 'min';
	@override String get repeatCount => 'Repeat if unacknowledged';
	@override String get times => 'times';
	@override String get repeatInterval => 'Repeat interval';
	@override String get gracePeriod => 'Mark missed after';
	@override String get quietTitle => 'Quiet hours (not active yet)';
	@override String get quietHint => 'As-needed medicines currently follow normal notification rules. This preference is saved but does not affect reminders yet.';
	@override String get reminderHint => 'Missing reminders? Try Test reminder below, then follow the setup guide for your phone.';
	@override String get testing => 'Sending…';
	@override String get testReminder => 'Test reminder now';
	@override String get phoneGuide => 'Phone setup guide';
	@override String get speech => 'Speech';
	@override String get tts => 'Read reminders aloud';
	@override String get ttsHint => 'Speak when a dose is due';
	@override String get speechRate => 'Speech speed';
	@override String get slow => 'Slow';
	@override String get fast => 'Fast';
	@override String get normal => 'Normal';
	@override String get preview => 'Listen to a sample';
	@override String get speechSample => 'It is time for your blood pressure medicine. Take one tablet.';
	@override String get models => 'AI models';
	@override String get modelsHint => 'Choose a provider and follow the steps to connect your own AI. Keys stay on this device. You can save now and test later.';
	@override String get manageModels => 'Manage models';
	@override String get data => 'Data';
	@override String get stats => 'Medication calendar and statistics';
	@override String get exportBackup => 'Export backup (JSON)';
	@override String get restoreBackup => 'Restore backup (replaces current data)';
	@override String get exportLogs => 'Export logs for family';
	@override String get onboarding => 'View the welcome guide again';
	@override String get about => 'About';
	@override String get privacy => 'Privacy and disclaimer';
	@override String get aboutHint => 'CarePill v1.0.0 · No account · Data stays on this device\nAI answers are generated by your chosen service and are subject to its privacy policy.';
	@override String get testSent => 'Test reminder sent. If you can see or hear it, it works. Otherwise, open Phone setup guide.';
	@override String backupSaved({required Object arg1}) => 'Backup created without API keys: ${arg1}';
	@override String get restoreTitle => 'Restore a backup?';
	@override String get restoreMessage => 'This replaces your current medicines, schedules and dose records with the backup. Continue?';
	@override String get restore => 'Restore';
	@override String get backupFile => 'Backup file';
	@override String get restored => 'Restored. Tasks and reminders have been updated.';
	@override String get logsDisabled => 'Logging is disabled (development mode)';
	@override String logsPath({required Object arg1}) => 'Logs are saved at: ${arg1}';
}

// Path: appShell
class _Translations$appShell$en implements Translations$appShell$zh {
	_Translations$appShell$en._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get today => 'Today';
	@override String get cabinet => 'Meds';
	@override String get assistant => 'AI';
	@override String get settings => 'Setup';
}

// Path: appTheme
class _Translations$appTheme$en implements Translations$appTheme$zh {
	_Translations$appTheme$en._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get taken => 'Taken';
	@override String get missed => 'Missed';
	@override String get skipped => 'Skipped';
	@override String get pending => 'Pending';
}

// Path: reminderFullscreen
class _Translations$reminderFullscreen$en implements Translations$reminderFullscreen$zh {
	_Translations$reminderFullscreen$en._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String doseDescription({required Object arg2, required Object arg1, required Object arg3}) => '${arg2} at ${arg1}, ${arg3} per dose';
	@override String announcement({required Object arg1, required Object arg2, required Object arg3}) => 'It is ${arg1}. Time for ${arg2}: ${arg3}.';
	@override String get medicine => 'your medication';
	@override String get title => 'Time for your medication';
	@override String get alreadyRecorded => 'These doses have already been recorded.\nTap Back at the top left to return.';
	@override String get taken => 'Taken';
	@override String get allTaken => 'All taken';
	@override String get snooze => 'Remind me later';
	@override String get skip => 'Skip today';
	@override String partialFailure({required Object arg1}) => 'A dose could not be recorded: ${arg1}';
	@override String recorded({required Object arg1}) => 'Recorded! ${arg1} doses saved.';
	@override String get snoozed => 'Okay, I will remind you again later.';
	@override String get skipTitle => 'Skip today\'s dose?';
	@override String get skipMessage => 'Try to follow your doctor\'s schedule. Are you sure you want to skip this dose?';
	@override String get skipConfirm => 'Skip dose';
}

// Path: today
class _Translations$today$en implements Translations$today$zh {
	_Translations$today$en._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'CarePill · Today';
	@override String get emptyTitle => 'No medication scheduled today';
	@override String get emptyHint => 'Add a medicine and dose times in Medicines. I will remind you when it is time.';
	@override String get add => 'Add a medicine';
	@override String get today => 'Today';
	@override String get tagline => 'On time, with peace of mind';
	@override String get nextDose => 'Next dose';
	@override String missedHint({required Object arg1}) => '${arg1} doses may have been missed. Use Record dose to update your log. Never take two doses together.';
	@override String doseSummary({required Object arg1, required Object arg2, required Object arg3}) => '${arg1}${arg2}${arg3}';
	@override String get asNeededSuffix => ' · As needed';
	@override String get missedDoseHint => 'This dose may have been missed. Tap Record dose below to update your log.';
	@override String get taken => 'Taken';
	@override String get skip => 'Skip dose';
	@override String get catchUp => 'Record dose';
	@override String get undo => 'Tapped by mistake? Undo';
	@override String get catchUpSource => 'Late entry';
	@override String get aiSource => 'Recorded by AI';
	@override String get voiceSource => 'Recorded by voice';
	@override String recordedAt({required Object arg1, required Object arg2, required Object arg3}) => 'Recorded ${arg1} at ${arg2}${arg3}';
	@override String recorded({required Object arg1, required Object arg2, required Object arg3, required Object arg4}) => 'Recorded! ${arg1}, ${arg2}, ${arg3}${arg4}.';
	@override String get skipTitle => 'Skip this dose?';
	@override String skipMessage({required Object arg2, required Object arg1}) => 'Skip ${arg2} at ${arg1}? Do not skip medicines your doctor has told you to take regularly.';
	@override String get undone => 'Changed back to Pending.';
}

// Path: common
class _Translations$common$en implements Translations$common$zh {
	_Translations$common$en._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get timeout => 'The network is slow. Try again in a moment.';
	@override String get networkError => 'There is a connection problem. Please try again later.';
	@override String get modelMissing => 'Choose an AI model first. Go to Settings → AI models and follow an example.';
	@override String get capabilityMissing => 'This model cannot do that. Try another model.';
	@override String get modelError => 'The model returned an error. Check the address, API key and model name.';
	@override String get parseError => 'I could not understand the response. Please ask again.';
	@override String get rateLimited => 'Too many requests. Please wait a moment.';
	@override String get validationError => 'Some details are not valid. Check them before saving.';
	@override String get databaseError => 'There is a data problem. Try restarting the app.';
	@override String get unknownError => 'Something went wrong. Please try again.';
	@override String decrease({required Object arg1}) => 'Decrease ${arg1}';
	@override String increase({required Object arg1}) => 'Increase ${arg1}';
	@override String get loading => 'Just a moment…';
	@override String get retry => 'Try again';
	@override String get undo => 'Undo';
	@override String get confirm => 'Confirm';
	@override String get cancel => 'Not now';
	@override String get fontSize => 'Text size';
	@override String get standardBadge => 'M';
	@override String get extraLargeBadge => 'XL';
	@override String get largeBadge => 'L';
	@override String get language => 'Language / 语言';
	@override String get languageHint => 'App and reminder language';
	@override String get chinese => '简体中文';
	@override String get english => 'English';
	@override String get languageFailed => 'Language changed, but reminders could not be updated. Please test reminders again later.';
}

// Path: units
class _Translations$units$en implements Translations$units$zh {
	_Translations$units$en._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get tablet => 'tablet';
	@override String get capsule => 'capsule';
	@override String get ml => 'mL';
	@override String get spray => 'spray';
	@override String get vial => 'vial';
	@override String get patch => 'patch';
	@override String dose({required Object amount, required Object unit}) => '${amount} ${unit}';
	@override String tabletCount({required num n, required Object amount}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n,
		one: '${amount} tablet',
		other: '${amount} tablets',
	);
	@override String capsuleCount({required num n, required Object amount}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n,
		one: '${amount} capsule',
		other: '${amount} capsules',
	);
	@override String sprayCount({required num n, required Object amount}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n,
		one: '${amount} spray',
		other: '${amount} sprays',
	);
	@override String vialCount({required num n, required Object amount}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n,
		one: '${amount} vial',
		other: '${amount} vials',
	);
	@override String patchCount({required num n, required Object amount}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n,
		one: '${amount} patch',
		other: '${amount} patches',
	);
}

// Path: notifications
class _Translations$notifications$en implements Translations$notifications$zh {
	_Translations$notifications$en._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get channelName => 'Medication reminders';
	@override String get channelDescription => 'Reminders when medication is due, with sound and speech';
}

// Path: time
class _Translations$time$en implements Translations$time$zh {
	_Translations$time$en._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get today => 'Today';
	@override String get tomorrow => 'Tomorrow';
	@override String get yesterday => 'Yesterday';
	@override String get justNow => 'Just now';
	@override String get soon => 'Now';
	@override String minutesAgo({required Object count}) => '${count} min ago';
	@override String minutesFromNow({required Object count}) => 'In ${count} min';
	@override String hours({required Object hours}) => '${hours} hr';
	@override String hoursMinutes({required Object hours, required Object minutes}) => '${hours} hr ${minutes} min';
	@override String ago({required Object duration}) => '${duration} ago';
	@override String fromNow({required Object duration}) => 'In ${duration}';
	@override String get earlyMorning => 'early morning';
	@override String get morning => 'morning';
	@override String get lateMorning => 'morning';
	@override String get noon => 'noon';
	@override String get afternoon => 'afternoon';
	@override String get evening => 'evening';
	@override String onHour({required Object hour, required Object period}) => '${hour} ${period}';
	@override String halfHour({required Object hour, required Object period}) => '${hour}:30 ${period}';
	@override String withMinutes({required Object hour, required Object minute, required Object period}) => '${hour}:${minute} ${period}';
	@override String date({required Object month, required Object day}) => '${month}/${day}';
}

// Path: weekdays
class _Translations$weekdays$en implements Translations$weekdays$zh {
	_Translations$weekdays$en._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get mon => 'Monday';
	@override String get tue => 'Tuesday';
	@override String get wed => 'Wednesday';
	@override String get thu => 'Thursday';
	@override String get fri => 'Friday';
	@override String get sat => 'Saturday';
	@override String get sun => 'Sunday';
}

// Path: ai
class _Translations$ai$en implements Translations$ai$zh {
	_Translations$ai$en._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get disclaimer => 'AI answers are for reference. Follow your doctor\'s instructions.';
	@override String get responseLanguage => 'Respond in English. Keep medication names exactly as entered. Express times naturally in English. For emergencies, refer to the local emergency number rather than assuming a country.';
}

// Path: enums
class _Translations$enums$en implements Translations$enums$zh {
	_Translations$enums$en._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override late final _Translations$enums$medicationForm$en medicationForm = _Translations$enums$medicationForm$en._(_root);
	@override late final _Translations$enums$medicationStatus$en medicationStatus = _Translations$enums$medicationStatus$en._(_root);
	@override late final _Translations$enums$medicationSource$en medicationSource = _Translations$enums$medicationSource$en._(_root);
	@override late final _Translations$enums$frequencyType$en frequencyType = _Translations$enums$frequencyType$en._(_root);
	@override late final _Translations$enums$scheduleStatus$en scheduleStatus = _Translations$enums$scheduleStatus$en._(_root);
	@override late final _Translations$enums$mealRelation$en mealRelation = _Translations$enums$mealRelation$en._(_root);
	@override late final _Translations$enums$doseStatus$en doseStatus = _Translations$enums$doseStatus$en._(_root);
	@override late final _Translations$enums$markSource$en markSource = _Translations$enums$markSource$en._(_root);
	@override late final _Translations$enums$modelUsage$en modelUsage = _Translations$enums$modelUsage$en._(_root);
	@override late final _Translations$enums$draftSource$en draftSource = _Translations$enums$draftSource$en._(_root);
	@override late final _Translations$enums$draftStatus$en draftStatus = _Translations$enums$draftStatus$en._(_root);
	@override late final _Translations$enums$chatRole$en chatRole = _Translations$enums$chatRole$en._(_root);
}

// Path: enums.medicationForm
class _Translations$enums$medicationForm$en implements Translations$enums$medicationForm$zh {
	_Translations$enums$medicationForm$en._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get tablet => 'Tablet';
	@override String get capsule => 'Capsule';
	@override String get liquid => 'Oral liquid';
	@override String get patch => 'Patch';
	@override String get spray => 'Spray';
	@override String get injection => 'Injection';
	@override String get other => 'Other';
}

// Path: enums.medicationStatus
class _Translations$enums$medicationStatus$en implements Translations$enums$medicationStatus$zh {
	_Translations$enums$medicationStatus$en._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get active => 'Active';
	@override String get archived => 'Archived';
}

// Path: enums.medicationSource
class _Translations$enums$medicationSource$en implements Translations$enums$medicationSource$zh {
	_Translations$enums$medicationSource$en._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get manual => 'Manual entry';
	@override String get aiPhoto => 'Photo scan';
}

// Path: enums.frequencyType
class _Translations$enums$frequencyType$en implements Translations$enums$frequencyType$zh {
	_Translations$enums$frequencyType$en._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get daily => 'Every day';
	@override String get weekdays => 'Selected weekdays';
	@override String get intervalDays => 'Every few days';
	@override String get asNeeded => 'As needed';
}

// Path: enums.scheduleStatus
class _Translations$enums$scheduleStatus$en implements Translations$enums$scheduleStatus$zh {
	_Translations$enums$scheduleStatus$en._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get active => 'Active';
	@override String get paused => 'Paused';
}

// Path: enums.mealRelation
class _Translations$enums$mealRelation$en implements Translations$enums$mealRelation$zh {
	_Translations$enums$mealRelation$en._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get before => 'Before meals';
	@override String get with_ => 'With meals';
	@override String get after => 'After meals';
}

// Path: enums.doseStatus
class _Translations$enums$doseStatus$en implements Translations$enums$doseStatus$zh {
	_Translations$enums$doseStatus$en._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get pending => 'Pending';
	@override String get taken => 'Taken';
	@override String get skipped => 'Skipped';
	@override String get missed => 'Missed';
}

// Path: enums.markSource
class _Translations$enums$markSource$en implements Translations$enums$markSource$zh {
	_Translations$enums$markSource$en._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get tap => 'Tap';
	@override String get notification => 'Notification button';
	@override String get voice => 'Voice';
	@override String get ai => 'AI';
	@override String get catchUp => 'Late entry';
}

// Path: enums.modelUsage
class _Translations$enums$modelUsage$en implements Translations$enums$modelUsage$zh {
	_Translations$enums$modelUsage$en._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get chat => 'Chat';
	@override String get vision => 'Images';
	@override String get both => 'Chat and images';
}

// Path: enums.draftSource
class _Translations$enums$draftSource$en implements Translations$enums$draftSource$zh {
	_Translations$enums$draftSource$en._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get photo => 'Photo';
	@override String get chat => 'Chat';
}

// Path: enums.draftStatus
class _Translations$enums$draftStatus$en implements Translations$enums$draftStatus$zh {
	_Translations$enums$draftStatus$en._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get pending => 'Pending review';
	@override String get confirmed => 'Saved';
	@override String get discarded => 'Discarded';
}

// Path: enums.chatRole
class _Translations$enums$chatRole$en implements Translations$enums$chatRole$zh {
	_Translations$enums$chatRole$en._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get user => 'Me';
	@override String get assistant => 'CarePill';
	@override String get tool => 'Tool';
}
