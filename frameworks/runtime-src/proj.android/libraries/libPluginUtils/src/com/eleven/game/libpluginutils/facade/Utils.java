package com.eleven.game.libpluginutils.facade;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;

import android.content.ActivityNotFoundException;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Handler;
import android.util.Log;

/**
 * 工具类
 * @author eleven
 *
 */
public class Utils {
	public final static String TAG = Utils.class.getSimpleName();
	static Handler mHandler;
	
	static Context mContext;
	
	static String mImageSavePath = "/mnt/sdcard/ElevenGames/";
	
	public Utils(Context context) {
		mHandler = new Handler(context.getMainLooper());
		mContext = context;
	}
	
	public void setImageSavePath(String path) {
		mImageSavePath = path;
	}
	
	/**
	 *  评分
	 */
	public void rateApp() {
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
	public void share(final String text) {
		Log.d(TAG, "text: " + text);
		mHandler.postDelayed(new Runnable() {
			
			@Override
			public void run() {
				Facade.hideSpotAd();
				String path = mImageSavePath;
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
					e.printStackTrace();
				}
				tmpFile.delete();
				Intent shareIntent = new Intent(Intent.ACTION_SEND);
				shareIntent.setType("image/*");
				Uri uri = Uri.fromFile(imageFile);
				shareIntent.putExtra(Intent.EXTRA_STREAM, uri);
				if (text != null) {
					shareIntent.putExtra(Intent.EXTRA_TEXT, text);
				}
				mContext.startActivity(shareIntent);
			}
		}, 2000);

	}

}
