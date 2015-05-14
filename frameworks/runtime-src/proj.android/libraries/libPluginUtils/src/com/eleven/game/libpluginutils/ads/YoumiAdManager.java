package com.eleven.game.libpluginutils.ads;

import net.youmi.android.AdManager;
import net.youmi.android.banner.AdSize;
import net.youmi.android.banner.AdView;
import net.youmi.android.onlineconfig.OnlineConfigCallBack;
import net.youmi.android.spot.SpotManager;
import android.content.Context;
import android.os.Handler;
import android.util.Log;
import android.view.Gravity;
import android.view.ViewGroup.LayoutParams;
import android.widget.FrameLayout;

public class YoumiAdManager implements IAdManager {

	private String TAG = YoumiAdManager.class.getSimpleName();
	private Context mContext;
	private FrameLayout mLayout;
	private String appId = "be175c01d4075b98";
	private String appSecret = "e1cd44cbf9e5e7a3";
	
	private FrameLayout mContainer;
	private boolean mShowAD = true;
	private Handler mHandler;
	private AdView mAdView;
	private boolean mIsShowAD = false;

	public YoumiAdManager(Context context, FrameLayout layout) {
		mContext = context;
		mLayout = layout;
		mHandler = new Handler(context.getMainLooper());
	}
	
	public void setAppKey(String appId, String appSecret) {
		this.appId = appId;
		this.appSecret = appSecret;
		this.init();
	}

	@Override
	public boolean init() {
		AdManager.getInstance(mContext).init(appId, appSecret, false);
		AdManager.getInstance(mContext).setEnableDebugLog(true);
		AdManager.getInstance(mContext).asyncGetOnlineConfig("ShowAD", new OnlineConfigCallBack() {
		    @Override
		    public void onGetOnlineConfigSuccessful(String key, String value) {
		        // 获取在线参数成功
		    	if (value.equals("true")) {
		    		mShowAD = true;
		    		Log.d(TAG,"showAD = " + key);
		    	} else {
		    		mShowAD = false;
		    	}
		    }

		    @Override
		    public void onGetOnlineConfigFailed(String key) {
		        // 获取在线参数失败，可能原因有：键值未设置或为空、网络异常、服务器异常
		    	Log.d(TAG, "获取在线参数失败");
		    }
		});
		mAdView = new AdView(mContext, AdSize.FIT_SCREEN);
		SpotManager.getInstance(mContext).loadSpotAds();
		return true;
	}

	@Override
	public void showBannerAd() {
		if (mIsShowAD) {
			return;
		}
		if (mContainer != null) {
			mLayout.removeView(mContainer);
		}
		if (mShowAD != true) {
			return;
		}
		mHandler.post(new Runnable() {
			
			@Override
			public void run() {
				mContainer = new FrameLayout(mContext);
				FrameLayout.LayoutParams params = new FrameLayout.LayoutParams(LayoutParams.MATCH_PARENT, 160);
				params.gravity = Gravity.BOTTOM | Gravity.CENTER;
				mLayout.addView(mContainer, params);
//				AdView adView = new AdView(mContext, AdSize.FIT_SCREEN);
				mContainer.addView(mAdView);
				mIsShowAD = true;
			}
		});
		

	}

	@Override
	public void hideBannerAd() {
		
		if (mContainer != null) {
			mHandler.post(new Runnable() {
				
				@Override
				public void run() {
					Log.d(TAG, "隐藏广告");
					mContainer.removeView(mAdView);
					mLayout.removeView(mContainer);
					mContainer = null;
					mIsShowAD = false;
				}
			});
			
		}
	}
	
	public void showSpotAd()
	{
		mHandler.post(new Runnable() {
			
			@Override
			public void run() {
				SpotManager.getInstance(mContext).showSpotAds(mContext);
			}
		});
		
	}
	
	public void hideSpotAd()
	{
		mHandler.post(new Runnable() {
			
			@Override
			public void run() {
				SpotManager.getInstance(mContext).disMiss(true);
			}
		});
		
	}
	
	public void unregisterSceenReceiver(Context context) {
		SpotManager.getInstance(context).unregisterSceenReceiver();
	}

}
