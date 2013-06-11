//
//  FTRequestQueue.m
//  FTUtils
//
//  Created by andrey on 07.02.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FTRequestQueue.h"
#import "FTConnection.h"
#import "FTRequest.h"
#import "FTFileCache.h"

@interface FTRequestQueue(Private)

- (void)_clearQueueAndAddConnection:(FTConnection*)conn_;

@end

@implementation FTRequestQueue

@synthesize maxConcurrentConnection;
@synthesize cache;

- (id)init
{
	if ((self = [super initWithTimeInterval:0.3 resolution:1.0])) {
		_queue = [[NSMutableArray alloc] initWithCapacity:4];
		maxConcurrentConnection = 2;
		currentConnectionCount  = 0;
		cache = nil;
        _collectionLock = [[NSLock alloc] init];
	}
	
	return self;
}

- (void)startThread
{
    currentConnectionCount  = 0;
    [super startThread];
}

- (void)addRequest:(FTRequest*)request_ priority:(FTConnectionPriority)priority_
{
	FTConnection *conn = [[FTConnection alloc] init];
    NSURLConnection *urlConn =[[NSURLConnection alloc] initWithRequest:[request_ getRequest]
                                                              delegate:self
                                                      startImmediately:NO];
    
    conn.connection = urlConn;
    
    conn.delegate = [request_ getDelegate];
    conn.priority = priority_;
    conn.inProgress = NO;
    [self _clearQueueAndAddConnection:conn];
}

- (void)addRequestAndStart:(FTRequest*)request_ priority:(FTConnectionPriority)priority_
{
	[self addRequest:request_ priority:priority_];
	if (![self inLoop]) {
        [self startThread];
	}
}

- (void)addRequestFile:(FTRequest*)request_ priority:(FTConnectionPriority)priority_
{
    FTConnection *conn = [[FTConnection alloc] init];
    conn.isFileLoading = YES;
    NSURLConnection *urlConn =[[NSURLConnection alloc] initWithRequest:[request_ getRequest]
                                                              delegate:self
                                                      startImmediately:NO];
    
    conn.connection = urlConn;
    conn.delegate = [request_ getDelegate];
    conn.priority = priority_;
    conn.inProgress = NO;
    [self _clearQueueAndAddConnection:conn];
}

- (void)addRequestFileAndStart:(FTRequest*)request_ priority:(FTConnectionPriority)priority_
{
	[self addRequestFile:request_ priority:priority_];
	if (![self inLoop]) {
        [self startThread];
	}
}


- (void)cancelRequest:(FTRequest*)request_
{
    [_collectionLock lock];
	for (int i = [_queue count]-1; i > -1; i-- ) {
        FTConnection *connect = [_queue objectAtIndex:i];
        if ([connect.delegate isEqual:[request_ getDelegate]]) {
            [connect.connection cancel];
            connect.delegate = nil;
            if (connect.inProgress) {
                currentConnectionCount --;
            }
            connect.needRemove = YES;
        }
    }
    [_collectionLock unlock];
}

- (void)cancelAllForDelegate:(id<FTRequestDelegate>)delegate_
{
    [_collectionLock lock];
    for (int i = [_queue count]-1; i > -1; i-- ) {
        FTConnection *connect = [_queue objectAtIndex:i];
        if ([connect.delegate isEqual:delegate_]) {
            [connect.connection cancel];
            connect.delegate = nil;
            connect.needRemove = YES;
            currentConnectionCount = 0;
        }
    }
    [_collectionLock unlock];
}

- (void)cancelAll
{
	[self stopThread];
    [_collectionLock lock];
	for (FTConnection *connect in _queue) {
        connect.delegate = nil;
        [connect.connection cancel];
    }
    [_queue removeAllObjects];
    currentConnectionCount = 0;
	[_collectionLock unlock];
}

- (void)startLoading
{
	[self startThread];
}

- (void)stopLoading
{
	[self stopThread];
}

- (void)_clearQueueAndAddConnection:(FTConnection*)conn_
{
    [_collectionLock lock];

    BOOL needAdd = YES;
    for (int i = [_queue count]-1; i > -1; i-- ) {
        FTConnection *connect = [_queue objectAtIndex:i];
        if (connect.needRemove) {
            [_queue removeObject:connect];
        }else if ([connect isEqual:conn_]) {
            needAdd = NO;
        }
    }
    if (needAdd) {
        [_queue addObject:conn_];
    }
    [_queue sortUsingSelector:@selector(compare:)];
    
    [_collectionLock unlock];
}


#pragma mark -
#pragma mark TreadLoopObject methods

-(void)backgroundThreadFire:(id)sender {
	if ([_queue count] == 0) {
		[self _stopLoop];
		return;
	}
	
	if (maxConcurrentConnection <= currentConnectionCount) {
		return;
	}
	[_collectionLock lock];
    
    for (int i = 0; i < [_queue count]; i++) {
        FTConnection *inner = [_queue objectAtIndex:i];
        if (!inner.inProgress && !inner.needRemove) {
            currentConnectionCount++;
            inner.inProgress = YES;
            [inner.connection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
            [inner.connection start];
            if (maxConcurrentConnection <= currentConnectionCount) {
               break;
            }
        }
    }
    
    
    [_collectionLock unlock];
}


#pragma mark -
#pragma mark NSURLConnection methods

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace 
{
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge 
{
    [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	for (FTConnection *conn in _queue) {
		if (conn.inProgress && [conn.connection isEqual:connection]) {
			conn.response = response;
			if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
				NSHTTPURLResponse *res = (NSHTTPURLResponse*)response;
				NSDictionary *headers = [res allHeaderFields];
				FTLog(@"headers %@", headers);
                if (conn){
                    if (conn.delegate && [[headers allKeys] containsObject:@"Content-Length"] ) {
                        [(NSObject*)conn.delegate performSelector:@selector(responseSizeHeader:)
                                                        withObject:[NSNumber numberWithInt:[[headers objectForKey:@"Content-Length"] intValue]]];

                    }
                }
			}
			if (conn.isFileLoading && cache) {
				FTLog(@"file  url %@", [[conn.response URL] absoluteString]);
				FTLog(@"file  path %@", [cache pathForKey:[[conn.response URL] absoluteString]]);
				[conn openFile:[cache pathForKey:[[conn.response URL] absoluteString]]];
			}
			break;
		}
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	for (FTConnection *conn in _queue) {
		if (conn.inProgress && [conn.connection isEqual:connection]) {
			if (conn.isFileLoading && cache && conn.fileHandle) {
				[conn.fileHandle writeData:data];
			}else {
				[conn.data appendData:data];
			}
            if(conn.delegate && [(NSObject*)conn.delegate respondsToSelector:@selector(recieveDataSize:) ] )
			{
                [(NSObject*)conn.delegate performSelector:@selector(recieveDataSize:)
                                               withObject:[NSNumber numberWithInt:[data length]] ];
			}
            break;
		}
	}
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [_collectionLock lock];
    for (int i = [_queue count]-1; i > -1; i-- ) {
        FTConnection *conn = [_queue objectAtIndex:i];
        if ([conn.connection isEqual:connection]) {
            if (conn.delegate && conn.inProgress) {
                [(NSObject*)conn.delegate performSelector:@selector(requestError:)
                                                           withObject:error ];
                
                [(NSObject*)conn.delegate performSelector:@selector(endLoading)
                                                           withObject:nil ];
                
            }
            
            if (conn.fileHandle) {
                [conn closeFile];
            }
            conn.needRemove = YES;
            currentConnectionCount--;
            break;
        }
    }
    [_collectionLock unlock];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    @autoreleasepool {
        [_collectionLock lock];
        for (int i = [_queue count]-1; i > -1; i-- ) {
            FTConnection *conn = [_queue objectAtIndex:i];
            if (conn.inProgress && [conn.connection isEqual:connection]) {
                if (cache) {
                    if (conn.isFileLoading && conn.fileHandle) {
                        [conn closeFile];
                        
                        if (conn.delegate) {
                            NSDictionary *result = [[NSDictionary alloc] initWithObjectsAndKeys:conn.data, @"nsdata",
                                                    conn.response, @"nsresponse",
                                                    [cache pathForKey:[[conn.response URL] absoluteString]], @"filepath",
                                                    [[conn.response URL] absoluteString],@"url",
                                                      nil];
                            
                            [(NSObject*)conn.delegate performSelector:@selector(requestDidLoad:)
                                                                       withObject:result ];
                        }
                    }else {
                        [cache addData:conn.data forKey:[[conn.response URL] absoluteString]];
                        if (conn.delegate) {
                            NSDictionary *result = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                    conn.data, @"nsdata",
                                                    conn.response, @"nsresponse",
                                                    [[conn.response URL] absoluteString],@"url",
                                                    nil];
                            
                            [(NSObject*)conn.delegate performSelector:@selector(requestDidLoad:)
                                                           withObject:result];
                        }
                    }
                }else{
                    if (conn.delegate) {
                        NSDictionary *result = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                conn.data, @"nsdata",
                                                conn.response, @"nsresponse",
                                                [[conn.response URL] absoluteString],@"url",
                                                nil];
                        
                        [(NSObject*)conn.delegate performSelector:@selector(requestDidLoad:)
                                                       withObject:result ];
                    }
                }
                if (conn.delegate) {
                    [(NSObject*)conn.delegate performSelector:@selector(endLoading)
                                                   withObject:nil ];
                }
                conn.needRemove = YES;
                currentConnectionCount--;
                break;
            }
        }
        [_collectionLock unlock];
    }
}


@end
