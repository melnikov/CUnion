//
//  TopSegmentBar.m
//  SCenter
//
//  Created by Andrey Kuritsin on 27.09.12.
//  Copyright (c) 2012 Andrey Kuritsin. All rights reserved.
//

#import "TopSegmentBar.h"
#import "SegmentView.h"

@interface TopSegmentBar(Private)

- (void)_onTap:(UIGestureRecognizer *)rec;

@end

@implementation TopSegmentBar

@synthesize currentIndex = _currentIndex;
@synthesize itemsCount = _itemsCount;

- (id)initWithItems:(NSArray *)items
{
    self = [super init];
    if (self)
    {
        _itemsView = [[NSMutableArray alloc] initWithCapacity:items.count];
        
        for (int i = 0; i < items.count; i++)
        {
            [_itemsView addObject:[[SegmentView alloc] initWithSegmentItem:[items objectAtIndex:i]]];
            [self addSubview:[_itemsView lastObject]];
        }
        
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_onTap:)]];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize size = self.bounds.size;
    
    NSInteger count  = 0;
    
    for (SegmentView *iView in _itemsView)
    {
        if (!iView.hidden)
        {
            count++;
        }
    }
    
    CGFloat x,y,w,h;
    y = 0.0f;
    w = (size.width / count);
    h = size.height;
    
    count = 0;
    
    for (int i = 0; i < _itemsView.count; i++)
    {
        SegmentView *iView = [_itemsView objectAtIndex:i];
        
        if (iView.hidden)
        {
            continue;
        }
        
        x = count * w;
        iView.frame = CGRectMake(x, y, w, h);
        
        count++;
    }
}

- (void)setShowItem:(BOOL)show index:(NSInteger)index
{
    if (index >= _itemsView.count)
    {
        return;
    }
    
    [[_itemsView objectAtIndex:index] setHidden:!show];
    
    [self setNeedsLayout];
}

- (void)setEnabledItem:(BOOL)enabled index:(NSInteger)index
{
    if (index >= _itemsView.count)
    {
        return;
    }
    
    [[_itemsView objectAtIndex:index] setEnabled:enabled];
    
}

- (NSInteger)itemsCount
{
    _itemsCount = _itemsView.count;
    
    return _itemsCount;
}

- (void)setCurrentIndex:(NSInteger)currentIndex
{
    _currentIndex = currentIndex;
    
    [self _updateSelectedView];
}

#pragma mark - Private

- (void)_onTap:(UIGestureRecognizer *)rec
{    
    for (int i = 0; i < _itemsView.count; i++)
    {
        SegmentView *iView = [_itemsView objectAtIndex:i];
        
        if (iView.hidden == NO && iView.enabled)
        {
            CGPoint tapLoc = [rec locationInView:iView];
            
            if (CGRectContainsPoint(iView.bounds, tapLoc))
            {
                _currentIndex = i;
                
                [self _updateSelectedView];
                
                [self sendActionsForControlEvents:UIControlEventValueChanged];
                
                break;
            }
        }
    }
}

- (void)_updateSelectedView
{
    for (int i = 0; i < _itemsView.count; i++)
    {
        BOOL highlighted = NO;
        if (i == _currentIndex)
        {
            highlighted = YES;
        }
        
        [[_itemsView objectAtIndex:i] setSelected:highlighted];
    }
}

@end
