//
//  FTRequest.m
//  FTUtils
//
//  Created by andrey on 07.02.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FTRequest.h"


@implementation FTRequest

+ (id)FTRequest:(NSURLRequest*)request_ delegate:(id<FTRequestDelegate>)delegate_
{
	return [[self alloc] initWithRequest:request_ delegate:delegate_];
}

- (id)initWithRequest:(NSURLRequest*)request_ delegate:(id<FTRequestDelegate>)delegate_
{
	if ((self = [super init])) {
		_request = request_;
		_delegate = delegate_;
	}
	return self;
}

- (NSURLRequest*)getRequest
{
	return _request;
}

- (id)getDelegate
{
	return _delegate;
}


@end
