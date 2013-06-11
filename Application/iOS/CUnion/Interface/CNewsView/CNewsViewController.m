//
//  CNewsViewController.m
//  CUnion
//
//  Created by Andrey Kuritsin on 16.10.12.
//  Copyright (c) 2012 Andrey Kuritsin. All rights reserved.
//

#import "CNewsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "GMGridViewLayoutStrategies.h"
#import "TopSegmentBar.h"
#import "CUThemeNewsModel.h"
#import "CUNewsItemsModel.h"
#import "UIViewController+ActivityIndicator.h"
#import "CTitleCell.h"
#import "CContentViewController.h"

#define MENU_ITEM_W 180.0f

@interface CNewsViewController ()

@end

@implementation CNewsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    _themeNewsModel.delegate = nil;
    [_themeNewsModel cancel];
    _themeNewsModel = nil;
    
    _itemsNewsModel.delegate = nil;
    [_itemsNewsModel cancel];
    _itemsNewsModel = nil;
    
    [self hideActivityIndicator];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _topTitleView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"top_bar_bg.png"]];
    
    _newsList = [[NSMutableArray alloc] init];
    _newsItems = [[NSMutableArray alloc] init];
    _cachedNewsItems = [[NSMutableArray alloc] init];
    
    _themeNewsModel = [[CUThemeNewsModel alloc] init];
    _themeNewsModel.delegate = self;
    [(CUThemeNewsModel *)_themeNewsModel refresh:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [UIView animateWithDuration:duration animations:^{
        
        [self _layoutToInterfaceOrientation:toInterfaceOrientation];
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    
}

- (void)layoutInterface;
{
    CGSize size = self.view.bounds.size;
    
    _topTitleView.frame = CGRectMake(0, 0, size.width, 34);
    
    if(UIInterfaceOrientationIsPortrait(self.interfaceOrientation))
    {
        
        _gridView.layoutStrategy = [GMGridViewLayoutStrategyFactory strategyFromType:GMGridViewLayoutHorizontal];
        
        _menuView.frame = CGRectMake(0.0f, 34.0f, 768.0f, 146.0f);
    
        _tableView.frame = CGRectMake(20.0f, 170, size.width - 40.0f, size.height - 170);
    }
    else
    {
        _gridView.layoutStrategy = [GMGridViewLayoutStrategyFactory strategyFromType:GMGridViewLayoutVertical];
        
        _menuView.frame = CGRectMake(0.0f, 34, 280, size.height - 34);
        
        _tableView.frame = CGRectMake(290.0f, 34, size.width - 300.0f, size.height - 34);

    }
    
    [_gridView reloadData];
}

#pragma mark - Private
- (void)_layoutToInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    if (UIInterfaceOrientationIsPortrait(orientation))
    {

    }
}

- (void)_selectBarItem:(TopSegmentBar *)topBar
{
    if (_newsList.count > topBar.currentIndex)
    {
        [_itemsNewsModel cancel];
        _itemsNewsModel.delegate = nil;
        
        NSDictionary *dict = [_newsList objectAtIndex:topBar.currentIndex];
        
        _itemsNewsModel = [[CUNewsItemsModel alloc] init];
        _itemsNewsModel.delegate = self;
        [(CUNewsItemsModel *)_itemsNewsModel setThemeCount:10];
        [(CUNewsItemsModel *)_itemsNewsModel setThemeOffset:0];
        
        NSInteger index = [[dict objectForKey:@"@id"] intValue];
        
        [(CUNewsItemsModel *)_itemsNewsModel setRubricID:index];
        
        [_itemsNewsModel refresh:nil];
    }
    else
    {
        [self hideActivityIndicator];
    }
}

#pragma mark - GMGridViewDataSource

- (NSInteger)numberOfItemsInGMGridView:(GMGridView *)gridView
{
    return _newsList.count;
}

- (CGSize)sizeForItemsInGMGridView:(GMGridView *)gridView
{
    return CGSizeMake(126, 125);
}

- (GMGridViewCell *)GMGridView:(GMGridView *)gridView cellForItemAtIndex:(NSInteger)index
{
    CGSize size = [self sizeForItemsInGMGridView:gridView];
    
    GMGridViewCell *cell = [gridView dequeueReusableCell];
    
    UIImageView *imageContentView = nil;
    
    if (!cell)
    {
        cell = [[GMGridViewCell alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        
        imageContentView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        imageContentView.backgroundColor = [UIColor clearColor];
        imageContentView.layer.masksToBounds = NO;
        
        cell.contentView = imageContentView;
    }
    else
    {
        imageContentView = (UIImageView *)cell.contentView;
    }
    
    NSInteger rubricID = [[[_newsList objectAtIndex:index] objectForKey:@"@id"] integerValue];
    
    switch (rubricID)
    {
        case 402:
            imageContentView.image = [UIImage imageNamed:@"news_402.png"];
            break;
        case 403:
            imageContentView.image = [UIImage imageNamed:@"news_403.png"];
            break;
        case 366:
            imageContentView.image = [UIImage imageNamed:@"news_366.png"];
            break;
        case 279:
            imageContentView.image = [UIImage imageNamed:@"news_279.png"];
            break;
        case 245:
            imageContentView.image = [UIImage imageNamed:@"news_245.png"];
            break;
        case 246:
            imageContentView.image = [UIImage imageNamed:@"news_246.png"];
            break;
        case 249:
            imageContentView.image = [UIImage imageNamed:@"news_249.png"];
            break;
        case 252:
            imageContentView.image = [UIImage imageNamed:@"news_252.png"];
            break;
        case 254:
            imageContentView.image = [UIImage imageNamed:@"news_254.png"];
            break;
        case 255:
            imageContentView.image = [UIImage imageNamed:@"news_255.png"];
            break;
        case 256:
            imageContentView.image = [UIImage imageNamed:@"news_256.png"];
            break;
        case 257:
            imageContentView.image = [UIImage imageNamed:@"news_257.png"];
            break;
        case 259:
            imageContentView.image = [UIImage imageNamed:@"news_259.png"];
            break;
        case 262:
            imageContentView.image = [UIImage imageNamed:@"news_262.png"];
            break;

        default:
            imageContentView.image = [UIImage imageNamed:@"news.png"];
            break;
    }
    return cell;
}

#pragma mark - Protocol GMGridViewActionDelegate

- (void)GMGridView:(GMGridView *)gridView didTapOnItemAtIndex:(NSInteger)position
{
    if (_newsList.count > position)
    {
        [_newsItems removeAllObjects];
        [_cachedNewsItems removeAllObjects];
        
        [_tableView reloadData];
        
        [_itemsNewsModel cancel];
        _itemsNewsModel.delegate = nil;
        
        NSDictionary *dict = [_newsList objectAtIndex:position];
        
        _itemsNewsModel = [[CUNewsItemsModel alloc] init];
        _itemsNewsModel.delegate = self;
        [(CUNewsItemsModel *)_itemsNewsModel setThemeCount:20];
        [(CUNewsItemsModel *)_itemsNewsModel setThemeOffset:0];
        
        NSInteger index = [[dict objectForKey:@"@id"] intValue];
        
        [(CUNewsItemsModel *)_itemsNewsModel setRubricID:index];
        
        [_itemsNewsModel refresh:nil];
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
    return _newsItems.count;
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
    
    NSDictionary *item = [_newsItems objectAtIndex:indexPath.row];
    
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
    
    CContentViewController *contentViewController = [CContentViewController viewController];
    contentViewController.item = [_newsItems objectAtIndex:indexPath.row];
    contentViewController.modalPresentationStyle = UIModalPresentationPageSheet;
    [self presentViewController:contentViewController animated:YES completion:^{
        
    }];
}

#pragma mark - UISCrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        if (!_newsLoading  && (scrollView.contentOffset.y + scrollView.bounds.size.height) == scrollView.contentSize.height)
        {
            _itemsNewsModel.themeOffset += _itemsNewsModel.themeCount;
            [_itemsNewsModel refresh:nil];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (_newsLoading == NO && (scrollView.contentOffset.y + scrollView.bounds.size.height) == scrollView.contentSize.height)
    {
        if (!_newsLoading  && (scrollView.contentOffset.y + scrollView.bounds.size.height) == scrollView.contentSize.height)
        {
            _itemsNewsModel.themeOffset += _itemsNewsModel.themeCount;
            [_itemsNewsModel refresh:nil];
        }
    }
}

#pragma mark - CUModelDelegate<NSObject>

- (void)model:(CUModel*)model_ serverError:(NSError*)error_
{
    [self hideActivityIndicator];
    
    _newsLoading = NO;
}

- (void)modelDidUpdatedFromServer:(CUModel*)model_
{
    if (model_ == _themeNewsModel)
    {
        [_newsList removeAllObjects];
        
        NSArray *rubrics = [[[[model_ items] lastObject] objectForKey:@"rubrics"] objectForKey:@"item"];
        
        [self _parseThemeItems:rubrics];
    }
    else if(model_ == _itemsNewsModel)
    {
        [self _clearNewsItemsFromCached];
        
        FTLog(@"%@",[model_ items]);
        NSArray *rubricItems = [[[[model_ items] lastObject] objectForKey:@"news"] objectForKey:@"item"];
        
        if (rubricItems.count)
        {
            [_newsItems addObjectsFromArray:rubricItems];
        }
        
        FTLog(@"%@",_newsItems);
        
        [_tableView reloadData];
        
        [self hideActivityIndicator];
    }
    
    _newsLoading = NO;
}

- (void)modelDidUpdatedFromCache:(CUModel*)model_
{
    if (model_ == _themeNewsModel)
    {
        [_newsList removeAllObjects];
        
        NSArray *rubrics = [[[[model_ items] lastObject] objectForKey:@"rubrics"] objectForKey:@"item"];
        
        [self _parseThemeItems:rubrics];
    }
    else if(model_ == _itemsNewsModel)
    {
        
        FTLog(@"%@",[model_ items]);
        NSArray *rubricItems = [[[[model_ items] lastObject] objectForKey:@"news"] objectForKey:@"item"];
        
        [_cachedNewsItems removeAllObjects];
        
        if (rubricItems.count)
        {
            [_cachedNewsItems addObjectsFromArray:rubricItems];
            [_newsItems addObjectsFromArray:rubricItems];
        }
        
        FTLog(@"%@",_newsItems);
        
        [_tableView reloadData];
        
        [self hideActivityIndicator];
    }
}

- (void)modelStartLoadFromServer:(CUModel*)model_
{
    [self showActivityIndicator];
    
    _newsLoading = YES;
}

#pragma mark - Private

- (void)_parseThemeItems:(NSArray *)rubrics
{
    if (rubrics.count)
    {
        [_newsList addObjectsFromArray:rubrics];
    }
    
    if(_gridView !=nil)
    {
        [_gridView removeFromSuperview];
    }
    
    _gridView = [[GMGridView alloc] initWithFrame:_menuView.bounds];
    _gridView.dataSource = self;
    _gridView.actionDelegate = self;
    _gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _gridView.style = GMGridViewStylePush;
    _gridView.itemSpacing = 10;
    _gridView.minEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    _gridView.centerGrid = YES;
    _gridView.layoutStrategy = [GMGridViewLayoutStrategyFactory strategyFromType:GMGridViewLayoutHorizontal];
    
    [_menuView addSubview:_gridView];
    
    [self layoutInterface];
    
    _newsBar.currentIndex = 0;
    
    if (_newsList.count > 0)
    {
        NSDictionary *dict = [_newsList objectAtIndex:0];
        
        _itemsNewsModel = [[CUNewsItemsModel alloc] init];
        _itemsNewsModel.delegate = self;
        [(CUNewsItemsModel *)_itemsNewsModel setThemeCount:10];
        [(CUNewsItemsModel *)_itemsNewsModel setThemeOffset:0];
        
        NSInteger index = [[dict objectForKey:@"@id"] intValue];
        
        [(CUNewsItemsModel *)_itemsNewsModel setRubricID:index];
        
        [_itemsNewsModel refresh:nil];
    }
    else
    {
        [self hideActivityIndicator];
    }
}

- (void)_clearNewsItemsFromCached
{
    for (id obj in _cachedNewsItems)
    {
        [_newsItems removeObject:obj];
    }
    
    [_cachedNewsItems removeAllObjects];
}

@end
