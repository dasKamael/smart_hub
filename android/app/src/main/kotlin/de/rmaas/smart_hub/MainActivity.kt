package de.rmaas.smart_hub

import android.content.ComponentName
import android.content.Intent
import android.content.pm.ApplicationInfo
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.graphics.Canvas
import android.os.Handler
import android.os.Looper
import android.provider.Settings
import java.io.ByteArrayOutputStream
import java.util.concurrent.Executors
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
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "smart_hub/apps").setMethodCallHandler { call, result ->
            when (call.method) {
                // Icons take a moment to render; off the main thread so the UI keeps running.
                "installedApps" -> background.execute {
                    val apps = installedApps()
                    mainHandler.post { result.success(apps) }
                }
                "launch" -> {
                    val intent = call.argument<String>("package")?.let { packageManager.getLaunchIntentForPackage(it) }
                    intent?.let { startActivity(it.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)) }
                    result.success(intent != null)
                }
                else -> result.notImplemented()
            }
        }
    }

    private val background = Executors.newSingleThreadExecutor()
    private val mainHandler = Handler(Looper.getMainLooper())

    /** Apps with a launcher entry, except the hub: package, name, whether it declares itself a video app, icon. */
    private fun installedApps(): List<Map<String, Any>> {
        val launcher = Intent(Intent.ACTION_MAIN).addCategory(Intent.CATEGORY_LAUNCHER)
        return packageManager.queryIntentActivities(launcher, 0)
            .map { it.activityInfo.applicationInfo }
            .filter { it.packageName != packageName }
            .distinctBy { it.packageName }
            .map { info ->
                mapOf(
                    "package" to info.packageName,
                    "label" to packageManager.getApplicationLabel(info).toString(),
                    "isVideo" to (info.category == ApplicationInfo.CATEGORY_VIDEO),
                    "icon" to iconOf(info),
                )
            }
    }

    private fun iconOf(info: ApplicationInfo): ByteArray {
        val size = 144
        val bitmap = Bitmap.createBitmap(size, size, Bitmap.Config.ARGB_8888)
        packageManager.getApplicationIcon(info).apply {
            setBounds(0, 0, size, size)
            draw(Canvas(bitmap))
        }
        return ByteArrayOutputStream().also { bitmap.compress(Bitmap.CompressFormat.PNG, 100, it) }.toByteArray()
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
