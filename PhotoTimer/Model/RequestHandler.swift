//
//  RequestHandler.swift
//  PhotoTimer
//
//  Created by Evgeny Evtushenko on 23/05/2018.
//  Copyright © 2018 EVT. All rights reserved.
//

import Foundation
import Alamofire
import RealmSwift

class ProductsInteractor: NSObject {
    
//    let host = "https://photo-timer-server.herokuapp.com/"
    let host = "localhost"
    let port = 8000
    
    func getProducts(completion: @escaping ([RealmDevelop]) -> Void) {
        let method = "films"
        
        let request = Alamofire.request("http://\(host):\(port)/\(method)")
        print(request)
        request.responseJSON { (response) in
            guard let json = response.result.value as? [String: Any] else {
                completion([])
                return
            }

            print(json)
            guard let success = json["success"] as? Bool else {
                completion([])
                return
            }
            
            guard success else {
                completion([])
                return
            }
            
            guard let data = json["data"] as? [[String:Any]] else {
                completion([])
                return
            }
            
            var configurations: [RealmDevelop] = []
            
            for item in data {
                guard let product = RealmDevelop.parse(json: item) else {
                    continue
                }
                
                configurations.append(product)
            }
            
            completion(configurations)
        }
        
    }
    
    func getFilms(completion: @escaping ([Film]) -> Void) {
        let method = "films"
        
        let request = Alamofire.request("http://\(host):\(port)/\(method)")
        request.responseJSON { (response) in
            print(response.result.value)
            guard let json = response.result.value as? [String: Any] else {
                completion([])
                return
            }
            print(json)
            
            guard let success = json["success"] as? Bool else {
                completion([])
                return
            }
            
            guard success else {
                completion([])
                return
            }
            
            guard let data = json["data"] as? [String:[String:[[String:Any]]]] else {
                completion([])
                return
            }
            
            var filmsToDB: [Film] = []
            
            
            
            for film in data.keys {
                var developers = List<Developers>()
                
                guard let currentFilm = data[film] else {
                    return
                }
                
                for developer in currentFilm.keys {
                    var devProperties = List<DevProperties>()
                    
                    guard let devProperty = currentFilm[developer] else {
                        return
                    }
                    
                    for item in devProperty {
                        guard let property = DevProperties.parseToDB(json: item) else {
                            continue
                        }
                        devProperties.append(property)
                    }
                    developers.append(Developers(devName: developer, devPreferences: devProperties))
                }
                
                filmsToDB.append(Film(filmName: film, developers: developers))
            }
            
            completion(filmsToDB)
        }
    }
    
}
