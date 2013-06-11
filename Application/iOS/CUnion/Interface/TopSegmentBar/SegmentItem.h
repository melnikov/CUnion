//
//  SegmentItem.h
//  SCenter
//
//  Created by Andrey Kuritsin on 27.09.12.
//  Copyright (c) 2012 Andrey Kuritsin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SegmentItem : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *highlitedImage;
@property (nonatomic, strong) UIImage *backImage;
@property (nonatomic, strong) UIImage *backHighlitedImage;
@property (nonatomic) BOOL roundedBack;

@end
