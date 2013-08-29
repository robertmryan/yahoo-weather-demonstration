//
//  WeatherReportCell.h
//  Yahoo Weather Test
//
//  Created by Robert Ryan on 8/28/13.
//  Copyright (c) 2013 Robert Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>

/** Table view cell subclass for weather report
 
 This class solely exists for its `IBOutlet` references. Note, the storyboard has specified this class as the custom class for the `UITableViewCell`.
 */

@interface WeatherReportCell : UITableViewCell

/// @name Properties

/// The city name label

@property (weak, nonatomic) IBOutlet UILabel *cityNameLabel;

/// The temperature label

@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;

/// The imageview for the weather report from Yahoo! Weather

@property (weak, nonatomic) IBOutlet UIImageView *weatherImageView;

@end
