package com.eleven.game.libpluginutils.analytics;

import com.umeng.analytics.AnalyticsConfig;
import com.umeng.analytics.MobclickAgent;

import android.content.Context;

public class UmengAnalytics implements IAnalytics {
	
	private Context mContext;
	
	public UmengAnalytics(Context context) {
		mContext = context;
		MobclickAgent.updateOnlineConfig( mContext );
	}

	@Override
	public void setAppkey(String key) {
		AnalyticsConfig.setAppkey(key);

	}

	@Override
	public void onResume(Context context) {
		MobclickAgent.onResume(context);

	}

	@Override
	public void onPause(Context context) {
		MobclickAgent.onResume(context);
	}

}
