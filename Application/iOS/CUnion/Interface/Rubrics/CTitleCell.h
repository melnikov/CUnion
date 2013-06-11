//
//  CTitleCell.h
//  CUnion
//
//  Created by Andrey Kuritsin on 26.11.12.
//  Copyright (c) 2012 Andrey Kuritsin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTitleCell : UITableViewCell
{
    
}

@property (nonatomic, readonly) UILabel *titleLabel;
@property (nonatomic, readonly) UILabel *shortLabel;
@property (nonatomic, readonly) UILabel *dateLabel;

+ (CGFloat)cellHeight;

@end
