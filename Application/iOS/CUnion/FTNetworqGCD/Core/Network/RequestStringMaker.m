//
//  RequestStringMaker.m
//  testMakeRequest
//
//  Created by Andrey Kuritsin on 22.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RequestStringMaker.h"
#import "NSString+md5.h"

@interface RequestStringMaker(Private)

- (void)_addParams:(id)parameter name:(NSString *)name;

@end

@implementation RequestStringMaker

- (NSString *)makeStringWithParams:(NSDictionary *)params
{
    _reqString = [NSMutableString string];
    
    [self _addParams:params name:nil];
    
    return _reqString;
}

#pragma mark - Private

- (void)_addParams:(id)parameter name:(NSString *)name
{
    if (name) 
    {
        if ([parameter isKindOfClass:[NSString class]]) 
        {
            [_reqString appendFormat:@"%@=%@&",name,[parameter urlEncodeValue]];
        }
        else if([parameter isKindOfClass:[NSArray class]])
        {
            for (int i = 0; i < [parameter count]; i++) 
            {
                id obj = [parameter objectAtIndex:i];
                
                NSString *sname = [NSString stringWithFormat:@"%@[%d]", name, i];
                
                [self _addParams:obj name:sname];
            }
        }
        else if([parameter isKindOfClass:[NSDictionary class]]) 
        {
            NSArray *keys = [parameter allKeys];
            for (int i = 0; i < keys.count; i++) 
            {
                id key = [keys objectAtIndex:i];
                id obj = [parameter objectForKey:key];
                
                NSString *sname = [NSString stringWithFormat:@"%@[%@]", name, key];
                
                [self _addParams:obj name:sname];
            }
        }
    }
    else 
    {
        if ([parameter isKindOfClass:[NSDictionary class]]) 
        {
            for (id key in [parameter allKeys]) 
            {
                id obj = [parameter objectForKey:key];
                if ([obj isKindOfClass:[NSString class]]) 
                {
                    [_reqString appendFormat:@"%@=%@&", key, [obj urlEncodeValue]];
                }
                else if([obj isKindOfClass:[NSArray class]] || [obj isKindOfClass:[NSDictionary class]]) 
                {
                    [self _addParams:obj name:key];
                }
            }
        }
    }
}

@end
