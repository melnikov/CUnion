//
//  CUMainModel.m
//  
//
//  Created by Андрей Паршаков on 26.07.12.
//  Copyright (c) 2012 bmm. All rights reserved.
//

#import "CUMainModel.h"
#import "FTCache.h"
#import "CUMainFormatter.h"
#import "CUServerManager.h"

#define DB_CLASS_FILE @"main.postkomsg.com"

@implementation CUMainModel

- (void)_initData
{
    _cache = [[CUServerManager sharedManager] getDBCache];
    _loader = [[CUServerManager sharedManager] makeLoader:CUServerLoaderMain];
    [_loader addDelegate:self];
    
}

- (void)_loadFromCache:(id)data_
{
    @autoreleasepool {
        NSPropertyListFormat format;
        NSData *dataFromFile = [_cache getDataForKey:DB_CLASS_FILE];
        
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
        [_loader setParameter:[NSString stringWithFormat:@"%d", _parenID] forKey:@"parent_id"];
        [_loader load];
    }
}

- (void)_updateCache:(id)data_
{
    @autoreleasepool {
        [_cache addData:data_ forKey:DB_CLASS_FILE];
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
    if (_delegate) {
        [self performSelectorOnMainThread:@selector(_updateDelegateFromServer) withObject:nil waitUntilDone:NO];
    }
    
    if ([data_ isKindOfClass:[NSDictionary class]]) {
        @synchronized(self){
            [_items removeAllObjects];
            [_items addObject:data_];
            [self performSelectorInBackground:@selector(_updateCache:) withObject:data_];
        }
        if (_delegate) {
            [self performSelectorOnMainThread:@selector(_updateDelegateFromServer) withObject:nil waitUntilDone:NO];
        }
    }else if([data_ isKindOfClass:[NSDictionary class]]) {
        if ([[data_ allKeys] containsObject:@"error"]) {
            if (_delegate) {
                [self performSelectorOnMainThread:@selector(_serverError:) 
                                       withObject:[NSError errorWithDomain:@"FUErrors" 
                                                                      code:[[data_ objectForKey:@"code"] intValue] 
                                                                  userInfo:[NSDictionary dictionaryWithObject:[data_ objectForKey:@"error"] forKey:NSLocalizedDescriptionKey]] 
                                    waitUntilDone:NO];
            }
        }
    }else {
        FTLog(@"Error");
        if (_delegate) {
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
