//
//  WeatherReport.m
//  Yahoo Weather Test
//
//  Created by Robert Ryan on 8/28/13.
//  Copyright (c) 2013 Robert Ryan. All rights reserved.
//

#import "WeatherReport.h"
#import <objc/runtime.h>

@implementation WeatherReport

- (id)initWithWoeid:(NSString *)woeid
{
    self = [super init];
    if (self) {
        _woeid = [woeid copy];
    }
    return self;
}

- (BOOL)needsRefresh
{
    if (self.timestamp == nil || [self.timestamp timeIntervalSinceNow] > 300)
        return YES;

    return NO;
}

#pragma mark - NSCoder methods

- (NSSet *)propertyNames
{
    NSMutableSet *propNames = [NSMutableSet set];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        [propNames addObject:propertyName];
    }
    free(properties);

    return propNames;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        for (NSString *key in [self propertyNames])
        {
            [self setValue:[aDecoder decodeObjectForKey:key] forKey:key];
        }
    }

    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
	for (NSString *key in [self propertyNames])
    {
        [aCoder encodeObject:[self valueForKey:key] forKey:key];
    }
}

#pragma mark - NSCopying method

- (id)copyWithZone:(NSZone *)zone
{
    id copy = [[[self class] allocWithZone:zone] init];

    if (copy)
    {
        for (NSString *key in [self propertyNames])
            [copy setValue:[[self valueForKey:key] copyWithZone:zone] forKey:key];
    }

    return copy;
}

@end
