##Unit Testing with MVVM in iOS

In this tutorial we will implement Unit Tests for our app View and we will see how MVVM provides easy way to test different states of the View.

###A Quick Overview of MVVM

In my previous article "MVVM an Improvement on MVC", we have seen how MVVM separates the View State from the Controller in ViewModel. We can drive View states represented by ViewModel in  isolation. Which provides us the ability to write test cases to verify different behaviors of View.

###The Test Subject

In this tutorial we will be testing "Video Games" application. It's a simple app that loads and display a list of Games on home screen. Our app flow is as follows:

- App will start loading Games on View load. 
- During loading, app will display a spinner on the screen. 
- If data gets loaded successfully, we will display items in Table View.
- If loading ends with error, then app will display "Unable to load games. Please try again !" message. 
- If loaded items count is 0 then app will display "No games available at the moment." message.

I have compiled a starter project so that you can practice as we proceed. Download the project from here and open the project in Starter folder to get started. 

###Games List View Model

Before we start writing test cases of our GamesListViewModel, lets take a look at its behaviour. You can find GamesListViewModel in the root of starter porject. 

```
public protocol GamesListViewModelDelegate {
    
    func errorDidOccur (vm: GamesListViewModel)
    func didStartLoading (vm: GamesListViewModel)
    func itemsLoaded (vm: GamesListViewModel)
}

public class GamesListViewModel {

    /// Notifies of different flow events 
    public var delegate: GamesListViewModelDelegate?

    /// Represetns is there any error to dislay
    /// True if Yes other wise False
    public var showError: Bool { get }

    /// Error message to display on to the screen
    public var errorMessage: String { get }

    /// Number of items in the loaded games list
    public var itemsCount: Int { get }

    /// Represents either to show loading sign or not
    public var showLoading: Bool { get }

    /// This method initiates the load request to DataService
    public func loadGames()

    /// Returns the item view model to display in list
    public func getItem(at index: Int) -> GameListItemViewModel?

    /// Takes data service to perform data operations
    public init (_ dataService: DataService)
}
```

In GameListViewModel we are exposing all the state information, state change notification (GameListViewModelDelegate) and actions that UI can initiate. GameListViewModel has one dependency that is DataService which allows us to load Game list.

###Prepare Test Enviornment

One of the Unit Testing principle is to isolate the test subject and simulate its dependencies in order to test all the possible cases.

Our test subject GameListViewModel has one dependency i.e. DataService. In order to isolate and simulate enviornment of GameListViewModel, we have to mock DataService behaviours. Following is the mock servicer we will be using:

```
protocol DataService {
    func loadGames(_ completion: @escaping ([Game]?, Error?) -> Void)
}

struct MockDataService : DataService {

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
```

The GameListViewModel notifies events through GameListViewModelDelegate and to monitor these events we will use the following:

```
public struct MonitorGamesListViewModelDelegate : GamesListViewModelDelegate {

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
```

###Lets Start Testing

In our first test case we will test the behaviour of GamesListViewModel if data is loaded successfully with none empty list. To do that we tell MockDataService to send games list with one item and will check the GamesListViewModel response using MonitorGamesListViewModelDelegate.

```
/// After successfully loading games list
/// Expected behaviour:
/// - only show loading should be true and started loading should be called
/// - items loaded should be called and items count should be correct
func testDataLoadSuccessfully() {
    
    // setting up expectations
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
```
Now we will test what if loading data request fails with error. According to our requirement showError should be true and errorMessage should say "Unable to load games. Please try again !".
```
/// Loading games list ends with error
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
```
Now our final case, data loaded successfully but game list is empty. Desired result in this case is, showError should be true and errorMessage should say "No games available at the moment." 
```
/// Loaded games list is empty
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
```

###Conclusion

We have seen how MVVM makes it easy to simulate the user behaviour without dealing with the view. We have written three test cases to see how we can test different states of the View. 

You can download the final project from here. Also if you have any question or suggestion drop a comment below. 