//
//  FTFileCache.m
//  FTUtils
//
//  Created by andrey on 07.02.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FTFileCache.h"
#import "NSString+md5.h"

@interface FTFileCache(Private)

- (NSString*)_getStorePath:(NSString*)url_;
- (NSString *)_applicationDocumentsDirectory;

@end



@implementation FTFileCache


#pragma mark -
#pragma mark public methods

- (BOOL)hasDataForURL:(NSString*)url_
{
	NSString *fileName = [url_  md5HexDigest];
	
	return [self hasDataForKey:fileName];
}

- (BOOL)hasDataForKey:(NSString*)key_
{
	NSString *path = [self _getStorePath:key_];
	FTLog(@"cache file path %@", path);
	BOOL result = NO;
	if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
		result = YES;
	}
	return result;
}

- (NSData*)getDataForUrl:(NSString*)key_
{
    NSData *result = nil;
	NSString *fileName = [key_  md5HexDigest];
	FTLog(@"load from cache file %@", fileName);
	if ([self hasDataForKey:fileName]) {
		NSString *path = [self _getStorePath:fileName];
		result = [NSData dataWithContentsOfFile:path];
	}
	return result;
}

- (NSData*)getDataForKey:(NSString*)key_
{
	NSData *result = nil;
	NSString *fileName = [key_  md5HexDigest];
	FTLog(@"load from cache file %@", fileName);
	if ([self hasDataForKey:fileName]) {
		NSString *path = [self _getStorePath:fileName];
		result = [NSData dataWithContentsOfFile:path];
	}
	return result;
}

- (void)addData:(NSData*)data_ forKey:(NSString*)key_
{
    @autoreleasepool {
        
    if (data_) {
        NSData *writeData = [data_ copy];
        NSString *fileName = [key_ md5HexDigest];
        NSString *path = [self _getStorePath:fileName];
        FTLog(@"add data to cache file %@ for key %@", fileName, key_);
        FTLog(@"for path %@", path);
        @synchronized(self){
            if ([self hasDataForKey:fileName]) {
                [[NSFileManager defaultManager] removeItemAtPath:path
                                                           error:nil];
            }
            if ([writeData writeToFile:path
                            atomically:NO]) {
            }else {
    
            }
        }
        
    }else{
        FTLog(@"fail write for key %@", key_);
    }
        
    }
}

- (void)clear
{
    
    NSString *storePath = [[self _applicationDocumentsDirectory] stringByAppendingPathComponent:_storeName];
	NSDirectoryEnumerator *dirEnum =
    [[NSFileManager defaultManager] enumeratorAtPath:storePath];
	
    NSString *file;
    NSString *removePath;
    while ((file = [dirEnum nextObject])) {
        NSError *err = nil;
        removePath = [storePath stringByAppendingPathComponent:file];
		[[NSFileManager defaultManager] removeItemAtPath:removePath error:&err];
        FTLog(@"%@", removePath);
        if (err) {
            FTLog(@"delete error %@", [err description]);
        }else{
            FTLog(@"correct delete %@", removePath);
        }
	}
}

- (void)clearForKey:(NSString*)key_
{
	NSString *fileName = [key_  md5HexDigest];
	if ([self hasDataForKey:fileName]) {
		NSString *path = [self _getStorePath:fileName];
		[[NSFileManager defaultManager] removeItemAtPath:path error:nil];
	}
}

- (float)getCacheSize
{
	NSDirectoryEnumerator *dirEnum =
    [[NSFileManager defaultManager] enumeratorAtPath:[[self _applicationDocumentsDirectory] stringByAppendingPathComponent:_storeName]];
	
	NSString *file;
	unsigned long long fullSize = 0;
	while (file == [dirEnum nextObject]) {
		NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:file error:nil];
		fullSize += [[fileAttributes objectForKey:NSFileSize] unsignedLongLongValue];
	}
	float result = fullSize/1024;
	return result;
}

- (NSString*)pathForKey:(NSString*)key_
{
	return [self _getStorePath:[key_  md5HexDigest]];
}

#pragma mark -
#pragma mark private methods

- (void)_initStore:(NSString*)name_
{
	BOOL isDir = NO;
	NSString *dirPath = [[self _applicationDocumentsDirectory] stringByAppendingPathComponent:name_];
	if(![[NSFileManager defaultManager] fileExistsAtPath:dirPath isDirectory:&isDir])
	{
		[[NSFileManager defaultManager] createDirectoryAtPath:dirPath
								  withIntermediateDirectories:YES 
												   attributes:nil 
														error:nil];
	}
}

- (NSString*)_getStorePath:(NSString*)url_
{
	NSString *path = [[NSString stringWithString:
					   [[self _applicationDocumentsDirectory] stringByAppendingPathComponent:_storeName]] stringByAppendingPathComponent:url_];
	return path;
}

- (NSString *)_applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}


@end
