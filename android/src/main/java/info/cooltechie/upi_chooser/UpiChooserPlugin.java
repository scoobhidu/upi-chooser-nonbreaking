package info.cooltechie.upi_chooser;

import android.util.Log;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Build;
import android.app.Activity;
import android.content.ContextWrapper;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.flutter.plugin.common.MethodChannel.Result;

/**
 * UpiChooserPlugin
 */
public class UpiChooserPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware, PluginRegistry.ActivityResultListener {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private MethodChannel channel;
    Context mContext;
    private Activity activity;
    static final String TAG = "UPI CHOOSER";
    static final int uniqueRequestCode = 512078;

    private Result finalResult;
    private boolean resultReturned;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        mContext = flutterPluginBinding.getApplicationContext();
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "upi_chooser");
        channel.setMethodCallHandler(this);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        if (call.method.equals("getUpiApps")) {
            Log.i("getUpiApps", call.arguments.toString());
            Log.i("getUpiApps", call.argument("payeeAddress"));
            String uriVal = getUPIString(call.argument("payeeAddress"), call.argument("payeeName"), call.argument("payeeMCC"), call.argument("txnID"), call.argument("txnRefId"), call.argument("txnNote"), call.argument("payeeAmount"), call.argument("currencyCode"), call.argument("refUrl"), call.argument("mode"), call.argument("orgid"), call.argument("mid").toString());
            Log.i("getUpiApps", uriVal);
            Log.i("getUpiApps", "launchType: " + call.argument("launchType"));

            // if(call.argument("launchType").toString()=="chooser"){
            // openChooser(uriVal);
            // }else if(call.argument("launchType").toString()=="intent"){
            // startNewActivity(mContext, call.argument("pkg"), uriVal);
            // }else{
            // Log.i("getUpiApps", "Not implemented");
            // }            
            String type = call.argument("launchType");
            switch (type) {
                case "chooser": {
                    openChooser(uriVal);
                    Log.i("getUpiApps", "case: " + call.argument("launchType"));
                }
                case "intent": {
                    startNewActivity(mContext, call.argument("pkg"), uriVal);
                    Log.i("getUpiApps", "case: " + call.argument("launchType"));
                }
                default: {
                    Log.i("getUpiApps", "case: " + call.argument("launchType"));
                }
            }
            result.success("Android " + android.os.Build.VERSION.RELEASE);
        } else {
            result.notImplemented();
        }
    }

    private String getUPIString(String payeeAddress, String payeeName, String payeeMCC, String txnID, String txnRefId, String txnNote, String payeeAmount, String currencyCode, String refUrl, String mode, String orgid, String mid) {
        String UPI = "upi://pay?pa=" + payeeAddress + "&pn=" + Uri.encode(payeeName) + "&tr=" + Uri.encode(txnRefId) + "&am=" + Uri.encode(payeeAmount);
        if (currencyCode == "") UPI += "&cu=INR";
        else UPI += "&cu=" + Uri.encode(currencyCode);
        UPI += "&mode=04";
        if (mid != "") UPI += "&orgid=" + Uri.encode(orgid);
        if (mid != "") UPI += "&mid=" + Uri.encode(mid);
        return UPI;
    }

    private void openChooser(String uri) {
        Intent intent = new Intent();
        intent.setAction(Intent.ACTION_VIEW);
        intent.setData(Uri.parse(uri));
        Intent chooser = Intent.createChooser(intent, "Pay with...");
        chooser.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        mContext.startActivity(chooser);
    }

    public void startNewActivity(Context context, String packageName, String uri) {
        // Intent intent = context.getPackageManager().getLaunchIntentForPackage(packageName);
        // if (intent == null) {
        //     intent = new Intent(Intent.ACTION_VIEW);
        //     intent.setData(Uri.parse("market://details?id=" + packageName));
        // }
        // intent.setData(Uri.parse(uri));
        // intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        // context.startActivity(intent);

        Intent intent = new Intent(Intent.ACTION_VIEW);
        intent.setData(Uri.parse(uri));
        intent.setPackage(packageName);
        activity.startActivityForResult(intent, uniqueRequestCode);
    }

    String GOOGLE_PAY_PACKAGE_NAME = "com.google.android.apps.nbu.paisa.user";
    int GOOGLE_PAY_REQUEST_CODE = 123;

    Uri uri =
            new Uri.Builder()
                    .scheme("upi")
                    .authority("pay")
                    .appendQueryParameter("pa", "LC2307029174.lyra@rbl")
                    .appendQueryParameter("pn", "name")
                    .appendQueryParameter("mc", "52455")
                    .appendQueryParameter("tr", "252625eyty765756y")
                    .appendQueryParameter("tn", "note")
                    .appendQueryParameter("am", "1.00")
                    .appendQueryParameter("cu", "INR")
                    .appendQueryParameter("orgid", "000000")
                    .appendQueryParameter("mid", "LC2307029174")
                    .appendQueryParameter("mode", "04")
                    .build();

    public void startGpayActivity() {
        Intent intent = new Intent(Intent.ACTION_VIEW);
        intent.setData(uri);
        intent.setPackage(GOOGLE_PAY_PACKAGE_NAME);
        activity.startActivityForResult(intent, GOOGLE_PAY_REQUEST_CODE);
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        Log.d(TAG, "Attaching to Activity");
        activity = binding.getActivity();
        binding.addActivityResultListener(this);
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        Log.d(TAG, "Detaching from Activity for config changes");
        activity = null;
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
        Log.d(TAG, "Reattaching to Activity for config changes");
        activity = binding.getActivity();
    }

    @Override
    public void onDetachedFromActivity() {
        Log.d(TAG, "Detached from Activity");
        activity = null;
    }

    @Override
    public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
        if (uniqueRequestCode == requestCode && finalResult != null) {
            if (data != null) {
                try {
                    String response = data.getStringExtra("response");
                    Log.d(TAG, "RAW RESPONSE FROM REQUESTED APP: " + response);
                    if (!resultReturned) finalResult.success(response);
                } catch (Exception ex) {
                    if (!resultReturned)
                        finalResult.error("null_response", "No response received from app", null);
                }
            } else {
                Log.d(TAG, "Received NULL, User cancelled the transaction.");
                if (!resultReturned)
                    finalResult.error("user_canceled", "User canceled the transaction", null);
            }
        }
        return true;
    }

}
