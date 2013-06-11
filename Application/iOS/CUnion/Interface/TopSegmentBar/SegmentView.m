//
//  SegmentView.m
//  SCenter
//
//  Created by Andrey Kuritsin on 27.09.12.
//  Copyright (c) 2012 Andrey Kuritsin. All rights reserved.
//

#import "SegmentView.h"
#import "SegmentItem.h"
#import <QuartzCore/QuartzCore.h>

@implementation SegmentView

@synthesize backImageView = _backImageView;
@synthesize iconImageView = _iconImageView;
@synthesize titleLabel = _titleLabel;

@synthesize selected = _selected;

- (id)initWithSegmentItem:(SegmentItem *)segItem
{
    self = [super init];
    if (self)
    {
        _backImageView = [[UIImageView alloc] init];
        _backImageView.image = segItem.backImage;
        _backImageView.highlightedImage = segItem.backHighlitedImage;
        
        if (segItem.roundedBack)
        {
            _backImageView.layer.cornerRadius = 10.0f;
        }
        
        [self addSubview:_backImageView];
        
        _separateImageView = [[UIImageView alloc] init];
        [self addSubview:_separateImageView];
        
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.contentMode = UIViewContentModeCenter;
        _iconImageView.image = segItem.image;
        _iconImageView.highlightedImage = segItem.highlitedImage;
        [self addSubview:_iconImageView];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.numberOfLines = 0;
        _titleLabel.text = segItem.title;
        _titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.highlightedTextColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        
        _shadowView = [[UIView alloc] init];
        _shadowView.backgroundColor = [UIColor clearColor];
        _shadowView.userInteractionEnabled = NO;
        [self addSubview:_shadowView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _backImageView.frame = self.bounds;
    
    CGSize size = self.bounds.size;
    CGFloat x,y,w,h;
    
    x = 0.0f;
    y = 0.0f;
    h = size.height;
    w = 2.0f;
    
    _separateImageView.frame = CGRectMake(x, y, w, h);
    
    x = 0.0f;
    y = 0.0f;
    
    if (_iconImageView.image)
    {
        h = size.height * 0.66f;
        w = size.width;
        
        _iconImageView.frame = CGRectMake(x, y, w, h);
        
        y = y + h;
    }
    
    h = size.height - y;
    w = size.width;
    
    _titleLabel.frame = CGRectMake(x, y, w, h);
    
    _shadowView.frame = CGRectMake(0.0f, 0.0f, size.width, size.height);
}

- (void)setSelected:(BOOL)selected
{
    _selected = selected;
    
    _backImageView.highlighted = selected;
    _titleLabel.highlighted = selected;
}

- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    
    if (enabled)
    {
        _shadowView.userInteractionEnabled = NO;
        _shadowView.alpha = 1.0;
        _shadowView.backgroundColor = [UIColor clearColor];
    }
    else
    {
        _shadowView.userInteractionEnabled = YES;
        _shadowView.alpha = 0.25;
        _shadowView.backgroundColor = [UIColor whiteColor];
    }
}

@end
