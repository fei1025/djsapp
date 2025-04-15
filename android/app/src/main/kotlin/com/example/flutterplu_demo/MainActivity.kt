package com.example.flutterplu_demo

import android.content.Intent
import android.os.Bundle
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity(){
    private val TAG = "MainActivity"
    private val CHANNEL = "com.example.flutterplu_demo/widget_click"
    private var methodChannel: MethodChannel? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        Log.d(TAG, "onCreate1111111111111111111111: ${intent?.data}")

        // 处理从小组件启动
        handleIntent(intent)
    }
    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        Log.d(TAG, "onNewIntent333333333333333: ${intent.data}")
        setIntent(intent)
        handleIntent(intent)
        //homeWidgetExample://button?id=104&title=按钮4
        //homeWidgetExample://message?message=aa
    }


    private fun handleIntent(intent: Intent?) {
        if (intent == null) return

        // 获取 URI 数据
        val uri = intent.data
        Log.d(TAG, "handleIntent222222222222222222222222222: URI = $uri")

        if (uri != null) {
            // 通过 MethodChannel 发送数据到 Flutter
            val host = uri.host
            val params = uri.queryParameterNames.associateWith { uri.getQueryParameter(it) }

            Log.d(TAG, "URI Host: $host, Params: $params")
            methodChannel?.invokeMethod("widgetClicked", mapOf(
                "host" to host,
                "params" to params
            ))
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // 确保插件正确注册
        GeneratedPluginRegistrant.registerWith(flutterEngine)

        // 设置 MethodChannel
        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
    }

}


