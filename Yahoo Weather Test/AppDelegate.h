//
//  AppDelegate.h
//  Yahoo Weather Test
//
//  Created by Robert Ryan on 8/28/13.
//  Copyright (c) 2013 Robert Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>

/** This app employs the [Yahoo! Weather API](http://developer.yahoo.com/weather/) to retrieve the weather for a couple of cities.
 
 The only modification to this app delegate was:
 
 - `didFinishLaunchingWithOptions` initializes and loads the Model.
 
 - `applicationDidEnterBackground` and `applicationWillTerminate` to make sure we save the Model.
 */

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
