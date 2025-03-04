package com.example.flutterplu_demo

import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
import android.widget.RemoteViewsService
import com.example.flutterplu_demo.R
import org.json.JSONArray
import org.json.JSONObject
import es.antonborri.home_widget.HomeWidgetBackgroundIntent
import android.net.Uri


class WidgetFactory(
    private val context: Context,
    intent: Intent
) : RemoteViewsService.RemoteViewsFactory {

    private val buttonList = mutableListOf<Pair<String, Int>>()

    override fun onCreate() {}

    override fun onDataSetChanged() {
        // 模拟动态按钮数据
        val prefs = context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE)
        val jsonString = prefs.getString("button_list", "[]")
        buttonList.clear()
        jsonString?.let {
            val jsonArray = JSONArray(it)
            for (i in 0 until jsonArray.length()) {
                val obj = jsonArray.getJSONObject(i)
                val title = obj.getString("title")
                val id = obj.getInt("id")
                buttonList.add(Pair(title, id))
            }
        }
    }

    override fun onDestroy() {
        buttonList.clear()
    }

    override fun getCount(): Int = buttonList.size

    override fun getViewAt(position: Int): RemoteViews {
        val (title, id) = buttonList[position]
        val views = RemoteViews(context.packageName, R.layout.widget_item)

        // 设置按钮的标题
        views.setTextViewText(R.id.widget_button, title)

        // 创建按钮点击事件，传递 id
        val clickIntent = Intent().apply {
            putExtra("button_id", id)
            action = "com.example.flutterplu_demo.BUTTON_CLICK"
        }
        val backgroundIntent =HomeWidgetBackgroundIntent.getBroadcast( context, Uri.parse("homeWidgetExample://$id"))

        views.setOnClickPendingIntent(R.id.widget_button, backgroundIntent)

        return views
    }

    override fun getLoadingView(): RemoteViews? = null
    override fun getViewTypeCount(): Int = 1
    override fun getItemId(position: Int): Long = position.toLong()
    override fun hasStableIds(): Boolean = true
}
