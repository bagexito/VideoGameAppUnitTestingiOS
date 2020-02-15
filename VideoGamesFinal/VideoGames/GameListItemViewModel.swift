//
//  GameListItemViewModel.swift
//  VideoGames
//
//  Created by Bilal Ahmad on 2/11/20.
//  Copyright © 2020 Bilal Ahmad. All rights reserved.
//

import Foundation

class GameListItemViewModel {
    
    private var game: Game
    
    var title: String {
        return ">> \(game.title)"
    }
    
    init(_ game: Game) {
        self.game = game
    }
}
