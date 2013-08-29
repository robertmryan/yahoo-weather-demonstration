###Introduction

This is a trivial iOS application that requests weather reports from thge [Yahoo! weather service](http://developer.yahoo.com/weather/) for a fixed list of cities. The purpose of this app is not to illustrate any terrific functionality, but rather to simply illustrate a possible division of labor in a [Model-View-Controller](https://developer.apple.com/library/ios/documentation/general/conceptual/devpedia-cocoacore/MVC.html) design: 

- Model: The data model driving the app.

- View: Any view-specific logic.

- View Controller: Facilitates communication between the model and the view

This raised a few questions: Where should network requests for data take place?

The key issue for me is that the view controller should be isolated from the gory details of network interfaces and parsing logic. This particular implementation has a few supporting classes to take the load off of the view controller, notably a `NSOperation` subclass that performs the network request and a `NSXMLParser` subclass that does the routine XML parsing logic. Thus, the network and parsing logic has been neatly isolated, the view controller can then simply invoke the `NSOperation` and it's done. In more complicated apps, I might fold the invocation of the "fetch" logic into a "Data Controller". The key issue, though, is that the view controller should not be lost in the weeds of network protocols and complicated parsing logic.

For a class references (including a few notes), please refer to http://robertmryan.github.com/yahoo-weather-demonstration

If you have any questions, post an issue in github.

###Configuration

Note, this was compiled with Xcode 4.6.3 with a target of iOS 6.0 and above.

---

Robert M. Ryan<br />
August 29, 2013