//
//  ITRequestManager.h
//  ITExpertModules
//
//  Created by andrey on 30.09.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

/*
 FTRequestManager класс управляющий сетевыми соединениям
 Позволяет управлять также приоритетами сетевых соединений 
 и конфигурировать запросы
 */

#import <Foundation/Foundation.h>
#import "FTRequestDelegate.h"

@class FTRequestQueue;
@class FTCache;
@class FTRequest;

@interface FTRequestManager : NSObject {
	FTRequestQueue *_requestQueue;
	FTCache *_cache;
}

- (id)initWithQueue:(FTRequestQueue*)queue_ cache:(FTCache*)cache_;

- (FTCache*)getCache;
- (void)cancelAll;
- (void)cancelAllForDelegate:(id<FTRequestDelegate>)delegate_;
- (void)cancelRequest:(FTRequest*)request_;

- (void)executeRequest:(NSString*)url_ 
			parameters:(NSDictionary*)params_ 
			  delegate:(id<FTRequestDelegate>)delegate_ 
			  priority:(FTConnectionPriority)priority;

- (void)executeRequestFromCache:(NSString*)url_ 
					 parameters:(NSDictionary*)params_ 
					   delegate:(id<FTRequestDelegate>)delegate_
					   priority:(FTConnectionPriority)priority;

- (void)executeRequestFromCacheOrServer:(NSString*)url_ 
							 parameters:(NSDictionary*)params_ 
							   delegate:(id<FTRequestDelegate>)delegate_ 
							   priority:(FTConnectionPriority)priority;

- (void)executeRequestLoadFile:(NSString*)url_ 
					parameters:(NSDictionary*)params_ 
					  delegate:(id<FTRequestDelegate>)delegate_ 
					  priority:(FTConnectionPriority)priority;

- (void)executeRequestIfEmptyCacheLoadFile:(NSString*)url_ 	
                                parameters:(NSDictionary*)params_ 
                                  delegate:(id<FTRequestDelegate>)delegate_ 
                                  priority:(FTConnectionPriority)priority;

@end

@interface FTRequestManager(Private)

- (void)_prepareRequest:(NSMutableURLRequest*)request_ url:(NSString*)url_ parameters:(NSDictionary*)params_;
- (NSString *)_urlEncodeValue:(NSString *)str;

@end

#pragma mark -
#pragma mark FTSimpleGetRequest

@interface FTSimpleGetRequest : FTRequestManager
{
	
}

@end


#pragma mark -
#pragma mark FTSimplePostRequest

@interface FTSimplePostRequest : FTRequestManager
{
	
}

@end
