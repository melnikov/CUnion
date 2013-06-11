//
//  FTRequest.h
//  FTUtils
//
//  Created by andrey on 07.02.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*
 FTRequest сформированного запроса используемый FTConnection
 */

#import <Foundation/Foundation.h>
#import "FTRequestDelegate.h"

@interface FTRequest : NSObject {
	NSURLRequest *_request;
	__unsafe_unretained id<FTRequestDelegate> _delegate;
}

+ (id)FTRequest:(NSURLRequest*)request_ delegate:(id)delegate_;
- (id)initWithRequest:(NSURLRequest*)request_ delegate:(id<FTRequestDelegate>)delegate_;

- (NSURLRequest*)getRequest;
- (id)getDelegate;

@end
