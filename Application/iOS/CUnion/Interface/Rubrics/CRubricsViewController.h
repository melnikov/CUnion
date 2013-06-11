//
//  CRubricsViewController.h
//  CUnion
//
//  Created by Andrey Kuritsin on 26.11.12.
//  Copyright (c) 2012 Andrey Kuritsin. All rights reserved.
//

#import "TableViewController.h"
#import "CURubricItemsModel.h"

@class TopSegmentBar;

@interface CRubricsViewController : TableViewController<CUModelDelegate>
{
    @protected
        CUModel *_rubricListModel;
        CURubricItemsModel *_rubricItemsModel;
    
        NSMutableArray *_rubricsList;
    
        NSMutableArray *_rubricItems;
        NSMutableArray *_cachedRubricItems;
    
        NSMutableArray *_arhiveItems;
        NSMutableArray *_cachedArhiveItems;
    
        BOOL _loadArhive;
        BOOL _rubricsLoading;
    
        NSInteger _rubricID;
    
        TopSegmentBar *_rubricsBar;
}

@property (strong, nonatomic) IBOutlet UIView *topTitleView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIScrollView *menuView;

- (void)layoutInterface;

@end
