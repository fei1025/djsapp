package com.example.flutterplu_demo.glance

import HomeWidgetGlanceState
import HomeWidgetGlanceStateDefinition
import android.content.Context
import android.net.Uri
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.glance.Button
import androidx.glance.GlanceId
import androidx.glance.GlanceModifier
import androidx.glance.appwidget.GlanceAppWidget
import androidx.glance.appwidget.action.actionRunCallback
import androidx.glance.appwidget.provideContent
import androidx.glance.background
import androidx.glance.currentState
import androidx.glance.layout.Alignment
import androidx.glance.layout.Box
import androidx.glance.layout.Column
import androidx.glance.layout.Row
import androidx.glance.layout.Spacer
import androidx.glance.layout.fillMaxHeight
import androidx.glance.layout.fillMaxSize
import androidx.glance.layout.fillMaxWidth
import androidx.glance.layout.height
import androidx.glance.layout.padding
import androidx.glance.layout.size
import androidx.glance.layout.width
import androidx.glance.state.GlanceStateDefinition
import androidx.glance.text.FontWeight
import androidx.glance.text.Text
import androidx.glance.text.TextStyle
import es.antonborri.home_widget.actionStartActivity
import com.example.flutterplu_demo.MainActivity

class AppWidget : GlanceAppWidget() {

    override val stateDefinition: GlanceStateDefinition<*>?
        get() = HomeWidgetGlanceStateDefinition()

    override suspend fun provideGlance(context: Context, id: GlanceId) {
        provideContent {
            GlanceContent(context, currentState())
        }
    }

    @Composable
    private fun GlanceContent(context: Context, currentState: HomeWidgetGlanceState) {
        val prefs = currentState.preferences
        val counter = prefs.getInt("counter", 0)
        val message = "";
        Column(
            modifier = GlanceModifier.fillMaxSize()
        ) {
            // 第一行：标题和 + 按钮
            Row(
                modifier = GlanceModifier.fillMaxWidth().background(Color.White),
                verticalAlignment = Alignment.CenterVertically // 修正为垂直对齐
            ) {
                Text(
                    text = "标题",
                    style = TextStyle(fontSize = 18.sp, fontWeight = FontWeight.Bold),
                    modifier = GlanceModifier.defaultWeight() // 左侧标题占用剩余空间
                )
                Spacer(modifier = GlanceModifier.width(8.dp)) // 可选：标题和按钮之间的间距

                Button(
                    text = "+",
                    onClick = actionStartActivity<MainActivity>(
                        context,
                        Uri.parse("homeWidgetExample://{'type':'addTime'}")
                    ), // 点击启动主页面
                    modifier = GlanceModifier.size(40.dp)
                )
            }
            Box(
                modifier = GlanceModifier
                    .fillMaxWidth().fillMaxHeight().padding(8.dp)
                    .background(Color.White.copy(alpha = 0.5f))
            ) {
                val maxButtonsPerRow = 5 // 每行最多显示的按钮数量

                // 按钮部分：手动换行
                val dataList = listOf("按钮1", "按钮2", "按钮3", "按钮4", "按钮5") // 示例数据
                dataList.chunked(maxButtonsPerRow).forEach { rowButtons ->
                    Row(
                        modifier = GlanceModifier.fillMaxWidth(),
                        horizontalAlignment = Alignment.Start
                    ) {
                        rowButtons.forEach { item ->
                            Button(
                                text = item,
                                onClick = actionStartActivity<MainActivity>(
                                    context,
                                    Uri.parse("homeWidgetExample://message?message=$item")
                                ),
                                modifier = GlanceModifier.padding(4.dp)
                            )
                        }
                    }
                    Spacer(modifier = GlanceModifier.height(8.dp)) // 行间距
                }
            }

        }
    }
}



