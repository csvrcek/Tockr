//
//  AppDelegate.swift
//  Tockr
//
//  Created by Connor Svrcek on 8/20/18.
//  Copyright © 2018 Connor Svrcek. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        guard let window: UIWindow = self.window else {fatalError("no window")}
        
        let nav = UINavigationController(rootViewController: PomodoroViewController(numPomodoros: 4))
        window.rootViewController = nav
        window.makeKeyAndVisible()
        
        return true
    }
}

