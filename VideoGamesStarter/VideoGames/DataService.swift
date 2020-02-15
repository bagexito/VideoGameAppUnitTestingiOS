//
//  DataService.swift
//  VideoGames
//
//  Created by Bilal Ahmad on 2/11/20.
//  Copyright © 2020 Bilal Ahmad. All rights reserved.
//

import Foundation

protocol DataService {
    func loadGames(_ completion: @escaping ([Game]?, Error?) -> Void)
}

enum AppDataServiceError : Error {
    
    case invalidResponse
}

struct AppDataService : DataService {
    
    func loadGames(_ completion: @escaping ([Game]?, Error?) -> Void) {
        
        // We can api call or call to local database
        // But for this demo app we will be sending constant responses
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            completion([
                Game(title: "James Bond"),
                Game(title: "Street Fighter")
            ], nil)
//            completion(nil, AppDataServiceError.invalidResponse)
        }
    }
}
