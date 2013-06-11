//
//  CRubricsViewController.m
//  CUnion
//
//  Created by Andrey Kuritsin on 26.11.12.
//  Copyright (c) 2012 Andrey Kuritsin. All rights reserved.
//

#import "CRubricsViewController.h"
#import "CPhotoContentViewController.h"
#import "CURubricListModel.h"
#import "CURubricItemsModel.h"
#import "TopSegmentBar.h"
#import "UIViewController+ActivityIndicator.h"
#import "CTitleCell.h"

#define MENU_ITEM_W 180.0f

@interface CRubricsViewController ()

@end

@implementation CRubricsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    _rubricItemsModel.delegate = nil;
    [_rubricItemsModel cancel];
    _rubricItemsModel = nil;
    
    _rubricListModel.delegate = nil;
    [_rubricListModel cancel];
    _rubricListModel = nil;
    
    [self hideActivityIndicator];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _topTitleView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"title_bg.png"]];
    
    _rubricsList = [[NSMutableArray alloc] init];
    
    _rubricItems = [[NSMutableArray alloc] init];
    _cachedRubricItems = [[NSMutableArray alloc] init];
    
    _arhiveItems = [[NSMutableArray alloc] init];
    _cachedArhiveItems = [[NSMutableArray alloc] init];
    
    _rubricListModel = [[CURubricListModel alloc] init];
    [(CURubricListModel *)_rubricListModel setParentID:0];
    _rubricListModel.delegate = self;
    [(CURubricListModel *)_rubricListModel refresh:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)layoutInterface
{
    CGSize size = self.view.bounds.size;
    
    CGRect oldRect = _menuView.frame;
    CGRect newRect = CGRectMake(0.0f, oldRect.origin.y, size.width, oldRect.size.height);
    
    _menuView.frame = newRect;
    
    if (_rubricsList.count > 0)
    {
        _rubricsBar.frame = CGRectMake(0.0f, 0.0f, MENU_ITEM_W * _rubricsList.count, oldRect.size.height);
        _menuView.contentSize = _rubricsBar.frame.size;
    }
    
    CGFloat y = newRect.origin.y + newRect.size.height;
    _tableView.frame = CGRectMake(20.0f, y, size.width - 40.0f, size.height - y);
}

#pragma mark - Private

- (void)_selectBarItem:(TopSegmentBar *)topBar
{
    if (_rubricsList.count > topBar.currentIndex)
    {
        [_rubricItemsModel cancel];
        _rubricItemsModel.delegate = nil;
        
        NSDictionary *dict = [_rubricsList objectAtIndex:topBar.currentIndex];
        
        _rubricItemsModel = [[CURubricItemsModel alloc] init];
        _rubricItemsModel.delegate = self;
        [(CURubricItemsModel *)_rubricItemsModel setThemeCount:20];
        [(CURubricItemsModel *)_rubricItemsModel setThemeOffset:0];
        
        _rubricID = [[dict objectForKey:@"@id"] intValue];
       
        [(CURubricItemsModel *)_rubricItemsModel setRubricID:_rubricID];
        
        [_rubricItems removeAllObjects];
        [_arhiveItems removeAllObjects];
        
        [_tableView reloadData];
        
        [_rubricItemsModel refresh:nil];
    }
    else
    {
        [self hideActivityIndicator];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

    // Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _rubricItems.count;
}

    // Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"cell";
	
    CTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        cell = [[CTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    NSDictionary *item = [_rubricItems objectAtIndex:indexPath.row];
    
    cell.dateLabel.text = [item objectForKey:@"@publish_date"];
    cell.titleLabel.text = [item objectForKey:@"@title"];
    cell.shortLabel.text = [item objectForKey:@"short"];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [CTitleCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CContentViewController *contentViewController = nil;
    
    if (_rubricID == 242)
    {
        contentViewController = [CPhotoContentViewController viewController];
    }
    else
    {
        contentViewController = [CContentViewController viewController];
    }
    
    contentViewController.item = [_rubricItems objectAtIndex:indexPath.row];
    contentViewController.modalPresentationStyle = UIModalPresentationPageSheet;
    [self presentViewController:contentViewController animated:YES completion:^{
        
    }];
}

#pragma mark - UISCrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        if (!_rubricsLoading  && (scrollView.contentOffset.y + scrollView.bounds.size.height) == scrollView.contentSize.height)
        {
            _rubricItemsModel.themeOffset += _rubricItemsModel.themeCount;
            [_rubricItemsModel refresh:nil];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (_rubricsLoading == NO && (scrollView.contentOffset.y + scrollView.bounds.size.height) == scrollView.contentSize.height)
    {
        if (!_rubricsLoading  && (scrollView.contentOffset.y + scrollView.bounds.size.height) == scrollView.contentSize.height)
        {
            _rubricItemsModel.themeOffset += _rubricItemsModel.themeCount;
            [_rubricItemsModel refresh:nil];
        }
    }
}

#pragma mark - CUModelDelegate<NSObject>

- (void)model:(CUModel*)model_ serverError:(NSError*)error_
{
    [self hideActivityIndicator];
    
    _rubricsLoading = NO;
}

- (void)modelDidUpdatedFromServer:(CUModel*)model_
{
    if (model_ == _rubricListModel)
    {
        [_rubricsList removeAllObjects];
        
        NSArray *rubrics = [[[[model_ items] lastObject] objectForKey:@"rubrics"] objectForKey:@"item"];
        
        [self _parseRubricsList:rubrics];
        
    }
    else if(model_ == _rubricItemsModel)
    {
        FTLog(@"%@",[model_ items]);
        
        NSArray *rubricItems = [[[[model_ items] lastObject] objectForKey:@"news"] objectForKey:@"item"];
        
        [self _parseRubricsItems:rubricItems fromServer:YES];
    }
    
    _rubricsLoading = NO;
}

- (void)modelDidUpdatedFromCache:(CUModel*)model_
{
    if (model_ == _rubricListModel)
    {
        [_rubricsList removeAllObjects];
        
        NSArray *rubrics = [[[[model_ items] lastObject] objectForKey:@"rubrics"] objectForKey:@"item"];
        
        [self _parseRubricsList:rubrics];
    }
    else if(model_ == _rubricItemsModel)
    {
        NSArray *rubricItems = [[[[model_ items] lastObject] objectForKey:@"news"] objectForKey:@"item"];
        
       [self _parseRubricsItems:rubricItems fromServer:NO];
    }
}

- (void)modelStartLoadFromServer:(CUModel*)model_
{
    [self showActivityIndicator];
    
    _rubricsLoading = YES;
}


- (void)_parseRubricsList:(NSArray *)rubrics
{
    if (rubrics.count)
    {
        [_rubricsList addObjectsFromArray:rubrics];
    }
    
    SegmentItem *item = nil;
    NSMutableArray *menuItems = [[NSMutableArray alloc] init];
    
    if(_rubricsList.count > 0)
    {
        for(NSDictionary *itemDict in _rubricsList)
        {
            item = [[SegmentItem alloc] init];
            item.roundedBack = YES;
            
            item.title = [itemDict objectForKey:@"@title"];
            item.backHighlitedImage = [UIImage imageNamed:@"econom.png"];
            [menuItems addObject:item];
        }
    }
    
    if(_rubricsBar)
    {
        [_rubricsBar removeFromSuperview];
    }
    
    _rubricsBar = [[TopSegmentBar alloc] initWithItems:menuItems];
    [_rubricsBar addTarget:self action:@selector(_selectBarItem:) forControlEvents:UIControlEventValueChanged];
    
    [_menuView addSubview:_rubricsBar];
    
    [self layoutInterface];
    
    _rubricsBar.currentIndex = 0;
    
    if (_rubricsList.count > 0)
    {
        [_arhiveItems removeAllObjects];
        
        NSDictionary *dict = [_rubricsList objectAtIndex:0];
        
        _rubricItemsModel = [[CURubricItemsModel alloc] init];
        _rubricItemsModel.delegate = self;
        [(CURubricItemsModel *)_rubricItemsModel setThemeCount:10];
        [(CURubricItemsModel *)_rubricItemsModel setThemeOffset:0];
        
        _rubricID = [[dict objectForKey:@"@id"] intValue];
        
        [(CURubricItemsModel *)_rubricItemsModel setRubricID:_rubricID];
        
        [_rubricItemsModel refresh:nil];
    }
    else
    {
        [self hideActivityIndicator];
    }
}

- (void)_parseRubricsItems:(NSArray *)rubricItems fromServer:(BOOL)yesOrNo
{
    BOOL flag = NO;
    for (NSDictionary *dict in rubricItems)
    {
        if ([dict objectForKey:@"content"])
        {
            flag = YES;
            
            break;
        }
    }
    
    if (flag || !rubricItems)
    {
        
        if (yesOrNo)
        {
            for (id obj in _cachedRubricItems)
            {
                [_rubricItems removeObject:obj];
            }
            
            [_cachedRubricItems removeAllObjects];
        }
        else
        {
            [_cachedRubricItems removeAllObjects];
            if (rubricItems.count)
            {
                [_cachedRubricItems addObjectsFromArray:rubricItems];
            }
        }
        
        if (rubricItems.count)
        {
            [_rubricItems addObjectsFromArray:rubricItems];
        }
        
        [_tableView reloadData];
        
        [self hideActivityIndicator];
    }
    else
    {
        if (yesOrNo)
        {
            for (id obj in _cachedArhiveItems)
            {
                [_arhiveItems removeObject:obj];
            }
            
            [_cachedArhiveItems removeAllObjects];
        }
        else
        {
            [_cachedArhiveItems removeAllObjects];
            if (rubricItems.count)
            {
                [_cachedArhiveItems addObjectsFromArray:rubricItems];
            }
        }
        
        if (rubricItems.count)
        {
            [_arhiveItems addObjectsFromArray:rubricItems];
            [_arhiveItems sortUsingComparator:^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2) {
                
                NSInteger val1 = [[obj1 objectForKey:@"@title"] intValue];
                NSInteger val2 = [[obj2 objectForKey:@"@title"] intValue];
                
                if (val1 > val2)
                {
                    return NSOrderedAscending;
                }
                else if (val1 < val2)
                {
                    return NSOrderedDescending;
                }
                
                return NSOrderedSame;
            }];
            
            NSInteger rubricID = [[[_arhiveItems objectAtIndex:0] objectForKey:@"@id"] intValue];
            
            
            [(CURubricItemsModel *)_rubricItemsModel setRubricID:rubricID];
            [_rubricItemsModel refresh:nil];
        }
        else
        {
            [self hideActivityIndicator];
        }
    }
}

- (void)_clearNewsItemsFromCached
{
    for (id obj in _cachedRubricItems)
    {
        [_rubricItems removeObject:obj];
    }
    
    [_cachedRubricItems removeAllObjects];
}



@end
