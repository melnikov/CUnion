//
//  CUFormatter.h
//  
//
//  Created by Андрей Паршаков on 26.07.12.
//  Copyright (c) 2012 bmm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FTServerFormatter.h"

#define HOST_POST_KOMSG       @"http://postkomsg.com"

@interface CUFormatter : FTServerFormatter
{
    NSDateFormatter *_dateFormatter;
}

- (NSString*)getDateFormat;
- (NSTimeZone*)getTimeZone;


@end
