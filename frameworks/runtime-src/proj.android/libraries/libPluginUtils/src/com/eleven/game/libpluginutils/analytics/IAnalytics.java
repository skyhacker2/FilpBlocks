package com.eleven.game.libpluginutils.analytics;

import android.content.Context;

public interface IAnalytics {
	
	void setAppkey(String key);
	
	void onResume(Context context);
	
	void onPause(Context context);

}
