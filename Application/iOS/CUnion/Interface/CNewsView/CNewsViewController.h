//
//  CNewsViewController.h
//  CUnion
//
//  Created by Andrey Kuritsin on 16.10.12.
//  Copyright (c) 2012 Andrey Kuritsin. All rights reserved.
//

#import "ViewController.h"

#import "GMGridView.h"
#import "CUNewsItemsModel.h"

@class TopSegmentBar;

@interface CNewsViewController : ViewController<GMGridViewActionDelegate, GMGridViewDataSource,CUModelDelegate>
{
    @protected
    GMGridView *_gridView;
    NSArray *_imageNames;
    
    CUModel          *_themeNewsModel;
    CUNewsItemsModel *_itemsNewsModel;
    NSMutableArray *_newsList;
    NSMutableArray *_newsItems;
    
    NSMutableArray *_cachedNewsItems;
    
    TopSegmentBar *_newsBar;

    BOOL _newsLoading;

}
@property (strong, nonatomic) IBOutlet UIView *topTitleView;
@property (strong, nonatomic) IBOutlet UIView *menuView;
@property (strong, nonatomic) IBOutlet UILabel *newsTitle;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

- (void)layoutInterface;
@end
