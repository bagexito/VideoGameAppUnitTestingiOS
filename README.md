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

    func errorDidOccur (vm: GamesListViewModel, message: String)
    func didStartLoading (vm: GamesListViewModel)
    func itemsLoaded (vm: GamesListViewModel)
}

public class GamesListViewModel {

    /// Notifies of different flow events 
    public var delegate: GamesListViewModelDelegate?

    /// Represetns is there any error to dislay
    /// True if Yes other wise False
    public var displayError: Bool { get }

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
public protocol DataService {
    func loadGames () -> Response<[GameItem], Error>
}

public struct MockDataService : DataService {

    public func loadGames () -> Response<[GameItem], Error> {


    }
}
```

The GameListViewModel notifies events through GameListViewModelDelegate and to monitor these events we will use the following:

```
public struct MonitorGamesListViewModelDelegate : GamesListViewModelDelegate {

    public var errorDidOccurCallback: (_ vm: GamesListViewModel, _ message: String) -> void?
    public didStartLoadingCallback: (_ vm: GamesListViewModel) -> void?
    public itemsLoadedCallback: (_ vm: GamesListViewModel) -> void?

    public func errorDidOccur (vm: GamesListViewModel, message: String) {
        errorDidOccurCallback?(vm, message)
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


```
/// After successfully loading games list
```

```
/// Loading games list ends with 
```

```
/// Loaded games list is empty
```

###Conclusion

We have seen how we can prepare our app for Unit Testing and use MVVM to test View state. We have implemented some test cases and see how we verify View Model behaviour. 