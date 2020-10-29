package org.mcg.diabetes

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.plugin.common.PluginRegistry


class MainActivity: FlutterActivity() {
    fun registerWith(registry: PluginRegistry) {
        GeneratedPluginRegistrant.registerWith(registry as FlutterEngine)
    }
}
