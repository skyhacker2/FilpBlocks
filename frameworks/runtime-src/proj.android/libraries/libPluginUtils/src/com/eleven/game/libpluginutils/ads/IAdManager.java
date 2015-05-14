package com.eleven.game.libpluginutils.ads;

import android.content.Context;

public interface IAdManager {
	public boolean init();
	
	public void showBannerAd();
	
	public void hideBannerAd();
	
	public void showSpotAd();
	
	public void hideSpotAd();
	
	public void unregisterSceenReceiver(Context context);
	
	public void setAppKey(String appKey, String appSecret);
}
