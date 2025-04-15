package com.example.flutterplu_demo

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
import com.example.flutterplu_demo.R
import es.antonborri.home_widget.HomeWidgetBackgroundIntent
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider
import android.net.Uri
import android.util.Log

class HomeWidgetExampleProvider : AppWidgetProvider() {
    private val TAG = "HomeWidgetProvider"

    private val buttonList = mutableListOf<Pair<String, Int>>()


    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {

        for (appWidgetId in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.example_layout)


            // 绑定 RemoteViewsService，设置数据
            val serviceIntent = Intent(context, WidgetService::class.java)
            views.setRemoteAdapter(R.id.widget_grid_view, serviceIntent)

            // 设置刷新按钮点击事件
            val refreshIntent = Intent(context, HomeWidgetExampleProvider::class.java).apply {
                action = "ACTION_REFRESH_WIDGET"
            }
            val refreshPendingIntent = PendingIntent.getBroadcast(
                context, 0, refreshIntent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )

            views.setOnClickPendingIntent(R.id.widget_o_button, refreshPendingIntent)



            val pendingIntentWithData =
                HomeWidgetLaunchIntent.getActivity(
                    context,
                    MainActivity::class.java,
                    Uri.parse("homeWidgetExample://message?message=aa"))

            views.setOnClickPendingIntent(R.id.widget_add_button, pendingIntentWithData)

            // 为 GridView 中的项目设置点击模板
            val gridItemIntent = Intent(context, MainActivity::class.java).apply {
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
                action = Intent.ACTION_VIEW
            }
            val gridItemPendingIntent = PendingIntent.getActivity(
                context,
                1, // 使用不同的请求码
                gridItemIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_MUTABLE
            )
            views.setPendingIntentTemplate(R.id.widget_grid_view, gridItemPendingIntent)

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)
        android.util.Log.d("回调函数", "onReceive:${intent.action} ")
        if (intent.action == "ACTION_REFRESH_WIDGET") {
            val appWidgetManager = AppWidgetManager.getInstance(context)
            android.util.Log.d("回调函数", "onReceive:点击了刷新按钮 ")
            val component = ComponentName(context, HomeWidgetExampleProvider::class.java)
            appWidgetManager.notifyAppWidgetViewDataChanged(
                appWidgetManager.getAppWidgetIds(component),
                R.id.widget_grid_view
            )
        }
        if (intent.action == "com.example.flutterplu_demo.BUTTON_CLICK") {
            val buttonId = intent.getIntExtra("button_id", -1)

        }

    }
}
