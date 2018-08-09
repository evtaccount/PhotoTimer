//
//  ConstructorManager.swift
//  PhotoTimer
//
//  Created by Evgeny Evtushenko on 09/08/2018.
//  Copyright © 2018 EVT. All rights reserved.
//

import Foundation

class ConstructorManager {
    func parse() -> [Film] {
        if let path = Bundle.main.path(forResource: FilePath.filmsDB, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                
                let respoonseObject = try JSONDecoder().decode([Film].self, from: data)
                return respoonseObject
            } catch {
                fatalError()
            }
        }
        return [Film]()
    }
}
