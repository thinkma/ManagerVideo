import UIKit
import Flutter
import MessageUI


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    var lastFilePath = String.init("");
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        
        // new add
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let yizhipinToolsChannel = FlutterMethodChannel.init(name: "yzp.cn/tools", binaryMessenger: controller as! FlutterBinaryMessenger)
        
        yizhipinToolsChannel.setMethodCallHandler({
            (call: FlutterMethodCall, result: FlutterResult) -> Void in
            if (call.method == "getLastShareFilePath") {
                self.getLastShareFilePath(result: result)
            } else if (call.method == "clearLastShareFilePath") {
                self.clearLastShareFilePath(result: result)
            }
            if (call.method == "getLastMessageFilePath") {
                self.getLastMessageFilePath(result: result)
            } else if (call.method == "clearLastMessageFilePath") {
                self.clearLastMessageFilePath(result: result)
            }
        })
        
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    // new add
    override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if url.scheme == "file" {
            let path = url.absoluteString
            lastFilePath = path
            return true
        }
        return super.application(app, open: url, options: options)
    }
    
    // new add
    private func getLastShareFilePath(result: FlutterResult) {
        result(lastFilePath)
        var manger = FlutterFunctionManager();
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        manger.share(root: controller);
        print("swift = getLastShareFilePath");
    }
    
    // new add
    private func clearLastShareFilePath(result: FlutterResult) {
        lastFilePath = ""
        print("swift = clearLastShareFilePath");
        result(true)
    }
    
    
    private func getLastMessageFilePath(result: FlutterResult) {
        result(lastFilePath)
        var manger = FlutterFunctionManager();
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        manger.feedBack(root: controller);
        print("swift = getLastShareFilePath");
    }
    
    // new add
    private func clearLastMessageFilePath(result: FlutterResult) {
        lastFilePath = ""
        print("swift = clearLastShareFilePath");
        result(true)
    }

}
