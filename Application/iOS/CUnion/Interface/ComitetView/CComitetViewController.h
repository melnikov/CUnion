//
//  CComitetViewController.h
//  CUnion
//
//  Created by Yuriy Nezhura on 12/3/12.
//  Copyright (c) 2012 Andrey Kuritsin. All rights reserved.
//

#import "ViewController.h"
#import "CUComitetItemsModel.h"
#import "CUComitetContentModel.h"
#import "CContentViewController.h"

@interface CComitetViewController : ViewController<CUModelDelegate, CContentViewControllerDelegate>
{
    CUComitetItemsModel          *_comitetItemsModel;
    CUComitetContentModel *_comitetContentModel;
    
    NSMutableArray *_comitetItemsList;
    
    CContentViewController *_contentViewController;
}
@property (strong, nonatomic) IBOutlet UIView *topTitleView;
@property (strong, nonatomic) IBOutlet UILabel *newsTitle;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

- (void)layoutInterface;
@end
