//
//  CTitleCell.m
//  CUnion
//
//  Created by Andrey Kuritsin on 26.11.12.
//  Copyright (c) 2012 Andrey Kuritsin. All rights reserved.
//

#import "CTitleCell.h"

#define FONT_SIZE 14.0f

#define DATE_LABEL_H  18.0f
#define TITLE_LABEL_H 40.0f
#define SHORT_LABEL_H 60.0f

#define SPACE 2.0f

@implementation CTitleCell

+ (CGFloat)cellHeight
{
    return (2 * SPACE + DATE_LABEL_H + TITLE_LABEL_H + SHORT_LABEL_H + 10);
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:FONT_SIZE];
        _titleLabel.numberOfLines = 0;
        [self.contentView addSubview:_titleLabel];
        
        _shortLabel = [[UILabel alloc] init];
        _shortLabel.backgroundColor = [UIColor clearColor];
        _shortLabel.textColor = [UIColor blackColor];
        _shortLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
        _shortLabel.numberOfLines = 0;
        [self.contentView addSubview:_shortLabel];
        
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.backgroundColor = [UIColor clearColor];
        _dateLabel.textColor = [UIColor blackColor];
        _dateLabel.font = [UIFont boldSystemFontOfSize:FONT_SIZE];
        _dateLabel.numberOfLines = 0;
        [self.contentView addSubview:_dateLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize size = self.contentView.bounds.size;
    
    CGFloat x,y,w,h;
    
    w = size.width - 2 * SPACE;
    x = SPACE;
    y = SPACE;
    h = DATE_LABEL_H;
    
    _dateLabel.frame = CGRectMake(x, y, w, h);
    
    y += h;
    h = TITLE_LABEL_H;
    
    _titleLabel.frame = CGRectMake(x, y, w, h);
    
    y += h;
    h = SHORT_LABEL_H;
    
    _shortLabel.frame = CGRectMake(x, y, w, h);
}

@end
