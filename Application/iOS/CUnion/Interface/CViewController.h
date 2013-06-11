//
//  CViewController.h
//  CUnion
//
//  Created by Andrey Kuritsin on 16.10.12.
//  Copyright (c) 2012 Andrey Kuritsin. All rights reserved.
//

#import "ViewController.h"
#import "GMGridView.h"
#import "CUModel.h"
#import "CContentViewController.h"

@class TopSegmentBar;
@class CNewsViewController;
@class CRubricsViewController;
@class CContentViewController;
@class CComitetViewController;
@class CDocViewController;

@interface CViewController : ViewController<GMGridViewActionDelegate, GMGridViewDataSource,CUModelDelegate, CContentViewControllerDelegate>
{
    @protected
        UIViewController *_currentCotnroller;
    
        CNewsViewController *_newsViewController;
        CRubricsViewController *_rubricsViewController;
    
        CComitetViewController *_comitetViewController;
        CDocViewController *_docViewController;
        NSInteger contentOffset;
    
        TopSegmentBar *_topSegmentBar;
        GMGridView *_gridView;
    
        NSArray *_imageNames;
    // CUModels
        CUModel *_themeNewsModel;
        CUModel *_rubricListModel;
        CUModel *_rubricItemsModel;
        CUModel *_highModel;
        CUModel *_mainModel;
    
        CContentViewController *_contentViewController;
}

@property (strong, nonatomic) IBOutlet UIView *leftTitleView;
@property (strong, nonatomic) IBOutlet UIView *rightTitleView;
@property (strong, nonatomic) IBOutlet UIButton *refreshBtn;
@property (strong, nonatomic) IBOutlet UIButton *chatBtn;

@property (strong, nonatomic) IBOutlet UIView *topInfoView;
@property (strong, nonatomic) IBOutlet UIView *gridContentView;
@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic) IBOutlet UIView *contentView;

- (IBAction)chatAction:(id)sender;
- (IBAction)refreshAction:(id)sender;

@end
