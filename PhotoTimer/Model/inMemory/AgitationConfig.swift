//
//  AgitationConfig.swift
//  PhotoTimer
//
//  Created by Evgeny Evtushenko on 08/08/2018.
//  Copyright © 2018 EVT. All rights reserved.
//

import Foundation

class AgitationConfig: Decodable {
    var firstAgitationDuration: Int = 0
    var periodAgitationDuration: Int = 0
    var agitationPeriod: Int = 0
    
    private enum CodingKeys: String, CodingKey {
        case firstAgitationDuration
        case periodAgitationDuration
        case agitationPeriod
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        firstAgitationDuration = Int(try container.decode(Int64.self, forKey: .firstAgitationDuration))
        periodAgitationDuration = Int(try container.decode(Int64.self, forKey: .periodAgitationDuration))
        agitationPeriod = Int(try container.decode(Int64.self, forKey: .agitationPeriod))
    }
}
