//
//  FTCache.m
//  ITExpertModules
//
//  Created by andrey on 06.10.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FTCache.h"

@interface FTCache(Private)

- (void)_initStore:(NSString*)name_;

@end


@implementation FTCache

#pragma mark -
#pragma mark init methods

+ (id)cacheWithStoreName:(NSString*)store_name_
{
	return [[self alloc] initWithStoreName:store_name_];
}

- (id)initWithStoreName:(NSString*)store_name_
{
	if ((self = [super init])) {
		_storeName = [[NSString alloc] initWithString:store_name_];
		[self _initStore:_storeName];
	}
	return self;
}

#pragma mark -
#pragma mark public methods

- (BOOL)hasDataForURL:(NSString*)url_
{
	NSAssert(true, @"need override");
	return NO;
}

- (BOOL)hasDataForKey:(NSString*)key_
{
	NSAssert(true, @"need override");
	return NO;
}

- (NSData*)getDataForUrl:(NSString*)key_
{
	NSAssert(true, @"need override");
	return nil;
}


- (NSData*)getDataForKey:(NSString*)key_
{
	NSAssert(true, @"need override");
	return nil;
}

- (void)addData:(NSData*)data_ forKey:(NSString*)key_
{
	NSAssert(true, @"need override");
}

- (void)clear
{
	NSAssert(true, @"need override");
}

- (void)clearForKey:(NSString*)key_
{
	NSAssert(true, @"need override");
}

- (float)getCacheSize
{
	NSAssert(true, @"need override");
	return 0.0;
}

- (NSString*)pathForKey:(NSString*)key_
{
	NSAssert(true, @"need override");
	return nil;
}

#pragma mark -
#pragma mark private methods

- (void)_initStore:(NSString*)name_
{
	NSAssert(true, @"need override");
}

@end
