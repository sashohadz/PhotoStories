//
//  AppDelegate.swift
//  photoStories
//
//  Created by Sasho Hadzhiev on 2/21/17.
//  Copyright © 2017 Sasho Hadzhiev. All rights reserved.
//
import UserNotifications
import UIKit
#if DEBUG
    import AdSupport
#endif
import Leanplum
import LeanplumUIEditor
//TO DO:
fileprivate let viewActionIdentifier = "VIEW_IDENTIFIER"
fileprivate let newsCategoryIdentifier = "NEWS_CATEGORY"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    
    var welcomeMessage = LPVar.define("welcomeMessage",with: "Welcome to Leanplum!")
    var profileImage = LPVar.define("loginImage", withFile: "plum")
    let myArrayVar = LPVar.define("myArrayVarName",with: ["Sasho1","Sasho2"])
    var lpEventAttributeArr : LPVar!
    var myDictionaryVar = LPVar.define("myDictionaryVarName", with: ["1" : "Sasho1","2" : "Sasho2"])

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        UNUserNotificationCenter.current().delegate = self
        
        let appId = "app_Ct6WcCuzwLPZwDGwLFg3bc8A0VxKEEMbLuXBr6PvNK4"
        let prodkey = "prod_HySDSeoN8GshFmTRFlnThakIth5M15C6Hnu2qJv70iQ"
        let devKey = "dev_WfRQHaMVNkKSNW015fgejFyborCNXdwAQrsC2LEaGPI"
   
        #if DEBUG
            Leanplum.setAppId(appId, withDevelopmentKey:devKey)
        #else
            Leanplum.setAppId(appId, withProductionKey:prodkey)
        #endif

        Leanplum.setVerboseLoggingInDevelopmentMode(true)
        
        Leanplum.start()
        
        configureUserNotifications()
        
        Leanplum.onStartResponse{ (success:Bool) in
            print("Got a Start call response Success: \(success)")
            
        }
        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        
        let token = tokenParts.joined()
        print("Device Token: \(token)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error)
    {
        print("Failed to register: \(error)")
    }

    func configureUserNotifications(){
        
        if #available(iOS 10.0, *) {
            print("IOS 10 push registration")
            
            UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .alert, .badge]) { (granted,error) in
                if error == nil {
                    print("Permission granted: \(granted)")
                    guard granted else { return }
                    // 1
                    let viewAction = UNNotificationAction(identifier: viewActionIdentifier,
                                                          title: "View",
                                                          options: [.foreground])
                    
                    // 2
                    let newsCategory = UNNotificationCategory(identifier: newsCategoryIdentifier,
                                                              actions: [viewAction],
                                                              intentIdentifiers: [],
                                                              options: [])
                    UNUserNotificationCenter.current().setNotificationCategories([newsCategory])
                    
                    self.getNotificationSettings()
                } else {
                    print(error?.localizedDescription ?? "Error while registering push")
                }
            }
        }
        //iOS 8-10
        else {
            let settings = UIUserNotificationSettings.init(types: [UIUserNotificationType.alert,
                                                                   UIUserNotificationType.badge,
                                                                   UIUserNotificationType.sound],
                                                           categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        print("did receive remote notification \(userInfo)")
    }
}
