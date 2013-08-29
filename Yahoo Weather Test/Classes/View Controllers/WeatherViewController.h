//
//  WeatherViewController.h
//  Yahoo Weather Test
//
//  Created by Robert Ryan on 8/28/13.
//  Copyright (c) 2013 Robert Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>

/** The main view controller
 
 The view controller is a `UITableViewController` subclass that:
 
 - Establish a reference to the data model;
 
 - When displaying a cell, it inquires the `WeatherReport` object if it needs updating. If it does, it initiates the `WeatherReportOperation` that makes the network request, parses the XML response, and updates the `WeatherReport` object. If it doesn't need refreshing from the network, the view controller simply updates the cell accordingly.
 
 - This takes advantage of the `WeatherReportCell`, a `UITableViewCell` subclass, to take advantage of linking the `IBOutlet` references for each cell.
 
 @note This employs [`SDWebImage`](https://github.com/rs/SDWebImage) for the asynchronous retrieval of images. Clearly we could have done that ourselves, but the `UIImageView` category does a wonderful job at asynchronously retrieving images, performing caching of the images, etc. There are lots of different `UIImageView` categories out there, but this one is my favorite.
 */

@interface WeatherViewController : UITableViewController

@end
