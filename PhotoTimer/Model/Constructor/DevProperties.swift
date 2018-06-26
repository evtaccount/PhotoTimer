//
//  DevProperties.swift
//  PhotoTimer
//
//  Created by Evgeny Evtushenko on 17/06/2018.
//  Copyright © 2018 EVT. All rights reserved.
//

import Foundation
import RealmSwift

class DevProperties: Object {
    @objc dynamic var iso: String = ""
    @objc dynamic var dilution: String = ""
    @objc dynamic var developingTime: Int = 0
    @objc dynamic var firstAgitationDuration: Int = 0
    @objc dynamic var periodAgitationDuration: Int = 0
    @objc dynamic var agitationPeriod: Int = 0
    
    convenience init(iso: String, dilution: String, developingTime: Int, firstAgitationDuration: Int, periodAgitationDuration: Int, agitationPeriod: Int) {
        self.init()
        
        self.iso = iso
        self.dilution = dilution
        
        self.developingTime = developingTime
        
        self.firstAgitationDuration = firstAgitationDuration
        self.periodAgitationDuration = periodAgitationDuration
        self.agitationPeriod = agitationPeriod
    }
    
    static func parse(json: Dictionary<String, Any>) -> DevProperties? {
        guard let iso = json["ISO"] as? String,
            let dilution = json["dilution"] as? String,
            let devTime = json["developingTime"] as? Int,
            let firstAgitationDuration = json["firstAgitationDuration"] as? Int,
            let periodAgitationDuration = json["periodAgitationDuration"] as? Int,
            let agitationPeriod = json["agitationPeriod"] as? Int else {
                return nil
        }
        
        return DevProperties(iso: iso, dilution: dilution, developingTime: devTime, firstAgitationDuration: firstAgitationDuration, periodAgitationDuration: periodAgitationDuration, agitationPeriod: agitationPeriod)
    }
}
