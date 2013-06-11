//
//  TestRunLoop.h
//  FTUtils
//
//  Created by andrey on 07.02.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.

/*
 Базовый класс для очереди
 */


#import <Foundation/Foundation.h>


@interface ThreadLoopObject : NSObject {
	BOOL m_isBackgroundThreadToTerminate;
	NSTimeInterval _interval;
	NSTimeInterval _resolution;
    NSThread *_thread;
}

- (id)initWithTimeInterval:(NSTimeInterval)interval_ resolution:(NSTimeInterval)resolution_;

- (void)startThread;
- (void)stopThread;
- (BOOL)inLoop;

@end

@interface ThreadLoopObject(Private)

-(void)backgroundThreadFire:(id)sender;
-(void)_stopLoop;

@end
