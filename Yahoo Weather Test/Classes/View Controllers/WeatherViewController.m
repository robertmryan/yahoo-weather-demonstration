//
//  WeatherViewController.m
//  Yahoo Weather Test
//
//  Created by Robert Ryan on 8/28/13.
//  Copyright (c) 2013 Robert Ryan. All rights reserved.
//

#import "WeatherViewController.h"
#import "WeatherReportCell.h"
#import "WeatherReport.h"
#import "WeatherReportOperation.h"
#import "Model.h"
#import "UIImageView+WebCache.h"

@interface WeatherViewController ()

@property (nonatomic, strong) Model *model;

@end

@implementation WeatherViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.model = [Model sharedManager];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSOperationQueue *)weatherReportQueue
{
    static NSOperationQueue *queue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = [[NSOperationQueue alloc] init];
        queue.maxConcurrentOperationCount = 4;
        queue.name = [[[NSBundle mainBundle] bundleIdentifier] stringByAppendingString:@".weather"];
    });

    return queue;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.model.weatherReports count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"WeatherReportCell";
    WeatherReportCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    WeatherReport *weatherReport = self.model.weatherReports[indexPath.row];

    cell.cityNameLabel.text = weatherReport.cityName;
    [cell.weatherImageView setImageWithURL:weatherReport.imageURL];
    
    if ([weatherReport needsRefresh])
    {
        cell.temperatureLabel.text = nil;
        
        WeatherReportOperation *operation = [[WeatherReportOperation alloc] initForWeatherReport:weatherReport completion:^(WeatherReport *weatherReport, NSError *error) {
            if (weatherReport)
            {
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
        }];
        [[self weatherReportQueue] addOperation:operation];
    }
    else
    {
        cell.temperatureLabel.text = [NSString stringWithFormat:@"%.0f", weatherReport.temperature];
    }
    
    return cell;
}


@end
