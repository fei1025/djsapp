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

class HomeWidgetExampleProvider : AppWidgetProvider() {

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
            views.setOnClickPendingIntent(R.id.widget_add_button, refreshPendingIntent)

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)
        if (intent.action == "ACTION_REFRESH_WIDGET") {
            val appWidgetManager = AppWidgetManager.getInstance(context)
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
