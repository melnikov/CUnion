//
//  CDocViewController.h
//  CUnion
//
//  Created by Yuriy Nezhura on 12/13/12.
//  Copyright (c) 2012 Andrey Kuritsin. All rights reserved.
//

#import "ViewController.h"
#import "CUComitetItemsModel.h"
#import "CUComitetContentModel.h"
#import "CContentViewController.h"

@class TopSegmentBar;

@interface CDocViewController : ViewController<CUModelDelegate,CContentViewControllerDelegate>
{
    CContentViewController *_contentViewController;
    
    CUComitetItemsModel *_documentsItemsModel;
    CUComitetItemsModel *_documentsSubItemsModel;
    CUComitetContentModel *_documentsContentModel;
    
    NSMutableArray *_documentsYearList;
    NSMutableArray *_documentsItemsList;
    TopSegmentBar *_yearsBar;
    
    NSInteger _yearID;
}

@property (strong, nonatomic) IBOutlet UIView *topTitleView;
@property (strong, nonatomic) IBOutlet UIScrollView *yearGroupsView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

-(void) layoutInterface;
@end
