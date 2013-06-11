//
//  CDocViewController.m
//  CUnion
//
//  Created by Yuriy Nezhura on 12/13/12.
//  Copyright (c) 2012 Andrey Kuritsin. All rights reserved.
//

#import "CDocViewController.h"
#import "TopSegmentBar.h"
#import "UIViewController+ActivityIndicator.h"

#define MENU_ITEM_W 120.0f

@interface CDocViewController ()

@end

@implementation CDocViewController

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
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _topTitleView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"title_bg.png"]];

    _documentsYearList = [[NSMutableArray alloc] init];
    _documentsItemsList = [[NSMutableArray alloc] init];
    
    
    _documentsItemsModel = [[CUComitetItemsModel alloc] init];
    _documentsItemsModel.delegate = self;
    [(CUComitetItemsModel *)_documentsItemsModel setRubricID:237];
    [(CUComitetItemsModel *)_documentsItemsModel setThemeOffset:0];
    [(CUComitetItemsModel *)_documentsItemsModel setThemeCount:100];
    [(CUComitetItemsModel *)_documentsItemsModel refresh:nil];
    
    
    _documentsSubItemsModel = [[CUComitetItemsModel alloc] init];
    _documentsSubItemsModel.delegate = self;
    
    _documentsContentModel = [[CUComitetContentModel alloc] init];
    _documentsContentModel.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) layoutInterface
{
    CGSize size = self.view.bounds.size;
    _topTitleView.frame = CGRectMake(0, 0, size.width, 34);
   
    CGRect oldRect = _yearGroupsView.frame;
    CGRect newRect = CGRectMake(0, 34, size.width, 34);
    
    _yearGroupsView.frame = newRect;
    
    if (_documentsYearList.count > 0)
    {
        _yearsBar.frame = CGRectMake(5.0f, 5.0f, (MENU_ITEM_W * _documentsYearList.count)+5, oldRect.size.height-5);
        _yearGroupsView.contentSize = _yearsBar.frame.size;
    }
    
    _tableView.frame = CGRectMake(20.0f, 68, size.width - 40.0f, size.height - 68);
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dict = [_documentsItemsList objectAtIndex:indexPath.row];
    
    
    NSInteger _documentID = [[dict objectForKey:@"@id"] intValue];
    
    [_documentsContentModel setRubricID:_documentID];
    [_documentsContentModel refresh:nil];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _documentsItemsList.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"cell";
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    NSDictionary *item = [_documentsItemsList objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [item objectForKey:@"@title"];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    cell.textLabel.numberOfLines = 0;
    
    return cell;
}


#pragma mark - Private

- (void)_selectBarItem:(TopSegmentBar *)topBar
{
    if (_documentsYearList.count > topBar.currentIndex)
    {
        [_documentsSubItemsModel cancel];
        _documentsSubItemsModel.delegate = nil;
        
        [_documentsItemsList removeAllObjects];
        [_tableView reloadData];

        NSDictionary *dict = [_documentsYearList objectAtIndex:topBar.currentIndex];
        
        _documentsSubItemsModel = [[CUComitetItemsModel alloc] init];
        _documentsSubItemsModel.delegate = self;
        [_documentsSubItemsModel setThemeCount:100];
        [_documentsSubItemsModel setThemeOffset:0];
        
        _yearID = [[dict objectForKey:@"@id"] intValue];
        
        [_documentsSubItemsModel setRubricID:_yearID];
        
        [_documentsItemsList removeAllObjects];
        
        [_documentsSubItemsModel refresh:nil];
    }
    else
    {
        [self hideActivityIndicator];
    }
}


#pragma mark - CUModelDelegate<NSObject>

- (void)model:(CUModel*)model_ serverError:(NSError*)error_
{
    [self hideActivityIndicator];
    
}

- (void)modelDidUpdatedFromServer:(CUModel*)model_
{
    if (model_ == _documentsItemsModel)
    {
        [_documentsYearList removeAllObjects];
        
        NSArray *yearGroups = [[[[model_ items] lastObject] objectForKey:@"news"] objectForKey:@"item"];
        
        [self _parseYearsItems:yearGroups];
    }
    else if(model_ == _documentsSubItemsModel)
    {
        [_documentsItemsList removeAllObjects];
        
        NSArray *yearItems = [[[[model_ items] lastObject] objectForKey:@"news"] objectForKey:@"item"];
        
        [self _parseYearItems:yearItems];
    }
    else if (model_ == _documentsContentModel)
    {
        if (!_contentViewController)
        {
            _contentViewController = [CContentViewController viewController];
            _contentViewController.delegate = self;
            _contentViewController.item = [[[[model_ items] lastObject] objectForKey:@"news"] objectForKey:@"item"];
            _contentViewController.modalPresentationStyle = UIModalPresentationPageSheet;
            [self presentViewController:_contentViewController animated:YES completion:^{
                
            }];
        }
        else
        {
            _contentViewController.item = [[[[model_ items] lastObject] objectForKey:@"news"] objectForKey:@"item"];
            [_contentViewController refresh];
        }
        
        
    }
    [self hideActivityIndicator];
}

- (void)modelDidUpdatedFromCache:(CUModel*)model_
{
    if (model_ == _documentsItemsModel)
    {
        [_documentsYearList removeAllObjects];
        
        NSArray *yearGroups = [[[[model_ items] lastObject] objectForKey:@"news"] objectForKey:@"item"];
        
        [self _parseYearsItems:yearGroups];
    }
    else if(model_ == _documentsSubItemsModel)
    {
        [_documentsItemsList removeAllObjects];
        
        NSArray *yearItems = [[[[model_ items] lastObject] objectForKey:@"news"] objectForKey:@"item"];
        
        [self _parseYearItems:yearItems];
    }
    else if (model_ == _documentsContentModel)
    {
        
        if (_contentViewController)
        {
            [_contentViewController dismissModalViewControllerAnimated:NO];
        }
        
        _contentViewController = [CContentViewController viewController];
        _contentViewController.delegate = self;
        _contentViewController.item = [[[[model_ items] lastObject] objectForKey:@"news"] objectForKey:@"item"];
        _contentViewController.modalPresentationStyle = UIModalPresentationPageSheet;
        [self presentViewController:_contentViewController animated:YES completion:^{
            
        }];
        
        
    }
}

- (void)modelStartLoadFromServer:(CUModel*)model_
{
    [self showActivityIndicator];
}

- (void)_parseYearsItems:(NSArray *)yearGroups
{
    if (yearGroups.count)
    {
        [_documentsYearList addObjectsFromArray:yearGroups];
    }
    
    SegmentItem *item = nil;
    NSMutableArray *menuItems = [[NSMutableArray alloc] init];
    
    if(_documentsYearList.count > 0)
    {
        for(NSDictionary *itemDict in _documentsYearList)
        {
            item = [[SegmentItem alloc] init];
            item.roundedBack = YES;
            
            item.title = [itemDict objectForKey:@"@title"];
            item.backHighlitedImage = [UIImage imageNamed:@"econom.png"];
            [menuItems addObject:item];
        }
    }
    
    if(_yearsBar)
    {
        [_yearsBar removeFromSuperview];
    }
    
    _yearsBar = [[TopSegmentBar alloc] initWithItems:menuItems];
    [_yearsBar addTarget:self action:@selector(_selectBarItem:) forControlEvents:UIControlEventValueChanged];
    _yearsBar.frame = _yearGroupsView.frame;
    
    [_yearGroupsView addSubview:_yearsBar];
    
    [self layoutInterface];
    
    _yearsBar.currentIndex = 0;
    
    if (_documentsYearList.count > 0)
    {
        [_documentsItemsList removeAllObjects];
        
        NSDictionary *dict = [_documentsYearList objectAtIndex:0];
        
        [_documentsSubItemsModel setThemeCount:10];
        [_documentsSubItemsModel setThemeOffset:0];
        
        _yearID = [[dict objectForKey:@"@id"] intValue];
        
        [(CUComitetItemsModel *)_documentsSubItemsModel setRubricID:_yearID];
        
        [_documentsSubItemsModel refresh:nil];
    }
    else
    {
        [self hideActivityIndicator];
    }
}

- (void)_parseYearItems:(NSArray *)yearItems
{
    if (yearItems.count)
    {
        [_documentsItemsList addObjectsFromArray:yearItems];
    }
    [_tableView reloadData];
}

#pragma mark - CContentViewControllerDelegate <NSObject>

- (void)contentViewControllerDidHide:(CContentViewController *)controller
{
    if (controller == _contentViewController)
    {
        _contentViewController = nil;
    }
}


@end
