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
import androidx.glance.LocalSize
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






                // 获取当前可用宽度
                val availableWidthDp = LocalSize.current.width
                // 按钮宽度和间距定义
                val buttonWidth = 100.dp
                val spacing = 8.dp

                // 计算每行最多按钮数（至少1个）
                val maxPerRow = ((availableWidthDp ) / (buttonWidth )).toInt().coerceAtLeast(1)







                Text(
                    text = "标题",
                    style = TextStyle(fontSize = 18.sp, fontWeight = FontWeight.Bold),
                    modifier = GlanceModifier.defaultWeight() // 左侧标题占用剩余空间
                )
                Spacer(modifier = GlanceModifier.width(8.dp)) // 可选：标题和按钮之间的间距

                Button(
                    text = "+",
                    onClick = actionStartActivity<MainActivity>(
                        onClick =     actionStartActivity<MainActivity>(
                            context,
                            Uri.parse("homeWidgetExample://message?message={'type':'addTime'}")
                                    Uri.parse("homeWidgetExample://message?availableWidthDp=$availableWidthDp")
                        ), // 点击启动主页面
                        modifier = GlanceModifier.size(40.dp)
                    )
                            Button(
                            text = "o",
                    onClick =     actionStartActivity<MainActivity>(
                        context,
                        Uri.parse("homeWidgetExample://message?maxPerRow=$maxPerRow")
                    ), // 点击启动主页面
                    modifier = GlanceModifier.size(40.dp)
                )
            }


            Box(
                modifier = GlanceModifier
                    .fillMaxWidth().fillMaxHeight().padding(8.dp)
                        modifier = GlanceModifier.fillMaxWidth().fillMaxHeight().padding(8.dp)
                    .background(Color.White.copy(alpha = 0.5f))
            ) {
                val maxButtonsPerRow = 5 // 每行最多显示的按钮数量
                Column(
                    modifier = GlanceModifier.fillMaxSize()

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
                            ) {
                            val buttons = listOf("Button 1", "Button 2", "Button 3", "Button 4", "Button 5")
                            // 获取当前可用宽度
                            val availableWidthDp = LocalSize.current.width
                            // 按钮宽度和间距定义
                            val buttonWidth = 100.dp
                            val spacing = 5.dp
                            // 计算每行最多按钮数（至少1个）
                            val maxPerRow = ((availableWidthDp ) / (buttonWidth )).toInt().coerceAtLeast(1)
                            Spacer(modifier = GlanceModifier.height(3.dp)) // 行间距
                            buttons.chunked(maxPerRow).forEach { rowItems ->
                                Row(
                                    modifier = GlanceModifier.fillMaxWidth(),
                                ) {
                                    rowItems.forEachIndexed { index, item ->
                                        Button(
                                            text = item,
                                            onClick = actionStartActivity<MainActivity>(
                                                context,
                                                Uri.parse("homeWidgetExample://message?message=$maxPerRow")
                                            ),
                                            modifier = GlanceModifier.width(buttonWidth) // 设置按钮宽度为 200dp

                                        )
                                        Spacer(modifier = GlanceModifier.width(2.dp)) // 行间距
                                    }
                                }
                                Spacer(modifier = GlanceModifier.height(10.dp)) // 行间距
                            }
                            Spacer(modifier = GlanceModifier.height(8.dp)) // 行间距


                        }
                        }

                    }
                }
            }


