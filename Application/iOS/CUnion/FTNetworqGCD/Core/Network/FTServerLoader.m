//
//  FTServerLoader.m
//  ARCore
//
//  Created by Андрей Паршаков on 14.11.11.
//  Copyright (c) 2011 bmm. All rights reserved.
//

#import "FTServerLoader.h"
#import "FTRequestManager.h"
#import "FTServerFormatter.h"
#import "FTCache.h"

@implementation FTServerLoader

- (id)initWithRequestManager:(FTRequestManager*)manager_ formatter:(FTServerFormatter*)formatter_
{
    if ((self = [super init])) {
        _formatter      = formatter_;
        _requestManager = manager_;
        _delegats       = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)removeDelegate:(id<FTServerLoaderDelegate>)delegate_
{
    if ([_delegats containsObject:delegate_]) {
        [_delegats removeObject:delegate_];
    }
}

- (void)addDelegate:(id<FTServerLoaderDelegate>)delegate_
{
    if (![_delegats containsObject:delegate_]) {
        [_delegats addObject:delegate_];
    }
}

- (id) getCacheData
{
    FTCache *cache = [_requestManager getCache];
    
    if (!cache || !_formatter)
    {
        return nil;
    }
    
    return [_formatter parseServerData:[cache getDataForUrl:[_formatter getCacheURL]]];
}

- (void) uploadFile
{
    if (_requestManager) 
    {
        
    }
}

- (void) load
{
    if (_requestManager) 
    {
        [_requestManager executeRequest:[_formatter getURL]
                          parameters:[_formatter getParameters] 
                            delegate:self
                            priority:FTConnectionPriorityMiddle];
    }
}

- (void) loadToFileFromUrl:(NSString*)url_
{
    if (_requestManager) 
    {
        [_requestManager executeRequestLoadFile:url_
                                     parameters:nil
                                       delegate:self
                                       priority:FTConnectionPriorityMiddle];
    }
}

- (void) loadToFile
{
    if (_requestManager) 
    {
        [_requestManager executeRequestLoadFile:[_formatter getURL]
                                     parameters:[_formatter getParameters] 
                                       delegate:self
                                       priority:FTConnectionPriorityMiddle];
    }
}

- (void) cancelLoad
{
    if (_requestManager)
    {
        [_requestManager cancelAllForDelegate:self];
    }
}

- (FTServerFormatter*)getFormatter
{
    return _formatter;
}

- (void)setParameter:(id)parameter_ forKey:(NSString*)key_
{
    if (_formatter) 
    {
        [_formatter setParameter:parameter_ forKey:key_];
    }
}

#pragma mark -
#pragma mark FTRequestDelegate methods

- (void)requestError:(NSError*)error_
{
    for (id<FTServerLoaderDelegate> delegate in _delegats) {
        [delegate serverLoader:self errorLoaded:error_];
    }
}


- (void)requestDidLoad:(NSDictionary*)dataAndResponse
{
    for (id<FTServerLoaderDelegate> delegate in _delegats) {
        [delegate serverLoader:self dataLoaded:[_formatter parseServerData:dataAndResponse]];
    }
}

- (void)responseSizeHeader:(NSNumber*)dataSize
{
    
}

- (void)startLoading
{
    for (id<FTServerLoaderDelegate> delegate in _delegats) {
        [delegate startLoad:self];
    }
}

- (void)endLoading
{
    
}


@end
