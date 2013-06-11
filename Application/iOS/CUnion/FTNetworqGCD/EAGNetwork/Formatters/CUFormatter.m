//
//  FUFormatter.m
//  
//
//  Created by Андрей Паршаков on 26.07.12.
//  Copyright (c) 2012 bmm. All rights reserved.
//

#import "CUFormatter.h"
#import "NSObject+SBJson.h"

@implementation CUFormatter

- (id)init
{
    self = [super init];
    if (self) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:[self getDateFormat]];
        [_dateFormatter setTimeZone:[self getTimeZone]];
    }
    return self;
}

- (NSString*)getURL
{
    return [NSString stringWithFormat:@"%@", HOST_POST_KOMSG];
}

- (id)parseServerData:(id)data_
{
    NSString *result = [[NSString alloc] initWithData:[data_ objectForKey:@"nsdata"] encoding:NSUTF8StringEncoding];
    return [result JSONValue];
}


- (NSString*)getDateFormat
{
    return @"yyyy-MM-dd HH:mm:ss";
}

- (NSTimeZone*)getTimeZone
{
    return [NSTimeZone timeZoneForSecondsFromGMT:4 * 3600];
}

@end
