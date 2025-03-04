package com.example.flutterplu_demo

import android.content.Intent
import android.widget.RemoteViewsService

class WidgetService : RemoteViewsService() {
    override fun onGetViewFactory(intent: Intent): RemoteViewsFactory {
        return WidgetFactory(this.applicationContext, intent)
    }
}
