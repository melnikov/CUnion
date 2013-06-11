//
//  FTServerLoader.h
//  ARCore
//
//  Created by Андрей Паршаков on 14.11.11.
//  Copyright (c) 2011 bmm. All rights reserved.
//

/*
 FTServerLoader класс загрузчика
 Загружает данные используя для этого базовые классы
 Использется моделью
 */

#import <Foundation/Foundation.h>
#import "FTRequestDelegate.h"

@class FTServerLoader;
@class FTRequestManager;
@class FTServerFormatter;

@protocol FTServerLoaderDelegate <NSObject>

- (void)startLoad:(FTServerLoader *)loader;
- (void)serverLoader:(FTServerLoader *)loader errorLoaded:(NSError*)error_;
- (void)serverLoader:(FTServerLoader *)loader dataLoaded:(id)data_;

@end


@interface FTServerLoader : NSObject<FTRequestDelegate>
{
    @private
        FTServerFormatter *_formatter;
        FTRequestManager  *_requestManager;
        NSMutableArray *_delegats;
}

- (id)initWithRequestManager:(FTRequestManager*)manager_ formatter:(FTServerFormatter*)formatter_;

- (void)removeDelegate:(id<FTServerLoaderDelegate>)delegate_;
- (void)addDelegate:(id<FTServerLoaderDelegate>)delegate_;
- (id) getCacheData;
- (void) load;
- (void) loadToFile;
- (void) loadToFileFromUrl:(NSString*)url_;
- (void) cancelLoad;
- (void) uploadFile;
- (FTServerFormatter*)getFormatter;
- (void)setParameter:(id)parameter_ forKey:(NSString*)key_;

@end
