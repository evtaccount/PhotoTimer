//
//  DevConfig.swift
//  PhotoTimer
//
//  Created by Evgeny Evtushenko on 09/08/2018.
//  Copyright © 2018 EVT. All rights reserved.
//

import Foundation

class DevConfig: Decodable {
    var iso: String
    var dilution: String
    var developingTime: Int
    var agitationConfigs: AgitationConfig
    
    private enum CodingKeys: String, CodingKey {
        case iso
        case dilution
        case developingTime
        case agitationConfigs
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        iso = try container.decode(String.self, forKey: .iso)
        dilution = try container.decode(String.self, forKey: .dilution)
        developingTime = Int(try container.decode(Int64.self, forKey: .developingTime))
        agitationConfigs = try container.decode(AgitationConfig.self, forKey: .agitationConfigs)
    }
}
