package info.cooltechie.upi_chooser;

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

/**
 * UpiChooserPlugin
 */
public class UpiChooserPlugin implements FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private MethodChannel channel;
    Context mContext;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        mContext = flutterPluginBinding.getApplicationContext();
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "upi_chooser");
        channel.setMethodCallHandler(this);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        if (call.method.equals("getUpiApps")) {
            openChooser();
            result.success("Android " + android.os.Build.VERSION.RELEASE);
        } else {
            result.notImplemented();
        }
    }

    private String getUPIString(String payeeAddress, String payeeName, String payeeMCC, String txnID, String txnRefId, String txnNote, String payeeAmount, String currencyCode, String refUrl) {
        String UPI = "upi://pay?pa=" + payeeAddress + "&pn=" + payeeName + "&mc=" + payeeMCC + "&tid=" + txnID + "&tr=" + txnRefId + "&tn=" + txnNote + "&am=" + payeeAmount + "&cu=" + currencyCode + "&refUrl=" + refUrl;
        return UPI.replace(" ", "+");
    }

    private void openChooser() {
        Intent intent = new Intent();
        intent.setAction(Intent.ACTION_VIEW);

        intent.setData(Uri.parse("upi://pay?pa=xxxxx@upi&pn=payee&am=5.00&tn=Test_Transaction&tr=15330175804633937&cu=INR&mc=621"));
        Intent chooser = Intent.createChooser(intent, "Pay with...");
        chooser.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK );
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN) {
            mContext.startActivity(chooser);
//        }

    }


    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }
}
