---
title: "Sending iOS push notifications from Haskell using AWS SNS"
date: 2017-03-01
tags: [AWS, SNS, APNS, Haskell]
layout: post
---


Apple push notification service - APNS - [payload key reference](https://developer.apple.com/library/content/documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/PayloadKeyReference.html#//apple_ref/doc/uid/TP40008194-CH17-SW1)

> ErrorMessage "User: arn:aws:iam::461842323278:user/dtopaltzas@mwize.com is not authorized to perform: SNS:CreatePlatformEndpoint on resource: arn:aws:sns:us-east-1:461842323278:app/APNS_SANDBOX/mwize-cleat-dev"

CreatePlatformEndpointResponse' {_cpersEndpointARN = Just "arn:aws:sns:us-east-1:461842323278:endpoint/APNS_SANDBOX/mwize-cleat-dev/c9a4afff-65da-315b-a356-1f4db9f0fce1", _cpersResponseStatus = 200}


IAM policy

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Stmt1490696626000",
            "Effect": "Allow",
            "Action": [
                "sns:Publish",
                "sns:CreatePlatformEndpoint"
            ],
            "Resource": [
                "arn:aws:sns:us-east-1:461842323278:app/APNS_SANDBOX/mwize-cleat-dev"
            ]
        }
    ]
}

```

```haskell
{-# LANGUAGE OverloadedStrings #-}
module SESDemo where


import           Network.AWS
import           Network.AWS.SES
import           SESDemo.Internal


import           Control.Lens
import           System.IO


testCreateSendMail = sendEmail "<source-email>" dest msg
 where
  dest = destination & dToAddresses .~ ["<target-email>"]
  msg = message content' body'
  content' = content "" & cData .~ "Email as a service"
  body' = body & bHTML .~ (Just (content "<h1>People love their cars </h1>"))

testSendEmail :: IO ()
testSendEmail = do
    env <- newEnv Oregon Discover
    l <- newLogger Debug stdout
    _ <- runResourceT . runAWS (env & envLogger .~ l) $ (send testCreateSendMail)
    return ()
```

dToAddresses :: Lens' Destination [Text]
pSubject :: Lens' Publish (Maybe Text)
pTargetARN :: Lens' Publish (Maybe Text)


```javascript
var params = {
  Message: 'STRING_VALUE', /* required */
  MessageAttributes: {
    someKey: {
      DataType: 'STRING_VALUE', /* required */
      BinaryValue: new Buffer('...') || 'STRING_VALUE',
      StringValue: 'STRING_VALUE'
    },
    /* anotherKey: ... */
  },
  MessageStructure: 'STRING_VALUE',
  PhoneNumber: 'STRING_VALUE',
  Subject: 'STRING_VALUE',
  TargetArn: 'STRING_VALUE',
  TopicArn: 'STRING_VALUE'
};
sns.publish(params, function(err, data) {
  if (err) console.log(err, err.stack); // an error occurred
  else     console.log(data);           // successful response
});
```

```swift
extension MWizeAppDelegate {
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02X", $0) }.joined()
        print("didRegisterForRemoteNotificationsWithDeviceToken deviceToken = \(token)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("didFailToRegisterForRemoteNotificationsWithError error = \(error)")
    }
}
```

```swift
    lazy var notificationHandler = NotificationHandler()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        setCustomWindow()
        
        UITabBar.appearance().tintColor = Color.OscarOrange
        
        notificationHandler.requestUserNotificationPermissions() {
            application.registerForRemoteNotifications()
        }
        registerWithAWS()
        FileHandling.clearAttachmentsFolder()
        downloadInAppPurchaseOptions()
        
        return true
    }
  ```


  ```swift
  //
//  NotificationHandler.swift
//  mWize
//
//    * iOS10 notifications: https://useyourloaf.com/blog/local-notifications-with-ios-10/
//    * iOS10 notifications: http://cleanswifter.com/ios-10-local-notifications/
//
//    * Certs: http://stackoverflow.com/questions/31883009/ios-apns-through-amazon-sns-and-unity-cannot-create-a-development-ios-certific
//    * Certs: http://stackoverflow.com/questions/39861540/aws-apple-push-certificate-error-setting-private-key
//    * Amazon docs: http://docs.aws.amazon.com/sns/latest/dg/mobile-push-apns.html#SNSMobilePushPrereqAPNS
//    * Amazon docs: http://docs.aws.amazon.com/sns/latest/dg/mobile-push-send-register.html
//  Created by Nick Ager on 27/03/2017.
//  Copyright © 2017 Expert Marketplace Inc. All rights reserved.
//

import Foundation
import UserNotifications

class NotificationHandler: NSObject, UNUserNotificationCenterDelegate {
    
    override init() {
        super.init()
        setupDelegate()
    }

    func requestUserNotificationPermissions(completion: @escaping ()->()) {
        let center = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.badge, .alert, .sound]
        
        center.requestAuthorization(options: options) { (granted, error) in
            if granted {
                completion()
            } else {
                print("notifications not granted, error: \(error)")
            }
        }
    }
    
    func setupDelegate() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let trigger = response.notification.request.trigger
        let isRemote = (trigger as? UNPushNotificationTrigger) != nil
        print("notifications: didReceive = \(response), isRemote = \(isRemote)")
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("notifications: willPresent = \(notification)")
        completionHandler([.sound, .alert])
    }
}
```

avoiding callback hell: https://strongloop.com/strongblog/node-js-callback-hell-promises-generators/


* https://artyom.me/aeson
* http://blog.plowtech.net/posts/amazonka-ses.html
* http://docs.aws.amazon.com/AWSJavaScriptSDK/latest/AWS/SNS.html#publish-property
* http://docs.aws.amazon.com/sns/latest/dg/SNSMobilePushAPNSAPI.html
* http://docs.aws.amazon.com/sns/latest/dg/sns-dg.pdf
* https://hackage.haskell.org/package/amazonka-sns-1.4.5/docs/Network-AWS-SNS-Publish.html

* http://stackoverflow.com/questions/40099233/trouble-with-aws-sns-setup-with-ios-push-notifications-certificate-type-not-sup
Don't select the private key to export .p12 certificate.

http://evanshortiss.com/development/mobile/2014/02/22/sns-push-notifications-using-nodejs.html
