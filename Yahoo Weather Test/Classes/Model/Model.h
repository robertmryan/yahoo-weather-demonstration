//
//  Model.h
//  Yahoo Weather Test
//
//  Created by Robert Ryan on 8/28/13.
//  Copyright (c) 2013 Robert Ryan. All rights reserved.
//

#import <Foundation/Foundation.h>

/** This is the main model for the app, which is simply an array of weather reports.
 */

@interface Model : NSObject

/// @name Configuration

/// The array of weather reports

@property (nonatomic, strong, readonly) NSMutableArray *weatherReports;

/// @name Initialization

/** Retrieve a reference to the singleton
 
 @return A `Model` object
 */

+ (instancetype)sharedManager;

/// @name Loading/saving

/// Load the model from persistent storage

- (void)load;

/// Save the model to persistent storage

- (void)save;


@end
