//
//  CUModel.h
//  
//
//  Created by Андрей Паршаков on 26.07.12.
//  Copyright (c) 2012 bmm. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FTServerLoader.h"

@class CUModel;
@class FTCache;

#pragma mark -
#pragma mark FUModelDelegate

@protocol CUModelDelegate<NSObject>

@required
- (void)model:(CUModel*)model serverError:(NSError*)error_;
- (void)modelDidUpdatedFromServer:(CUModel*)model_;
- (void)modelDidUpdatedFromCache:(CUModel*)model_;
- (void)modelStartLoadFromServer:(CUModel*)model_;

@end

#pragma mark -
#pragma mark EGAModel

@interface CUModel : NSObject<FTServerLoaderDelegate>
{
    NSMutableArray *_items;
    FTServerLoader *_loader;
    FTCache        *_cache;
    
    __unsafe_unretained id<CUModelDelegate> _delegate;
}

@property(nonatomic,assign) id<CUModelDelegate> delegate;

- (NSMutableArray*)items;
- (void)refresh:(id)data_;
- (void)cancel;

@end



@interface CUModel(Protected) 

- (void)_initData;
- (void)_loadFromCache:(id)data_;
- (void)_updateCache:(id)data_;
- (void)_loadFromServer:(id)data_;
- (void)_serverError:(NSError*)error_;
- (void)_reciveData:(id)data_;
- (BOOL)_needLoadFromCache;

@end

