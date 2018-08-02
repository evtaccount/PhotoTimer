//
//  AppDelegate.swift
//  PhotoTimer
//
//  Created by Evgeny Evtushenko on 06/05/2018.
//  Copyright © 2018 EVT. All rights reserved.
//

import UIKit
import Foundation
import RealmSwift

@UIApplicationMain
class AppDelegate: UserDefaults, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if !UserDefaults.standard.bool(forKey: "db_install") {
//            self.loadSampleTimers()
//            self.loadSamplesFromNetworkToDB()
//            self.loadFilms()
            PTLoadFilmsToDB.loadFilms()
            self.loadSampleTimers()
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func loadSampleTimers() {
        let firstTimer = TimerConfig(
            schemeName: "Fomapan 400 + Ilford",
            filmName: "Fomapan 400",
            developerName: "Ilford D-11",
            devTime: 10,
            stopTime: 6,
            fixTime: 10,
            washTime: 12,
            dryTime: 15,
            firstAgitationDuration: 60,
            periodAgitationDuration: 60,
            agitationPeriod: 10
        )

        let secondTimer = TimerConfig(
            schemeName: "Fomapan 100 + Ilford",
            filmName: "Fomapan 100",
            developerName: "Ilford D-11",
            devTime: 10,
            stopTime: 6,
            fixTime: 10,
            washTime: 12,
            dryTime: 15,
            firstAgitationDuration: 60,
            periodAgitationDuration: 60,
            agitationPeriod: 10
        )

        let thirdTimer = TimerConfig(
            schemeName: "Ilford + Ilford",
            filmName: "Ilford XP-2",
            developerName: "Ilford D-11",
            devTime: 10,
            stopTime: 6,
            fixTime: 10,
            washTime: 12,
            dryTime: 15,
            firstAgitationDuration: 60,
            periodAgitationDuration: 60,
            agitationPeriod: 10
        )

        let configurations = [firstTimer, secondTimer, thirdTimer]

        let realm = try? Realm()
        try? realm?.write {
            for config in configurations {
                realm?.add(config)
            }
        }

        UserDefaults.standard.set(true, forKey: "db_install")
    }

//    func loadSamplesFromNetworkToDB() {
//        var configurationsList: [TimerConfig] = []
//        let realmForTimers = try! Realm()
//
//        ProductsInteractor().getProducts { configurations in
//            configurationsList = configurations
//
//            for item in configurationsList {
//                try! realmForTimers.write {
//                    realmForTimers.add(item)
//                }
//            }
//        }
//        UserDefaults.standard.set(true, forKey: "db_install")
//    }

//    func loadFilms() {
//        var films: [Film] = []
//        let realmForFilms = try! Realm()
//        
//        
//        ProductsInteractor().getFilms { filmsToDB in
//            films = filmsToDB
//
//            for item in films {
//                try! realmForFilms.write {
//                    realmForFilms.add(item)
//                }
//            }
//        }
//    }
}
