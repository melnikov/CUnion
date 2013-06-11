//
//  TestRunLoop.m
//  FTUtils
//
//  Created by andrey on 07.02.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ThreadLoopObject.h"




@implementation ThreadLoopObject


- (id)initWithTimeInterval:(NSTimeInterval)interval_ resolution:(NSTimeInterval)resolution_
{
	if ((self = [super init])) {
		m_isBackgroundThreadToTerminate = YES;
		_interval = interval_;
		_resolution = resolution_;
	}
	return self;
}

- (BOOL)inLoop
{
	return !m_isBackgroundThreadToTerminate;
}

- (void)startThread
{
	_thread = [[NSThread alloc] initWithTarget:self selector:@selector(_startLoop) object:nil];
    [_thread start];
}

- (void)stopThread
{
	if (_thread) {
        [self performSelector:@selector(_stopLoop) onThread:_thread withObject:nil waitUntilDone:YES];
        _thread = nil;
    }
}

- (void)_startLoop
{
	@autoreleasepool {
        // create a scheduled timer
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:_interval target:self 
                                                        selector:@selector(backgroundThreadFire:) 
                                                        userInfo:nil 
                                                         repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
        
        m_isBackgroundThreadToTerminate = NO;
        BOOL isRunning;
        // create the runloop
        
        do {
            // run the loop!
            NSDate* theNextDate = [NSDate dateWithTimeIntervalSinceNow:_resolution]; 
            isRunning = [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:theNextDate]; 
            // occasionally re-create the autorelease pool whilst program is running
        } while(isRunning==YES && !m_isBackgroundThreadToTerminate);
	}
}

-(void)backgroundThreadFire:(id)sender {
	// do repeated work every one second here
	if (m_isBackgroundThreadToTerminate) {
		return;
	}
	// when thread is to terminate, call [self backgroundThreadTerminate];
	//FTLog(@"fire back");
	
}

- (void)_stopLoop
{
	m_isBackgroundThreadToTerminate = YES;
	CFRunLoopStop([[NSRunLoop currentRunLoop] getCFRunLoop]);
}


@end
