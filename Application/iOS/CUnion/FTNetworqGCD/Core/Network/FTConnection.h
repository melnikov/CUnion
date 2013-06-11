//
//  FTConnection.h
//  FTUtils
//
//  Created by andrey on 08.02.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*
 FTConnection класс использемый для сетевого соединения 
 */

#import <Foundation/Foundation.h>
#import "FTRequestDelegate.h"

@class FTRequest;

@interface FTConnection : NSObject {
	NSURLConnection *connection;
    NSURLResponse   *response;
	NSMutableData   *data;
    NSFileHandle    *fileHandle;
	
	BOOL inProgress;
	BOOL isFileLoading;
    BOOL _needRemove;
    
	FTConnectionPriority priority;
    
    __unsafe_unretained id<FTRequestDelegate> _delegate;
}

@property(nonatomic,strong) NSFileHandle *fileHandle;
@property(nonatomic,assign) BOOL isFileLoading;
@property(nonatomic,assign) BOOL inProgress;
@property(nonatomic,assign) BOOL needRemove;
@property(nonatomic,assign) FTConnectionPriority priority;
@property(nonatomic,strong) NSURLConnection *connection;
@property(nonatomic,strong) NSMutableData   *data;
@property(nonatomic,strong) NSURLResponse   *response;
@property(nonatomic,unsafe_unretained) id<FTRequestDelegate> delegate;


- (NSComparisonResult)compare:(FTConnection*)conn;
- (NSFileHandle*)openFile:(NSString*)path;
- (void)closeFile;

@end
