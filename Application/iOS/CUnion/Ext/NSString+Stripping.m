//
//  NSString+Stripping.m
//  CUnion
//
//  Created by Andrey Kuritsin on 27.11.12.
//  Copyright (c) 2012 Andrey Kuritsin. All rights reserved.
//

#import "NSString+Stripping.h"

@implementation NSString (Stripping)

-(NSString *)stringByStrippingHTML
{
    NSRange r;
    NSString *s = [self copy];
    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
    {
        s = [s stringByReplacingCharactersInRange:r withString:@""];
    }
    
    return s;
}

@end
