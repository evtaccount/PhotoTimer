//
//  Developer.swift
//  PhotoTimer
//
//  Created by Evgeny Evtushenko on 08/08/2018.
//  Copyright © 2018 EVT. All rights reserved.
//

import Foundation

class Developer: Decodable {
    var developerName: String
    var devConfigs: [DevConfig]
    
    private enum CodingKeys: String, CodingKey {
        case developerName
        case devConfigs
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        developerName = try container.decode(String.self, forKey: .developerName)
        devConfigs = try container.decode([DevConfig].self, forKey: .devConfigs)
    }
}
