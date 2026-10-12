package com.carepill.app

import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.PowerManager
import android.provider.Settings
import android.app.NotificationManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

/// 轻量设备通道：ROM 保活引导（docs/06 §4）需要厂商名与系统设置直达。
/// 不引入额外依赖，系统能力直连。
class MainActivity : FlutterActivity() {
    private val channelName = "pillpal/device"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "manufacturer" -> result.success(Build.MANUFACTURER)
                    "ignoringBattery" -> result.success(isIgnoringBatteryOptimizations())
                    "fullScreenIntent" -> result.success(isFullScreenIntentEnabled())
                    "openBatterySettings" -> {
                        openBatteryOptimizationSettings()
                        result.success(null)
                    }
                    "openAlarmSettings" -> {
                        openExactAlarmSettings()
                        result.success(null)
                    }
                    "openNotificationSettings" -> {
                        openAppNotificationSettings()
                        result.success(null)
                    }
                    "openSpeechSettings" -> {
                        val permission = call.argument<Boolean>("permission") == true
                        val intent = if (permission) Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS).apply {
                            data = Uri.parse("package:${applicationContext.packageName}")
                        } else Intent(Settings.ACTION_SETTINGS)
                        startActivitySafely(intent)
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }
    }

    private fun isIgnoringBatteryOptimizations(): Boolean {
        val pm = getSystemService(Context.POWER_SERVICE) as PowerManager
        return pm.isIgnoringBatteryOptimizations(applicationContext.packageName)
    }

    private fun isFullScreenIntentEnabled(): Boolean {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.Q) {
            return true
        }
        val manager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        return manager.canUseFullScreenIntent()
    }

    private fun openBatteryOptimizationSettings() {
        val intent = Intent(Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS).apply {
            data = Uri.parse("package:${applicationContext.packageName}")
        }
        startActivitySafely(intent)
    }

    private fun openExactAlarmSettings() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            startActivitySafely(Intent(Settings.ACTION_REQUEST_SCHEDULE_EXACT_ALARM))
        }
    }

    private fun openAppNotificationSettings() {
        val intent = Intent(Settings.ACTION_APP_NOTIFICATION_SETTINGS).apply {
            putExtra(Settings.EXTRA_APP_PACKAGE, applicationContext.packageName)
        }
        startActivitySafely(intent)
    }

    private fun startActivitySafely(intent: Intent) {
        try {
            startActivity(intent)
        } catch (e: Exception) {
            android.util.Log.w("pillpal", "打开系统设置失败: ${intent.action}")
        }
    }
}
