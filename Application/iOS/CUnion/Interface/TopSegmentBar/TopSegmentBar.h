//
//  TopSegmentBar.h
//  SCenter
//
//  Created by Andrey Kuritsin on 27.09.12.
//  Copyright (c) 2012 Andrey Kuritsin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SegmentItem.h"

@interface TopSegmentBar : UIControl
{
    @protected
        NSMutableArray *_itemsView;
}

- (id)initWithItems:(NSArray *)items;

@property (nonatomic) NSInteger currentIndex;
@property (nonatomic) NSInteger itemsCount;

- (void)setShowItem:(BOOL)show index:(NSInteger)index;
- (void)setEnabledItem:(BOOL)enabled index:(NSInteger)index;


@end
