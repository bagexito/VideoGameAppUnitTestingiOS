//
//  MonitorGamesListViewModelDelegate.swift
//  VideoGames
//
//  Created by Bilal Ahmad on 2/12/20.
//  Copyright © 2020 Bilal Ahmad. All rights reserved.
//

import Foundation

public class MonitorGamesListViewModelDelegate : GamesListViewModelDelegate {
    
    public var errorDidOccurCallback: ((_ vm: GamesListViewModel) -> Void)?
    public var didStartLoadingCallback: ((_ vm: GamesListViewModel) -> Void)?
    public var itemsLoadedCallback: ((_ vm: GamesListViewModel) -> Void)?
    
    public func errorDidOccur (vm: GamesListViewModel) {
        errorDidOccurCallback?(vm)
    }
    public func didStartLoading (vm: GamesListViewModel) {
        didStartLoadingCallback?(vm)
    }
    public func itemsLoaded (vm: GamesListViewModel) {
        itemsLoadedCallback?(vm)
    }
}
