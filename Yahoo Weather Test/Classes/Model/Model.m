//
//  Model.m
//  Yahoo Weather Test
//
//  Created by Robert Ryan on 8/28/13.
//  Copyright (c) 2013 Robert Ryan. All rights reserved.
//

#import "Model.h"
#import "WeatherReport.h"

@interface Model ()

@property (nonatomic, strong) NSMutableArray *weatherReports;

@end

@implementation Model

+ (instancetype)sharedManager
{
    static id sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (NSString *)archiveFilename
{
    NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    return [documentsPath stringByAppendingPathComponent:@"WeatherReports.dat"];
}

- (void)load
{
    NSString *path = [self archiveFilename];

    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        self.weatherReports = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        NSAssert(self.weatherReports, @"%s: Unable to read weather reports", __FUNCTION__);
    }
    else
    {
        self.weatherReports = [[NSMutableArray alloc] init];
        NSArray *woeids = @[@"650272", @"2459115", @"2487956", @"44418", @"19344", @"1118370"]; // a few random cities
        for (NSString *woeid in woeids)
        {
            [self.weatherReports addObject:[[WeatherReport alloc] initWithWoeid:woeid]];
        }
    }
}

- (void)save
{
    BOOL success = [NSKeyedArchiver archiveRootObject:self.weatherReports toFile:[self archiveFilename]];

    NSAssert(success, @"%s: Unable to save weather reports", __FUNCTION__);
}

@end
