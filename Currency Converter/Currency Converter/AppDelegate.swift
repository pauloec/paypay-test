//
//  AppDelegate.swift
//  Currency Converter
//
//  Created by Paulo Correa on 19/03/20.
//  Copyright © 2020 PayPay. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private var applicationCoordinator: ApplicationCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        
        let applicationCoordinator = ApplicationCoordinator(withWindow: window)
        self.applicationCoordinator = applicationCoordinator
        applicationCoordinator.start()
        
        return true
    }
}

