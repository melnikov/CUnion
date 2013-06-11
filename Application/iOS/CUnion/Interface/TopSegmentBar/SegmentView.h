//
//  SegmentView.h
//  SCenter
//
//  Created by Andrey Kuritsin on 27.09.12.
//  Copyright (c) 2012 Andrey Kuritsin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SegmentItem;

@interface SegmentView : UIControl
{
    @protected
        UIImageView *_backImageView;
        UIImageView *_iconImageView;
        UILabel     *_titleLabel;
    
        UIImageView *_separateImageView;
    
        UIView *_shadowView;
}

@property (nonatomic, readonly) UIImageView *backImageView;
@property (nonatomic, readonly) UIImageView *iconImageView;
@property (nonatomic, readonly) UILabel     *titleLabel;

- (id)initWithSegmentItem:(SegmentItem *)segItem;

@end
