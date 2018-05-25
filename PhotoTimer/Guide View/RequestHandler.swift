//
//  RequestHandler.swift
//  PhotoTimer
//
//  Created by Evgeny Evtushenko on 23/05/2018.
//  Copyright © 2018 EVT. All rights reserved.
//

import Foundation
import Alamofire

class ProductsInteractor: NSObject {
    
    let host = "localhost"
    let port = 8000
    
    func getProducts(completion: @escaping ([Develop]) -> Void) {
        let method = "timers"
        
        let request = Alamofire.request("http://\(host):\(port)/\(method)")
        print(request)
        request.responseJSON { (response) in
            guard let json = response.result.value as? [String: Any] else {
                completion([])
                return
            }
            
            guard let success = json["success"] as? Bool else {
                completion([])
                return
            }
            
            guard success else {
                completion([])
                return
            }
            
            guard let data = json["data"] as? [[String: Any]] else {
                completion([])
                return
            }
            
            var configurations: [Develop] = []
            
            for item in data {
                guard let product = Develop.parse(json: item) else {
                    continue
                }
                
                configurations.append(product)
            }
            
            completion(configurations)
        }
        
    }
    
}
