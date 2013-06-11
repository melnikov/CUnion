//
//  CComitetViewController.m
//  CUnion
//
//  Created by Yuriy Nezhura on 12/3/12.
//  Copyright (c) 2012 Andrey Kuritsin. All rights reserved.
//

#import "CComitetViewController.h"
#import "UIViewController+ActivityIndicator.h"
#import "CContentViewController.h"

@interface CComitetViewController ()

@end

@implementation CComitetViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _topTitleView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"title_bg.png"]];

    
    _comitetItemsList = [[NSMutableArray alloc] init];
    
    
    _comitetItemsModel = [[CUComitetItemsModel alloc] init];
    _comitetItemsModel.delegate = self;
    [(CUComitetItemsModel *)_comitetItemsModel setRubricID:222];
    [(CUComitetItemsModel *)_comitetItemsModel setThemeOffset:0];
    [(CUComitetItemsModel *)_comitetItemsModel setThemeCount:100];
    [(CUComitetItemsModel *)_comitetItemsModel refresh:nil];
    
    _comitetContentModel = [[CUComitetContentModel alloc] init];
    _comitetContentModel.delegate = self;
}

- (void)dealloc
{
    
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

- (void)_layoutToInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    if (UIInterfaceOrientationIsPortrait(orientation))
    {
        
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    
}


-(void) layoutInterface
{
    CGSize size = self.view.bounds.size;
    _topTitleView.frame = CGRectMake(0, 0, size.width, 34);
    
    if(UIInterfaceOrientationIsPortrait(self.interfaceOrientation))
    {
        
        _tableView.frame = CGRectMake(20.0f, 34, size.width - 40.0f, size.height - 34);
    }
    else
    {
        _tableView.frame = CGRectMake(20.0f, 34, size.width - 40.0f, size.height - 34);
    
    }
        
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dict = [_comitetItemsList objectAtIndex:indexPath.row];
    
    
    NSInteger _rubricID = [[dict objectForKey:@"@id"] intValue];
    
    [_comitetContentModel setRubricID:_rubricID];
    [_comitetContentModel refresh:nil];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _comitetItemsList.count;
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
    
    NSDictionary *item = [_comitetItemsList objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [item objectForKey:@"@title"];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    cell.textLabel.numberOfLines = 0;
    
    return cell;
}


#pragma mark - CUModelDelegate<NSObject>

- (void)model:(CUModel*)model_ serverError:(NSError*)error_
{
    [self hideActivityIndicator];
    
}

- (void)modelDidUpdatedFromServer:(CUModel*)model_
{
    if (model_ == _comitetItemsModel)
    {
        [_comitetItemsList removeAllObjects];
        
        NSArray *rubrics = [[[[model_ items] lastObject] objectForKey:@"news"] objectForKey:@"item"];
        
        if (rubrics.count)
        {
            [_comitetItemsList addObjectsFromArray:rubrics];
            [_tableView reloadData];
        }
        
        
    }
    if (model_ == _comitetContentModel)
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
    if (model_ == _comitetItemsModel)
    {
        [_comitetItemsList removeAllObjects];
        
        NSArray *rubrics = [[[[model_ items] lastObject] objectForKey:@"news"] objectForKey:@"item"];
        
        if (rubrics.count)
        {
            [_comitetItemsList addObjectsFromArray:rubrics];
            [_tableView reloadData];
        }
    }
    
    if (model_ == _comitetContentModel)
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

#pragma mark - CContentViewControllerDelegate <NSObject>

- (void)contentViewControllerDidHide:(CContentViewController *)controller
{
    if (controller == _contentViewController)
    {
        _contentViewController = nil;
    }
}



@end
