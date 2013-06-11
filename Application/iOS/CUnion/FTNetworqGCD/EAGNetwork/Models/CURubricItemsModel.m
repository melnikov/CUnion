//
//  CURubricItemsModel.m
//  
//
//  Created by Андрей Паршаков on 26.07.12.
//  Copyright (c) 2012 bmm. All rights reserved.
//

#import "CURubricItemsModel.h"
#import "FTCache.h"
#import "CURubricItemsFormatter.h"
#import "CUServerManager.h"
#import "NSString+md5.h"

#define DB_CLASS_FILE @"rubric_items.postkomsg.com"

@implementation CURubricItemsModel

- (void)_initData
{
    _cache = [[CUServerManager sharedManager] getDBCache];
    _loader = [[CUServerManager sharedManager] makeLoader:CUServerLoaderRubricItems];
    [_loader addDelegate:self];
    
}

- (void)_loadFromCache:(id)data_
{
    @autoreleasepool {
        
        [_items removeAllObjects];
        
        [_loader setParameter:[NSString stringWithFormat:@"%d,%d", _themeOffset,_themeCount] forKey:@"block_limit"];
        [_loader setParameter:[NSString stringWithFormat:@"%d", _rubricID] forKey:@"rubric_id"];
        
        NSString *cacheURL = [[_loader getFormatter] getCacheURL];
        
        NSString *cacheFileName = [NSString stringWithFormat:@"%@-%@",DB_CLASS_FILE, [cacheURL md5HexDigest]];
        
        NSPropertyListFormat format;
        NSData *dataFromFile = [_cache getDataForKey:cacheFileName];
        
        NSArray *arrayFromFile = nil;
        if (dataFromFile) {
            arrayFromFile = [NSPropertyListSerialization propertyListFromData:dataFromFile
                                                             mutabilityOption:NSPropertyListMutableContainers
                                                                       format:&format 
                                                             errorDescription:NULL];
            @synchronized(self){
                [_items addObject:arrayFromFile];
            }
        }
    }    
    
    [super _loadFromCache:data_];
}

- (void)_loadFromServer:(id)data_
{
    [self performSelectorOnMainThread:@selector(_modelStartLoadFromServer) withObject:nil waitUntilDone:NO];
    @autoreleasepool {
        [_loader setParameter:[NSString stringWithFormat:@"%d,%d", _themeOffset,_themeCount] forKey:@"block_limit"];
        [_loader setParameter:[NSString stringWithFormat:@"%d", _rubricID] forKey:@"rubric_id"];
        [_loader load];
    }
}

- (void)_updateCache:(id)data_
{
    @autoreleasepool {
        
        NSString *cacheURL = [[_loader getFormatter] getCacheURL];
        
        NSString *cacheFileName = [NSString stringWithFormat:@"%@-%@",DB_CLASS_FILE, [cacheURL md5HexDigest]];
        
        NSData *c_data = [NSPropertyListSerialization dataFromPropertyList:data_
                                                                    format:NSPropertyListXMLFormat_v1_0
                                                          errorDescription:nil];
        
        [_cache addData:c_data forKey:cacheFileName];
    }
}

- (NSArray*)items
{
    return _items;
}

- (void)_serverError:(NSError*)error_
{
    [_delegate model:self serverError:error_];
}

- (void)_reciveData:(id)data_
{
    if ([data_ isKindOfClass:[NSDictionary class]])
    {            
        if ([[data_ allKeys] containsObject:@"error"])
        {
            if (_delegate)
            {
                [self performSelectorOnMainThread:@selector(_serverError:)
                                       withObject:[NSError errorWithDomain:@"FUErrors"
                                                                      code:[[data_ objectForKey:@"code"] intValue]
                                                                  userInfo:[NSDictionary dictionaryWithObject:[data_ objectForKey:@"error"] forKey:NSLocalizedDescriptionKey]]
                                    waitUntilDone:NO];
            }
        }
        else
        {
            @synchronized(self)
            {
                [_items removeAllObjects];
                [_items addObject:data_];
                [self performSelectorInBackground:@selector(_updateCache:) withObject:data_];
            }
            
            if (_delegate)
            {
                [self performSelectorOnMainThread:@selector(_updateDelegateFromServer) withObject:nil waitUntilDone:NO];
            }
        }
        
    }
    else
    {
        FTLog(@"Error");
        if (_delegate)
        {
            [self performSelectorOnMainThread:@selector(_serverError:) 
                                   withObject:[NSError errorWithDomain:@"FUErrors" 
                                                                  code:-1 
                                                              userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[self _localizedDescriptionForCode:-1],NSLocalizedDescriptionKey, nil]] 
                                waitUntilDone:NO];
        }
    }
}
- (NSString *)_localizedDescriptionForCode:(int)code
{
    NSString *message = nil;
    
    switch (code) 
    {
        default:
        {
            message = NSLocalizedString(@"unknown_error", @"");
        }
            break;
    }
    
    return message;
}


@end
