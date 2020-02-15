//
//  VideoGamesTests.swift
//  VideoGamesTests
//
//  Created by Bilal Ahmad on 2/12/20.
//  Copyright © 2020 Bilal Ahmad. All rights reserved.
//

import XCTest

class VideoGamesTests: XCTestCase {
    
    var vm: GamesListViewModel!
    var mockDataService: MockDataService!
    var responseMonitor: MonitorGamesListViewModelDelegate!
    
    override func setUp() {
        super.setUp()
        
        // setting up mock enviornment and response monitor
        mockDataService = MockDataService()
        responseMonitor = MonitorGamesListViewModelDelegate()
        vm = GamesListViewModel(mockDataService)
        vm.delegate = responseMonitor
    }
    
    override func tearDown() {
        
        super.tearDown()
        mockDataService = nil
        vm = nil
        responseMonitor = nil
    }
    
    /// After successfully loading games list
    /// Expected behaviour:
    /// - only show loading should be true and started loading should be called
    /// - items loaded should be called and items count should be correct
    func testDataLoadSuccessfully() {
        
        // setting up expectation
        let startedLoadingExpectation = expectation(description: "got callback start loading")
        let itemsLoadedExpectation = expectation(description: "items loaded expectation")
        
        // simulating the enviornment
        mockDataService.error = nil
        mockDataService.games = [ Game(title: "Happy life") ]
        
        // setting up response monitors
        responseMonitor.didStartLoadingCallback = { vm in
            XCTAssert(vm.showLoading, "Loading flag should be true")
            XCTAssert(!vm.showError, "Error flag should not be true")
            startedLoadingExpectation.fulfill()
        }
        responseMonitor.errorDidOccurCallback = { _ in
            XCTAssert(false, "Invalid error callback")
        }
        responseMonitor.itemsLoadedCallback = { vm in
            XCTAssert(!vm.showLoading, "Loading flag should not be true")
            XCTAssert(!vm.showError, "Error flag should not be true")
            XCTAssert(vm.itemsCount == 1, "Invalid items loaded")
            itemsLoadedExpectation.fulfill()
        }
        
        // performing action
        vm.loadGames()
        
        // check for expectation
        wait(for: [
            startedLoadingExpectation,
            itemsLoadedExpectation
            ], timeout: 1, enforceOrder: true)
    }
    
    /// Loading games list ends with error
    /// Expected behaviour:
    /// - showError should be true and only error did occure should be called
    /// - errorMessage should say "Unable to load games. Please try again !"
    func testDataLoadedWithError() {
        
        // setting up expectation
        let startedLoadingExpectation = expectation(description: "got callback start loading.")
        let errorOccuredExpectation = expectation(description: "loading error expectation.")
        
        // simulating the enviornment
        mockDataService.error = AppDataServiceError.invalidResponse
        mockDataService.games = nil
        
        // setting up response monitors
        responseMonitor.didStartLoadingCallback = { vm in
            XCTAssert(vm.showLoading, "Loading flag should be true.")
            XCTAssert(!vm.showError, "Error flag should not be true.")
            startedLoadingExpectation.fulfill()
        }
        responseMonitor.errorDidOccurCallback = { vm in
            
            XCTAssert(!vm.showLoading, "Loading flag should not be true.")
            XCTAssert(vm.showError, "Error flag should be true.")
            XCTAssert(vm.errorMessage == "Unable to load games. Please try again !",
                      "Invalid error message.")
            XCTAssert(vm.itemsCount == 0, "Items count should be 0.")
            errorOccuredExpectation.fulfill()
        }
        responseMonitor.itemsLoadedCallback = { _ in
            
            XCTAssert(false, "Items loaded callback should not be called.")
        }
        
        // performing action
        vm.loadGames()
        
        // check for expectation
        wait(for: [
            startedLoadingExpectation,
            errorOccuredExpectation
        ], timeout: 1, enforceOrder: true)
    }
    
    /// Loaded games list is empty
    /// Expected behaviour:
    /// - showError should be true and only error did occure should be called
    /// - errorMessage should say "No games available at the moment."
    func testDataLoadedWithEmptyList() {
        
        // setting up expectation
        let startedLoadingExpectation = expectation(description: "got callback start loading.")
        let errorOccuredExpectation = expectation(description: "loading error expectation.")
        
        // simulating the enviornment
        mockDataService.error = nil
        mockDataService.games = []
        
        // setting up response monitors
        responseMonitor.didStartLoadingCallback = { vm in
            XCTAssert(vm.showLoading, "Loading flag should be true.")
            XCTAssert(!vm.showError, "Error flag should not be true.")
            startedLoadingExpectation.fulfill()
        }
        responseMonitor.errorDidOccurCallback = { vm in
            
            XCTAssert(!vm.showLoading, "Loading flag should not be true.")
            XCTAssert(vm.showError, "Error flag should be true.")
            XCTAssert(vm.errorMessage == "No games available at the moment.",
                      "Invalid error message.")
            XCTAssert(vm.itemsCount == 0, "Items count should be 0.")
            errorOccuredExpectation.fulfill()
        }
        responseMonitor.itemsLoadedCallback = { _ in
            
            XCTAssert(false, "Items loaded callback should not be called.")
        }
        
        // performing action
        vm.loadGames()
        
        // check for expectation
        wait(for: [
            startedLoadingExpectation,
            errorOccuredExpectation
        ], timeout: 1, enforceOrder: true)
    }
}
