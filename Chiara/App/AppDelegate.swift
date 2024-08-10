//
//  AppDelegate.swift
//  Chiara
//
//  Created by Eom Chanwoo on 8/10/24.
//

import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        StreetDrainManager.shared.stopListening()
        print("app terminated!!")
    }
}
