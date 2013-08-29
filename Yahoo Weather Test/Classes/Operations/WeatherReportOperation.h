//
//  WeatherReportOperation.h
//  Yahoo Weather Test
//
//  Created by Robert Ryan on 8/28/13.
//  Copyright (c) 2013 Robert Ryan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WeatherReport;

typedef void(^WeatherRequestCompletion)(WeatherReport *weatherReport, NSError *error);

/** Weather report request operation
 
 This is a `NSOperation` subclass that employs the [Yahoo! Weather API](http://developer.yahoo.com/weather/) to retrieve the weather for a couple of cities.
 
 This employs the `XMLBlockParser` to perform the grunt work of the `NSXMLParser` functions, but uses blocks to inform the parser what we want to do with a few of the key fields. The city and temperature are quite simple to retrieve as they are simple attributes to XML elements, but the retrieval of the image URL requires a slightly more complicated scanning of a HTML description in order to find the image URL.
 
 */

@interface WeatherReportOperation : NSOperation

/// @name Initialization

/** Initialize the operation
 
 @param weatherReport       A `WeatherReport` object that will have (a) city name; (b) temperature; and (c) an image URL populated.
 @param requestCompletion   The block that will be called when the request is complete.
 
 @return A `WeatherOperation` pointer. `nil` if error.

 */


/// @name Properties

- (id)initForWeatherReport:(WeatherReport *)weatherReport completion:(WeatherRequestCompletion)requestCompletion;

/// The weather report to be updated upon receiving information from the Yahoo! weather servers.

@property (nonatomic, strong) WeatherReport *weatherReport;

/// The completion block to be performed.

@property (nonatomic, copy)   WeatherRequestCompletion requestCompletion;

@end
