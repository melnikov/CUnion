//
//  FTServerFormatter.m
//  ARCore
//
//  Created by Андрей Паршаков on 14.11.11.
//  Copyright (c) 2011 bmm. All rights reserved.
//

#import "FTServerFormatter.h"
#import "NSString+md5.h"

@implementation FTServerFormatter

- (id)init
{
    self = [super init];
    if (self) {
        _params = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (NSString*)getURL
{
    NSAssert(YES, @"Need override");
    return nil;
}

- (NSString*)getCacheURL
{
    NSMutableString *urlString;
    @autoreleasepool {
        NSDictionary *params_ = [self getParameters];
        NSString *url_ = [self getURL];
        if (!params_) {
            urlString = [[NSMutableString alloc] initWithString: url_];
        }else {
            urlString = [[NSMutableString alloc] initWithFormat:@"%@?", url_];
            for (NSString *key in [params_ allKeys]) {
                if ([_params isKindOfClass:[NSArray class]]) {
                    NSUInteger i = 1;
                    for (id param in _params) {
                        [urlString appendFormat:@"%@=%@&", [NSString stringWithFormat:@"%@[%d]", key, i] ,[param urlEncodeValue]];
                        i ++;
                    }
                }else{
                    [urlString appendFormat:@"%@=%@&", key,[[params_ objectForKey:key] urlEncodeValue]];
                }
            }
        }
    }
    return urlString;
}

- (void)setParameter:(id)param_ forKey:(NSString*)key_
{
    if (param_)
    {
        [_params setObject:param_ forKey:key_];
    }
    else
    {
        [_params removeObjectForKey:key_];
    }
}

- (NSDictionary*)getParameters
{
    return _params;
}

- (id)parseServerData:(id)data_
{
    NSAssert(YES, @"Need override");
    return nil;
}


@end
