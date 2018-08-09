//
//  Film.swift
//  PhotoTimer
//
//  Created by Evgeny Evtushenko on 08/08/2018.
//  Copyright © 2018 EVT. All rights reserved.
//

import Foundation

class Film: Decodable {
    var filmName: String?
    var iso: String?
    var developers: [Developer]
    
    private enum CodingKeys: String, CodingKey {
        case filmName
        case iso
        case developers
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        filmName = try container.decode(String.self, forKey: .filmName)
        iso = try container.decode(String.self, forKey: .iso)
        developers = try container.decode([Developer].self, forKey: .developers)
    }
}
