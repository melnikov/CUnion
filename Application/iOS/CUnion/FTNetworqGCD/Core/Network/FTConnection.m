//
//  FTConnection.m
//  FTUtils
//
//  Created by andrey on 08.02.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FTConnection.h"

@implementation FTConnection

@synthesize priority,connection,data,inProgress,response,isFileLoading;
@synthesize delegate = _delegate;
@synthesize fileHandle;
@synthesize needRemove = _needRemove;

- (id)init
{
	if ((self = [super init])) {
		data = [[NSMutableData alloc] init];
		inProgress = NO;
		isFileLoading = NO;
        _needRemove = NO;
	}
	return self;
}

- (BOOL)isEqual:(FTConnection*)conn_
{
    if ([self.delegate isEqual:conn_.delegate]) {
        if (self.connection && conn_.connection) {
            if ([self.connection isEqual:conn_.connection]) {
                return YES;
            }
        }
    }
    return NO;
}

- (void)setDelegate:(id<FTRequestDelegate>)delegate_
{
    _delegate = delegate_;
}

- (id<FTRequestDelegate>)delegate
{
    return _delegate;
}

- (NSComparisonResult)compare:(FTConnection*)conn
{
	if (self.priority == conn.priority) {
		return NSOrderedSame;
	}
	
	if ( self.priority > conn.priority) {
		return NSOrderedAscending;
	}
	
	return NSOrderedDescending;
}

- (NSFileHandle*)openFile:(NSString*)path
{
	if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
		[[NSFileManager defaultManager] createFileAtPath:path
												contents:nil
											  attributes:nil];
	}else {
		[[NSFileManager defaultManager] removeItemAtPath:path error:nil];
		[[NSFileManager defaultManager] createFileAtPath:path
												contents:nil
											  attributes:nil];
	}

	NSError *error = nil;
	self.fileHandle = [NSFileHandle fileHandleForWritingAtPath:path];
	if (error) {
		FTLog(@"%@",[error description]);
        return nil;
	}
	return self.fileHandle;
}

- (void)closeFile
{
	[fileHandle closeFile];
	fileHandle = nil;
}

- (void)dealloc
{
    if (fileHandle) {
        [self closeFile];
    }
}

@end
