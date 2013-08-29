//
//  WeatherReport.h
//  Yahoo Weather Test
//
//  Created by Robert Ryan on 8/28/13.
//  Copyright (c) 2013 Robert Ryan. All rights reserved.
//

#import <Foundation/Foundation.h>

/** The weather report for a given city at a given moment in time.
 */

@interface WeatherReport : NSObject

/// @name Initialization

/** Initialize the weather report
 
 @param woeid This is the Yahoo! WOEID, a cryptic numeric code for looking up weather reports. 
 
 @return A reference to the `WeatherReport` object.

 @note You have to either know these in advance (which this app does for just a few cities), or you have to sign up for Yahoo! services to look up WOEID.
 */

- (id)initWithWoeid:(NSString *)woeid;


/// @name Status

/** Determine if the weather report needs to be refreshed
 
 @return `YES` if the app must fetch updated weather report. `NO` otherwise.
 */

- (BOOL)needsRefresh;


/// @name Properties

/// The Yahoo! WOEID

@property (nonatomic, copy)   NSString *woeid;

/// City name

@property (nonatomic, copy)   NSString *cityName;

/// Temperature

@property (nonatomic)         double    temperature;

/// The URL of the image associated with the weather report (if any)

@property (nonatomic, copy)   NSURL    *imageURL;

/// Timestamp that we last successfully retrieved the weather report

@property (nonatomic, strong) NSDate   *timestamp;


@end
