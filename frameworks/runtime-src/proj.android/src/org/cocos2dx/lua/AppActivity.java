/****************************************************************************
Copyright (c) 2008-2010 Ricardo Quesada
Copyright (c) 2010-2012 cocos2d-x.org
Copyright (c) 2011      Zynga Inc.
Copyright (c) 2013-2014 Chukong Technologies Inc.
 
http://www.cocos2d-x.org

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
****************************************************************************/
package org.cocos2dx.lua;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;

import net.youmi.android.AdManager;
import net.youmi.android.banner.AdSize;
import net.youmi.android.banner.AdView;
import net.youmi.android.spot.SpotManager;

import org.cocos2dx.lib.Cocos2dxActivity;

import android.app.AlertDialog;
import android.content.ActivityNotFoundException;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.ActivityInfo;
import android.graphics.Bitmap;
import android.graphics.Rect;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.net.Uri;
import android.net.wifi.WifiInfo;
import android.net.wifi.WifiManager;
import android.os.Bundle;
import android.os.Environment;
import android.os.Handler;
import android.os.Vibrator;
import android.provider.Settings;
import android.util.Log;
import android.view.Gravity;
import android.view.View;
import android.view.View.MeasureSpec;
import android.widget.FrameLayout;

// The name of .so is specified in AndroidMenifest.xml. NativityActivity will load it automatically for you.
// You can use "System.loadLibrary()" to load other .so files.

public class AppActivity extends Cocos2dxActivity{
	public static String TAG = AppActivity.class.getSimpleName();
	static String hostIPAdress="0.0.0.0";
	
	static Vibrator mVibrator;
	
	static AdView mAdView;
	static FrameLayout.LayoutParams mAdViewLayoutParams;
	
	static FrameLayout mCopyFrameLayout;
	
	static Handler mHandler;
	
	static boolean mShownAds = false;
	
	static Cocos2dxActivity mContext;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		
		mContext = this;
		
		if(nativeIsLandScape()) {
			setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_SENSOR_LANDSCAPE);
		} else {
			setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_SENSOR_PORTRAIT);
		}
		
		//2.Set the format of window
		
		// Check the wifi is opened when the native is debug.
		if(nativeIsDebug())
		{
			if(!isWifiConnected())
			{
				AlertDialog.Builder builder=new AlertDialog.Builder(this);
				builder.setTitle("Warning");
				builder.setMessage("Open Wifi for debuging...");
				builder.setPositiveButton("OK",new DialogInterface.OnClickListener() {
					
					@Override
					public void onClick(DialogInterface dialog, int which) {
						startActivity(new Intent(Settings.ACTION_WIFI_SETTINGS));
						finish();
						System.exit(0);
					}
				});
				builder.setCancelable(false);
				builder.show();
			}
		}
		hostIPAdress = getHostIpAddress();
		
		// 振动
		mVibrator = (Vibrator)this.getSystemService(Context.VIBRATOR_SERVICE);
		appInit();
	}
	 private boolean isWifiConnected() {  
	        ConnectivityManager cm = (ConnectivityManager) getSystemService(Context.CONNECTIVITY_SERVICE);  
	        if (cm != null) {  
	            NetworkInfo networkInfo = cm.getActiveNetworkInfo();  
	            if (networkInfo != null && networkInfo.getType() == ConnectivityManager.TYPE_WIFI) {  
	                return true;  
	            }  
	        }  
	        return false;  
	    } 
	 
	public String getHostIpAddress() {
		WifiManager wifiMgr = (WifiManager) getSystemService(WIFI_SERVICE);
		WifiInfo wifiInfo = wifiMgr.getConnectionInfo();
		int ip = wifiInfo.getIpAddress();
		return ((ip & 0xFF) + "." + ((ip >>>= 8) & 0xFF) + "." + ((ip >>>= 8) & 0xFF) + "." + ((ip >>>= 8) & 0xFF));
	}
	
	public static String getLocalIpAddress() {
		return hostIPAdress;
	}
	
	public static String getSDCardPath() {
		if (Environment.getExternalStorageState().equals(Environment.MEDIA_MOUNTED)) {
			String strSDCardPathString = Environment.getExternalStorageDirectory().getPath();
           return  strSDCardPathString;
		}
		return null;
	}
	
	private static native boolean nativeIsLandScape();
	private static native boolean nativeIsDebug();
	
	// 振动
	public static void vibrate() {
		long[] pattern = {0,10,20,30};
		mVibrator.vibrate(pattern, -1);
	}
	public void appInit() {
		AdManager.getInstance(this).init("be175c01d4075b98", "e1cd44cbf9e5e7a3", false);
		AdManager.getInstance(this).setUserDataCollect(true);
		// 广告条
		mAdViewLayoutParams = new FrameLayout.LayoutParams(
				FrameLayout.LayoutParams.WRAP_CONTENT,
				FrameLayout.LayoutParams.WRAP_CONTENT);
		// 设置广告条的悬浮位置
		mAdViewLayoutParams.gravity = Gravity.BOTTOM | Gravity.CENTER; // 上方
		// 实例化广告条
		mAdView = new AdView(this,
				AdSize.FIT_SCREEN);
		// 调用Activity的addContentView函数
		//mFrameLayout.addView(mAdView, mAdViewLayoutParams);
		mCopyFrameLayout = mFrameLayout;
		//showAds();
		mHandler = new Handler(this.getMainLooper());
	}
	
	// jni 显示广告
	public static void showAds() {
		Log.d(TAG, "显示广告");
		if (mShownAds) {
			return;
		}
		mShownAds = true;
		mHandler.post(new Runnable() {
			
			@Override
			public void run() {
				// TODO Auto-generated method stub
				mCopyFrameLayout.addView(mAdView, mAdViewLayoutParams);
			}
		});
		
	}
	// jni 隐藏广告
	public static void hideAds() {
		Log.d(TAG, "隐藏广告");
		if (!mShownAds) {
			return;
		}
		mShownAds = false;
		mHandler.post(new Runnable() {
			
			@Override
			public void run() {
				mCopyFrameLayout.removeView(mAdView);
			}
		});
		
	}
	// 评分
	public static void rateApp() {
		mHandler.post(new Runnable() {
			
			@Override
			public void run() {
				Uri uri = Uri.parse("market://details?id=" + mContext.getPackageName());
				Intent goToMarket = new Intent(Intent.ACTION_VIEW, uri);
				try {
				  mContext.startActivity(goToMarket);
				} catch (ActivityNotFoundException e) {
				  mContext.startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse("http://play.google.com/store/apps/details?id=" + mContext.getPackageName())));
				}
			}
		});

	}
	/**
	 * 截图分享
	 */
	public static void share() {
		mHandler.postDelayed(new Runnable() {
			
			@Override
			public void run() {
				String path = "/mnt/sdcard/FlipBlocks/";
				String imagePath = path + "screenshot.png";
				String internalPath = mContext.getFilesDir().getPath();
				File tmpFile = new File(internalPath + "/screenshot.png");
				Log.d(TAG, "internalPath: " + internalPath);
				File dir = new File(path);
				if (!dir.exists()) {
					dir.mkdir();
				}
				File imageFile = new File(imagePath);
				if (imageFile.exists()) {
					imageFile.delete();
				}
				try {
					imageFile.createNewFile();
					FileInputStream is = new FileInputStream(tmpFile);
					FileOutputStream os = new FileOutputStream(imageFile);
					byte[] buffer = new byte[1024];
					int count = 0;
					while((count = is.read(buffer)) != -1) {
						os.write(buffer);
						os.flush();
					}
					os.close();
					is.close();
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				tmpFile.delete();
				Intent shareIntent = new Intent(Intent.ACTION_SEND);
				shareIntent.setType("image/*");
				Uri uri = Uri.fromFile(imageFile);
				shareIntent.putExtra(Intent.EXTRA_STREAM, uri);
				mContext.startActivity(shareIntent);
			}
		}, 1000);

	}
	
	@Override
	protected void onDestroy() {
		SpotManager.getInstance(this).unregisterSceenReceiver();
		super.onDestroy();
	}
}
