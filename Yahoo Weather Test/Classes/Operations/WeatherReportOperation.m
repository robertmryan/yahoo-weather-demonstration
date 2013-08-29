//
//  WeatherReportOperation.m
//  Yahoo Weather Test
//
//  Created by Robert Ryan on 8/28/13.
//  Copyright (c) 2013 Robert Ryan. All rights reserved.
//

#import "WeatherReportOperation.h"
#import "WeatherReport.h"
#import "XMLBlockParser.h"

@interface WeatherReportOperation () <NSURLConnectionDataDelegate, NSXMLParserDelegate>

@property (nonatomic, getter = isFinished)  BOOL finished;
@property (nonatomic, getter = isExecuting) BOOL executing;

@property (nonatomic, weak) NSURLConnection *connection;
@property (nonatomic, strong) NSMutableData *data;
@property (nonatomic, strong) NSString *parseString;

@end

@implementation WeatherReportOperation

- (id)initForWeatherReport:(WeatherReport *)weatherReport completion:(WeatherRequestCompletion)requestCompletion
{
    self = [super init];
    if (self) {
        _weatherReport = weatherReport;
        self.requestCompletion = requestCompletion;
    }
    return self;
}

- (void)start
{
    if ([self isCancelled])
    {
        self.finished = YES;
        return;
    }

    self.executing = YES;

    NSString *urlString = [NSString stringWithFormat:@"http://weather.yahooapis.com/forecastrss?w=%@", self.weatherReport.woeid];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
    [connection scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    [connection start];
}

#pragma mark - NSOperation methods

- (BOOL)isConcurrent
{
    return YES;
}

- (void)setExecuting:(BOOL)executing
{
    [self willChangeValueForKey:@"isExecuting"];
    _executing = executing;
    [self didChangeValueForKey:@"isExecuting"];
}

- (void)setFinished:(BOOL)finished
{
    [self willChangeValueForKey:@"isFinished"];
    _finished = finished;
    [self didChangeValueForKey:@"isFinished"];
}

- (void)cancel
{
    [self.connection cancel];
    [super cancel];
    self.executing = NO;
    self.finished = YES;
}

#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.data = [NSMutableData data];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    XMLBlockParser *parser = [[XMLBlockParser alloc] initWithData:self.data];

    parser.beginElementBlock = ^(NSArray *elementNames, NSDictionary *attributeDict) {
        if ([[elementNames lastObject] isEqualToString:@"yweather:location"])
        {
            self.weatherReport.cityName = attributeDict[@"city"];
        }
        else if ([[elementNames lastObject] isEqualToString:@"yweather:condition"])
        {
            self.weatherReport.temperature = [attributeDict[@"temp"] doubleValue];
            self.weatherReport.timestamp = [NSDate date];  // really should parse timestamp from feed, but I'm lazy
        }
    };
    
    parser.endElementBlock = ^(NSArray *elementNames, NSString *value){
        if ([[elementNames lastObject] isEqualToString:@"description"])
        {
            NSError *error = nil;
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<img\\s+src\\s*=\\s*\"(.*)\""
                                                                                   options:NSRegularExpressionCaseInsensitive
                                                                                     error:&error];
            NSTextCheckingResult *match = [regex firstMatchInString:value options:0 range:NSMakeRange(0, [value length])];
            if (match)
            {
                NSRange range = [match rangeAtIndex:1];
                self.weatherReport.imageURL = [NSURL URLWithString:[value substringWithRange:range]];
            }
        }
    };
    if ([parser parse])
    {
        if (self.requestCompletion)
        {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                self.requestCompletion(self.weatherReport, nil);
            }];
        }
    };

    self.executing = NO;
    self.finished = YES;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (self.requestCompletion)
    {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.requestCompletion(nil, error);
        }];
    }

    self.executing = NO;
    self.finished = YES;
}

@end
