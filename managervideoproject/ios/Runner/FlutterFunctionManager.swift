//
//  FlutterFunctionManager.swift
//  Runner
//
//  Created by ma wei on 2022/10/27.
//

import UIKit
import MessageUI

class FlutterFunctionManager: NSObject {

    ///
    func share(root:FlutterViewController){
        print("去分享");
        // 去分享
        
    }
    func feedBack (root:FlutterViewController){
        guard MFMailComposeViewController.canSendMail() else {
            EmailError(root: root);
            return;
        }
        
        let email:MFMailComposeViewController = MFMailComposeViewController();
        email.mailComposeDelegate = self;
        email.setToRecipients(["xxxxx@126.com"]);
        email.setMessageBody("邮件正文", isHTML: false);
        email.setSubject("联系我们");
        root.present(email, animated: true, completion: nil);

    }
    func EmailError (root:FlutterViewController){
        let emialalert = UIAlertController(title:"当前无法发送邮件", message:"由于您的设备尚未设置邮箱，请在“邮件”应用中设置后再尝试发送。", preferredStyle: .alert)
        emialalert.addAction(UIAlertAction(title: "确定",
                                      style: UIAlertAction.Style.default,
                            handler: {(alert: UIAlertAction!) in
        }))
        root.present(emialalert, animated: true, completion: nil);
    }

    
    
}

extension FlutterFunctionManager:MFMailComposeViewControllerDelegate{

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .cancelled:print("===cancelled");
        case .saved:print("===saved succ");
        case .sent:print("===sent Succ");
        case .failed: print("===failed");
        default: print("====default");
           
        }
        controller.dismiss(animated: true, completion: nil);
    }
}

