//
//  CUModel.m
//  
//
//  Created by Андрей Паршаков on 26.07.12.
//  Copyright (c) 2012 bmm. All rights reserved.
//

#import "CUModel.h"
#import "FTFileCache.h"

@implementation CUModel

@synthesize delegate = _delegate;

- (id)init
{
    self = [super init];
    if (self) 
    {
        _items = [[NSMutableArray alloc] init];
        _cache = nil;
        _loader = nil;
        [self _initData];
    }
    return self;
}

- (BOOL)_needLoadFromCache
{
    return ![_items count];
}

- (void)refresh:(id)data_
{
    [self _loadFromCache:data_];
    
    [self performSelectorInBackground:@selector(_loadFromServer:) withObject:data_];
}

- (void)cancel
{
    [_loader cancelLoad];
}

#pragma mark private methods

- (void)_initData
{
    NSAssert(YES, @"Need override");
}

- (void)_updateDelegateFromCache
{
    if (_delegate) {
        [_delegate modelDidUpdatedFromCache:self];
    }
}

- (void)_updateDelegateFromServer
{
    if (_delegate) {
        [_delegate modelDidUpdatedFromServer:self];
    }
}

- (void)_modelStartLoadFromServer
{
    if (_delegate) {
        [_delegate modelStartLoadFromServer:self];
    }
}


- (void)_loadFromCache:(id)data_
{
    if (self.delegate && [_items count]) {
        [self performSelectorOnMainThread:@selector(_updateDelegateFromCache) withObject:nil waitUntilDone:YES];
    }
}

- (void)_loadFromServer:(id)data_
{
    [_loader load];
}

- (void)_updateCache:(id)data_
{
    
}

- (NSMutableArray*)items
{
    return _items;
}

- (void)_serverError:(NSError*)error_
{
    [_delegate model:self serverError:error_];
}

- (void)_reciveData:(id)data_
{
    NSAssert(YES, @"Need override");
}

#pragma mark -
#pragma mark FTServerLoaderDelegate methods

- (void)startLoad:(FTServerLoader *)loader
{
    
}

- (void)serverLoader:(FTServerLoader *)loader errorLoaded:(NSError*)error_
{
    if ([[NSThread currentThread] isMainThread]) {
        [self _serverError:error_];
    }else{
        [self performSelectorOnMainThread:@selector(_serverError:) withObject:error_ waitUntilDone:NO];
    }
}

- (void)serverLoader:(FTServerLoader *)loader dataLoaded:(id)data_
{
    if ([[NSThread currentThread] isMainThread]) {
        [self _reciveData:data_];
    }else{
        [self performSelectorOnMainThread:@selector(_reciveData:) withObject:data_ waitUntilDone:NO];
    }
}


@end
