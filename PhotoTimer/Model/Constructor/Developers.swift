//
//  Developers.swift
//  PhotoTimer
//
//  Created by Evgeny Evtushenko on 17/06/2018.
//  Copyright © 2018 EVT. All rights reserved.
//

import Foundation
import RealmSwift

class Developers: Object {
    @objc dynamic var devName: String?
    let devPreferences = List<DevProperties>()
    
    convenience init(devName: String, devPreferences: List<DevProperties>) {
        self.init()
        
        self.devName = devName
        for item in devPreferences {
            self.devPreferences.append(item)
        }
    }
}
