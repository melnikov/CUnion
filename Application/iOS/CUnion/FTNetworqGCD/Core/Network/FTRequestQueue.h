//
//  FTRequestQueue.h
//  FTUtils
//
//  Created by andrey on 07.02.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*
 FTRequestQueue класс очередь предназначенный специально для постановки в очередь запроса на загрузку данных
 Позволяет конфигурировать количество одновременно выполняемых запросов
 */

#import <Foundation/Foundation.h>
#import "ThreadLoopObject.h"
#import "FTRequestDelegate.h"

@class FTRequest;
@class FTConnection;
@class FTCache;

@interface FTRequestQueue : ThreadLoopObject {
	NSMutableArray *_queue;
	NSInteger maxConcurrentConnection;
	
	NSInteger currentConnectionCount;
	FTCache *cache;
    
    NSLock *_collectionLock;
}

@property(nonatomic,assign) NSInteger maxConcurrentConnection;
@property(nonatomic,retain) FTCache *cache;

- (void)addRequest:(FTRequest*)request_ priority:(FTConnectionPriority)priority_;
- (void)addRequestFile:(FTRequest*)request_ priority:(FTConnectionPriority)priority_;
- (void)addRequestFileAndStart:(FTRequest*)request_ priority:(FTConnectionPriority)priority_;
- (void)addRequestAndStart:(FTRequest*)request_ priority:(FTConnectionPriority)priority_;
- (void)cancelRequest:(FTRequest*)request_;
- (void)cancelAllForDelegate:(id<FTRequestDelegate>)delegate_;

- (void)cancelAll;
- (void)startLoading;
- (void)stopLoading;

@end
