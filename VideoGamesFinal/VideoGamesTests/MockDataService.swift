//
//  MockDataService.swift
//  VideoGames
//
//  Created by Bilal Ahmad on 2/12/20.
//  Copyright © 2020 Bilal Ahmad. All rights reserved.
//

import Foundation

class MockDataService : DataService {
    
    var games: [Game]?
    var error: Error?
    
    func loadGames(_ completion: @escaping ([Game]?, Error?) -> Void) {
        
        DispatchQueue.main.async {
            
            guard let games = self.games else {
                completion(nil, self.error!)
                return
            }
            completion(games, nil)
        }
    }
}
