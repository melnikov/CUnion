//
//  FTCache.h
//  ITExpertModules
//
//  Created by andrey on 06.10.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

/*
 FTCache базовый класс для поддержки кеширования загружаемых данных
 */

#import <Foundation/Foundation.h>


@interface FTCache : NSObject {
	NSString *_storeName;
}

+ (id)cacheWithStoreName:(NSString*)store_name_;
- (id)initWithStoreName:(NSString*)store_name_;

- (BOOL)hasDataForKey:(NSString*)key_;
- (BOOL)hasDataForURL:(NSString*)url_;
- (NSData*)getDataForUrl:(NSString*)key_;
- (NSData*)getDataForKey:(NSString*)key_;
- (void)addData:(NSData*)data_ forKey:(NSString*)key_;
- (float)getCacheSize;
- (void)clear;
- (void)clearForKey:(NSString*)key_;
- (NSString*)pathForKey:(NSString*)key_;

@end
