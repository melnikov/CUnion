//
//  FTRequestDelegate.h
//  FTUtils
//
//  Created by andrey on 07.02.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*
 Протокол позволяющий отследить работу сетевого соединения
 */

#import <Foundation/Foundation.h>

#define FILE_PATH_KEY @"filepath"
#define DATA_KEY      @"nsdata"
#define RESPONSE_KEY  @"nsurlresponse"

typedef enum _FTConnectionPriority {
	FTConnectionPriorityLow    = 0,
    FTConnectionPriorityMiddle = 1,
    FTConnectionPriorityHigth  = 2,
} FTConnectionPriority;

@protocol FTRequestDelegate<NSObject>

@required

// 
- (void)requestError:(NSError*)error_;

// contain keys "nsdata" from server and "nsurlresponse", if load file "filepath" - key 
- (void)requestDidLoad:(NSDictionary*)dataAndResponse; 

- (void)responseSizeHeader:(NSNumber*)dataSize;

// call while start loading
- (void)startLoading;

// call while end loading
- (void)endLoading;

@optional

// call every time receive chank of date from server
- (void)recieveDataSize:(NSNumber*)dataSize;

@end
