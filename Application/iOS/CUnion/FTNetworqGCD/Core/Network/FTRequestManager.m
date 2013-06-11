//
//  ITRequestManager.m
//  ITExpertModules
//
//  Created by andrey on 30.09.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FTRequestManager.h"
#import "FTRequest.h"
#import "FTRequestQueue.h"
#import "FTCache.h"
#import "NSString+md5.h"

#import "RequestStringMaker.h"

#define REQUEST_TIMEOUT 20.0

@implementation FTRequestManager


- (void)dealloc
{
	[_requestQueue stopLoading];
    _requestQueue = nil;
}

- (id)initWithQueue:(FTRequestQueue*)queue_  cache:(FTCache*)cache_
{
	if ((self = [super init])) {
		_requestQueue = queue_;
		
		if (cache_) {
			_cache = cache_;
			_requestQueue.cache = cache_;
		}else {
			_cache = nil;
		}
		
		
	}
	return self;
}

- (FTCache*)getCache
{
    return _cache;
}

- (void)cancelAll
{
	[_requestQueue cancelAll];
}

- (void)cancelAllForDelegate:(id<FTRequestDelegate>)delegate_
{
	[_requestQueue cancelAllForDelegate:delegate_];
}

- (void)cancelRequest:(FTRequest*)request_
{
	[_requestQueue cancelRequest:request_];
}


- (void)executeRequest:(NSString*)url_ parameters:(NSDictionary*)params_ delegate:(id<FTRequestDelegate>)delegate_ priority:(FTConnectionPriority)priority
{
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setTimeoutInterval:REQUEST_TIMEOUT];
		
	[self _prepareRequest:request url:url_ parameters:params_];
	
	FTRequest *localRequest = [FTRequest FTRequest:request delegate:delegate_];
	[_requestQueue addRequestAndStart:localRequest priority:priority];
}

- (void)executeRequestFromCache:(NSString*)url_ parameters:(NSDictionary*)params_ delegate:(id<FTRequestDelegate>)delegate_ priority:(FTConnectionPriority)priority
{
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setTimeoutInterval:REQUEST_TIMEOUT];
	[self _prepareRequest:request url:url_ parameters:params_];
	
	FTRequest *localRequest = [FTRequest FTRequest:request delegate:delegate_];
	if (_cache) {
		NSData  *cachData = [_cache getDataForKey:[[[localRequest getRequest] URL] absoluteString]];
		[(NSObject *)delegate_ performSelectorOnMainThread:@selector(startLoading) withObject:nil waitUntilDone:NO];
		[(NSObject *)delegate_ performSelectorOnMainThread:@selector(requestDidLoad:) 
												withObject:[NSDictionary dictionaryWithObject:cachData forKey:@"nsdata"] 
											 waitUntilDone:NO];
		[(NSObject *)delegate_ performSelectorOnMainThread:@selector(endLoading) withObject:nil waitUntilDone:NO];
	}else {
		[(NSObject *)delegate_ performSelectorOnMainThread:@selector(requestError:) withObject:nil waitUntilDone:NO];
	}
}

- (void)executeRequestFromCacheOrServer:(NSString*)url_ parameters:(NSDictionary*)params_ delegate:(id<FTRequestDelegate>)delegate_ priority:(FTConnectionPriority)priority
{
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setTimeoutInterval:REQUEST_TIMEOUT];
	[self _prepareRequest:request url:url_ parameters:params_];
	
	FTRequest *localRequest = [FTRequest FTRequest:request delegate:delegate_];
	NSData *cachData = nil;
	if (_cache) 
    {
		cachData = [_cache getDataForKey:[[[localRequest getRequest] URL] absoluteString]];
	}
	
	if (cachData) 
	{
		[(NSObject *)delegate_ performSelectorOnMainThread:@selector(startLoading) withObject:nil waitUntilDone:NO];
		[(NSObject *)delegate_ performSelectorOnMainThread:@selector(requestDidLoad:) 
												withObject:[NSDictionary dictionaryWithObject:cachData forKey:@"nsdata"] 
											 waitUntilDone:NO];
		[(NSObject *)delegate_ performSelectorOnMainThread:@selector(endLoading) withObject:nil waitUntilDone:NO];
	}
	else
	{
		[_requestQueue addRequestAndStart:localRequest priority:priority];
	}
}

- (void)executeRequestLoadFile:(NSString*)url_ 	parameters:(NSDictionary*)params_ delegate:(id<FTRequestDelegate>)delegate_ priority:(FTConnectionPriority)priority
{
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setTimeoutInterval:REQUEST_TIMEOUT];
	
	FTLog(@"%@", params_);
	
	[self _prepareRequest:request url:url_ parameters:params_];
	
	FTLog(@"%@", url_);
	
	FTLog(@"%@", request);
    
    FTRequest *localRequest = [FTRequest FTRequest:request delegate:delegate_];
	[_requestQueue addRequestFileAndStart:localRequest priority:priority];
}

- (void)executeRequestIfEmptyCacheLoadFile:(NSString*)url_ 	parameters:(NSDictionary*)params_ delegate:(id<FTRequestDelegate>)delegate_ priority:(FTConnectionPriority)priority
{
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setTimeoutInterval:REQUEST_TIMEOUT];
	FTLog(@"%@", params_);
	
	[self _prepareRequest:request url:url_ parameters:params_];
	
	FTLog(@"%@", url_);
	
	FTLog(@"%@ \n %@", request, [[request URL] absoluteString]);
    
    
    if ([_cache hasDataForURL:[[request URL] absoluteString]]) {
        [delegate_ requestDidLoad:[NSDictionary dictionaryWithObjectsAndKeys:
                                   [_cache pathForKey:[[request URL] absoluteString]], @"filepath",
                                   [NSNull null], @"nsdata",
                                   [NSNull null], @"nsresponse",
                                   nil]];    
        return;
    }
    
	FTRequest *localRequest = [FTRequest FTRequest:request delegate:delegate_];
	[_requestQueue addRequestFileAndStart:localRequest priority:priority];
}


#pragma mark -
#pragma mark Private methods

- (void)_prepareRequest:(NSMutableURLRequest*)request_ url:(NSString*)url_ parameters:(NSDictionary*)params_
{
	NSAssert(YES, @"need override");
}

@end

#pragma mark -
#pragma mark FTSimpleGetRequest

@implementation FTSimpleGetRequest

- (void)_prepareRequest:(NSMutableURLRequest*)request_ url:(NSString*)url_ parameters:(NSDictionary*)params_
{
    @autoreleasepool {
        NSMutableString *urlString;
        if (!params_.count) 
        {
            urlString = [[NSMutableString alloc] initWithString: url_];
        }
        else 
        {
            urlString = [[NSMutableString alloc] initWithFormat:@"%@?", url_];
            for (NSString *key in params_.allKeys) 
            {
                id obj = [params_ objectForKey:key];
                
                if ([obj isKindOfClass:[NSArray class]])
                {
                    NSUInteger i = 0;
                    for (id param in obj) 
                    {
                        [urlString appendFormat:@"%@=%@&", [NSString stringWithFormat:@"%@[%d]", key, i],[param urlEncodeValue]];
                        i ++;
                    }
                }
                {
                    [urlString appendFormat:@"%@=%@&", key,[[params_ objectForKey:key] urlEncodeValue] ];
                }
            }
        }
        
        FTLog(@"url string %@", urlString);
        
        [request_ setURL:[NSURL URLWithString:urlString]];
        [request_ setHTTPMethod:@"GET"];
        [request_ setTimeoutInterval:REQUEST_TIMEOUT];
	}
}

@end


#pragma mark -
#pragma mark FTSimplePostRequest

@interface FTSimplePostRequest(Private) 

- (void)_prepareRequestFile:(NSMutableURLRequest *)request_ url:(NSString *)url_ parameters:(NSDictionary *)params_;

@end

@implementation FTSimplePostRequest

- (void)_prepareRequest:(NSMutableURLRequest*)request_ url:(NSString*)url_ parameters:(NSDictionary*)params_
{
    if ([[params_ allKeys] containsObject:@"file"] || [[params_ allKeys] containsObject:@"userfile"]) {
        [self _prepareRequestFile:request_ url:url_ parameters:params_];
        return;
    }
    
    @autoreleasepool 
    {
        NSString *urlString = [NSString stringWithString:url_];
     
        [request_ setURL:[NSURL URLWithString:urlString]];
        [request_ setHTTPMethod:@"POST"];
        [request_ setTimeoutInterval:7.0];
        
        
        
        FTLog(@"url string %@", urlString);
        
        if (params_) 
        {   
            
            RequestStringMaker *reqStringMaker = [[RequestStringMaker alloc] init];
            
            NSString *str = [reqStringMaker makeStringWithParams:params_];
            
            FTLog(@"post rerquest data string %@", str);
            
            NSData *postData = [str dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
            NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
            [request_ setValue:postLength forHTTPHeaderField:@"Content-Length"];            
            [request_ setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            [request_ setHTTPBody:postData];	
        }
	}
}

- (void)_prepareRequestFile:(NSMutableURLRequest *)request_ url:(NSString *)url_ parameters:(NSDictionary *)params_
{
    @autoreleasepool 
    {
        NSString *urlString = [NSString stringWithString:url_];
        
        [request_ setURL:[NSURL URLWithString:urlString]];
        [request_ setHTTPMethod:@"POST"];
        [request_ setTimeoutInterval:30.0];
        
        FTLog(@"url string %@", urlString);
        
        NSString *BoundaryConstant = @"AaB03x";
        
        NSMutableData *body = [NSMutableData data];
        
        for (NSString *param in params_.allKeys)
        {
            if (![param isEqualToString:@"file"] && ![param isEqualToString:@"userfile"]) 
            {
                FTLog(@"%@ - %@", param, [params_ objectForKey:param]);
                [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[NSString stringWithFormat:@"%@\r\n", [params_ objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
            }
        }
        
        NSData *imageData = [params_ objectForKey:@"file"];
        if (imageData) 
        {
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\n", @"file"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:imageData];
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        }
        
        NSData *videoData = [params_ objectForKey:@"userfile"];
        if (videoData) 
        {
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"video.mov\"\r\n", @"userfile"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Type: video/mov\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:videoData];
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        }
        
        [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSString *postLength = [NSString stringWithFormat:@"%d", [body length]];
        [request_ setValue:postLength forHTTPHeaderField:@"Content-Length"];            
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", BoundaryConstant];
        [request_ setValue:contentType forHTTPHeaderField: @"Content-Type"];
        [request_ setHTTPBody:body];
        
        FTLog(@"%@", [request_ allHTTPHeaderFields]);
	}
    
}

@end


