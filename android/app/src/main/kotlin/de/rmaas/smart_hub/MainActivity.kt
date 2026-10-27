package de.rmaas.smart_hub

import android.content.ComponentName
import android.content.Intent
import android.content.pm.PackageManager
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val homeAlias: ComponentName
        get() = ComponentName(this, "$packageName.HomeAlias")

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "smart_hub/kiosk").setMethodCallHandler { call, result ->
            when (call.method) {
                "isHomeApp" -> result.success(isHomeAliasEnabled())
                "setHomeApp" -> {
                    setHomeAliasEnabled(call.argument<Boolean>("enabled") == true)
                    result.success(null)
                }
                "openHomeSettings" -> {
                    startActivity(Intent(Settings.ACTION_HOME_SETTINGS).addFlags(Intent.FLAG_ACTIVITY_NEW_TASK))
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun isHomeAliasEnabled(): Boolean =
        packageManager.getComponentEnabledSetting(homeAlias) == PackageManager.COMPONENT_ENABLED_STATE_ENABLED

    private fun setHomeAliasEnabled(enabled: Boolean) {
        val state = if (enabled) {
            PackageManager.COMPONENT_ENABLED_STATE_ENABLED
        } else {
            PackageManager.COMPONENT_ENABLED_STATE_DISABLED
        }
        packageManager.setComponentEnabledSetting(homeAlias, state, PackageManager.DONT_KILL_APP)
    }
}
