//
//  GamesListViewModel.swift
//  VideoGames
//
//  Created by Bilal Ahmad on 2/11/20.
//  Copyright © 2020 Bilal Ahmad. All rights reserved.
//

import Foundation

public protocol GamesListViewModelDelegate {
    
    func errorDidOccur (vm: GamesListViewModel)
    func didStartLoading (vm: GamesListViewModel)
    func itemsLoaded (vm: GamesListViewModel)
}

enum Message : String {
    
    case loadingNeverInitiated = "Loading never initiated"
    case unableToLoadGamesTryAgain = "Unable to load games. Please try again !"
    case noGamesAvailable = "No games available at the moment."
    
}

public class GamesListViewModel {
    
    private var items = [GameListItemViewModel]()
    var dataService: DataService!
    
    /// Notifies of different flow events
    var delegate: GamesListViewModelDelegate?
    
    //MARK: -
    //MARK: Props
    
    /// Represetns is there any error to dislay
    /// True if Yes other wise False
    private(set) var showError: Bool = true
    
    /// Error message to display on to the screen
    private(set) var errorMessage: String = Message.loadingNeverInitiated.rawValue
    
    /// Number of items in the loaded games list
    var itemsCount: Int {
        return items.count
    }
    
    /// Represents either to show loading sign or not
    private(set) var showLoading: Bool = false
    
    //MARK: -
    //MARK: Actions
    
    /// This method initiates the load request to DataService
    func loadGames() {
        
        guard !showLoading else {return}
        
        gamesStartedLoading()
        dataService.loadGames { [weak self] (games, error) in
            guard let games = games else {
                
                self?.gamesLoadedWithError()
                return
            }
            guard !games.isEmpty else {
                self?.gamesLoadedWithNone()
                return
            }
            self?.gamesLoaded(games)
        }
    }
    
    /// Returns the item view model to display in list
    func getItem(at index: Int) -> GameListItemViewModel? {
        
        if index < 0 || index >= items.count {
            return nil
        }
        
        return items[index]
    }
    
    //MARK: -
    //MARK: Flow Events
    
    private func gamesStartedLoading() {
        
        showLoading = true
        showError = false
        delegate?.didStartLoading(vm: self)
    }
    private func gamesLoadedWithError() {
        
        showLoading = false
        showError = true
        errorMessage = Message.unableToLoadGamesTryAgain.rawValue
        delegate?.errorDidOccur(vm: self)
    }
    private func gamesLoadedWithNone() {
        
        showLoading = false
        showError = true
        errorMessage = Message.noGamesAvailable.rawValue
        delegate?.errorDidOccur(vm: self)
    }
    private func gamesLoaded(_ games: [Game]) {
        
        showLoading = false
        showError = false
        items = games.map(GameListItemViewModel.init)
        delegate?.itemsLoaded(vm: self)
    }
    
    init (_ dataService: DataService) {
        
        self.dataService = dataService
    }
}




