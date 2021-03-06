//
//  PTRealmDatabase.swift
//  PhotoTimer
//
//  Created by Evgeny Evtushenko on 17/06/2018.
//  Copyright © 2018 EVT. All rights reserved.
//

import Foundation
import RealmSwift

class PTRealmDatabase {
    class func saveFilmsToDB(filmsToSave: List<FilmRealm>) {
        let realm = try! Realm()
        
        for item in filmsToSave {
            try! realm.write {
                realm.add(item)
            }
        }
    }
    
    class func loadFilmsFormDB() -> [FilmRealm] {
        let realmFilms = try! Realm()
        var films = [FilmRealm]()
        
        for film in realmFilms.objects(FilmRealm.self) {
            films.append(film)
        }
        return films
    }
    
    class func loadConfigurationsFromDB() -> [TimerConfig] {
        let realm = try! Realm()
        var configurations = [TimerConfig]()
        
        for config in realm.objects(TimerConfig.self) {
            configurations.append(config)
        }
        
        return configurations
    }
    
    class func saveNewConfiguration(forConfiguration newConfig: TimerConfig) -> Bool{
        let realm = try! Realm()
        var result = false
        
        try! realm.write {
            realm.add(newConfig)
            
            result = true
        }
        return result
    }
    
    class func deleteConfiguration(forConfig configToDel: TimerConfig) -> Bool {
        let realm = try! Realm()
        var result = false
        
        try! realm.write {
            realm.delete(configToDel)
            
            result = true
        }
        return result
    }
    
    class func updateConfiguration(newConfig: TimerConfig) -> Bool {
        let realm = try! Realm()
        let timerConfig = TimerConfig()
        var result = false
        
        timerConfig.id = newConfig.id
        timerConfig.schemeName = newConfig.schemeName
        timerConfig.filmName = newConfig.filmName
        timerConfig.developerName = newConfig.developerName
        timerConfig.devTime = newConfig.devTime
        timerConfig.stopTime = newConfig.stopTime
        timerConfig.fixTime = newConfig.fixTime
        timerConfig.washTime = newConfig.washTime
        timerConfig.dryTime = newConfig.dryTime
        timerConfig.firstAgitationDuration = newConfig.firstAgitationDuration
        timerConfig.periodAgitationDuration = newConfig.periodAgitationDuration
        timerConfig.agitationPeriod = newConfig.agitationPeriod
        
        try! realm.write {
            realm.add(timerConfig, update: true)
        }
        
        result = true
        return result
    }
}
