package com.eleven.game.libpluginutils.facade;

import android.content.Context;
import android.widget.FrameLayout;

import com.eleven.game.libpluginutils.ads.IAdManager;
import com.eleven.game.libpluginutils.ads.YoumiAdManager;
import com.eleven.game.libpluginutils.analytics.IAnalytics;
import com.eleven.game.libpluginutils.analytics.UmengAnalytics;


public class Facade {
	public final static String TAG = Facade.class.getSimpleName();
	
	static Context mContext;
	
	static IAnalytics mAnalytics;
	
	static IAdManager mAdManager;
	
	static Utils utils;
	
	public static void init(Context context) {
		mAnalytics = new UmengAnalytics(context);
		utils = new Utils(context);
	}
	
	public static void setImageSavePath(String path) {
		utils.setImageSavePath(path);
	}
	
	public static void rateApp() {
		utils.rateApp();
	}
	
	public static void share(String text) {
		utils.share(text);
	}
	
	public static void setAnalyticsKey(String key) {
		mAnalytics.setAppkey(key);
	}
	
	public static void onResume(Context context) {
		mAnalytics.onResume(context);
	}
	
	public static void onPause(Context context) {
		mAnalytics.onPause(context);
	}
	
	public static void onDestroy(Context context) {
		mAdManager.unregisterSceenReceiver(context);
	}
	
	public static void initAdManager(Context context, FrameLayout container) {
		mAdManager = new YoumiAdManager(context, container);
	}
	
	public static void setAdAppKey(String appKey, String appSecret)  {
		mAdManager.setAppKey(appKey, appSecret);
	}
	
	public static void showBannerAd() {
		mAdManager.showBannerAd();
	}
	
	public static void hideBannerAd() {
		mAdManager.hideBannerAd();
	}
	
	public static void showSpotAd() {
		mAdManager.showSpotAd();
	}
	
	public static void hideSpotAd() {
		mAdManager.hideSpotAd();
	}
}
