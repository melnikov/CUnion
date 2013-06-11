//
//  CViewController.m
//  CUnion
//
//  Created by Andrey Kuritsin on 16.10.12.
//  Copyright (c) 2012 Andrey Kuritsin. All rights reserved.
//

#import "CViewController.h"
#import "TopSegmentBar.h"
#import "GMGridViewLayoutStrategies.h"
#import <QuartzCore/QuartzCore.h>
#import "CNewsViewController.h"
#import "CRubricsViewController.h"
#import "CContentViewController.h"
#import "CComitetViewController.h"
#import "CDocViewController.h"


#import "CUThemeNewsModel.h"
#import "CURubricListModel.h"
#import "CURubricItemsModel.h"
#import "CUHighModel.h"
#import "CUMainModel.h"
#import "UIViewController+ActivityIndicator.h"

@interface CViewController ()

@end

@implementation CViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    contentOffset = 0;
    self.title = @"Союзное государство";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_leftTitleView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightTitleView];
    
    _bottomView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"top_bar_bg.png"]];
    
    SegmentItem *item = nil;
    NSMutableArray *items = [[NSMutableArray alloc] init];
    
    item = [[SegmentItem alloc] init];
    item.title = @"Новости";
    [items addObject:item];
    
    item = [[SegmentItem alloc] init];
    item.title = @"Рубрики";
    [items addObject:item];
    
    item = [[SegmentItem alloc] init];
    item.title = @"Высший ГосСовет";
    [items addObject:item];
    
    item = [[SegmentItem alloc] init];
    item.title = @"Парламентское собрание";
    [items addObject:item];
    
    item = [[SegmentItem alloc] init];
    item.title = @"Совет Министров";
    [items addObject:item];
    
    item = [[SegmentItem alloc] init];
    item.title = @"Постоянный\nкомитет";
    [items addObject:item];

    item = [[SegmentItem alloc] init];
    item.title = @"Правовая и нормативная\nдокументация";
    [items addObject:item];

    _topSegmentBar = [[TopSegmentBar alloc] initWithItems:items];
    _topSegmentBar.currentIndex = 0;
    [_topSegmentBar addTarget:self action:@selector(_topSegmentAction:) forControlEvents:UIControlEventValueChanged];
    _topSegmentBar.backgroundColor = [UIColor colorWithRed:(168.0f/255.0f) green:(194.0f/255.0f) blue:(168.0f/255.0f) alpha:1.0f];
    _topSegmentBar.frame = _topInfoView.bounds;
    [_topInfoView addSubview:_topSegmentBar];
    
    _imageNames = [NSArray arrayWithObjects:@"news.png",@"economy.png",@"security2.png",@"business2.png",@"monit_smi.png",@"geo.png",@"business.png",@"monit_smi2.png",@"toll.png",@"toll_.png", nil];
    
    _gridView = [[GMGridView alloc] initWithFrame:_gridContentView.bounds];
    _gridView.dataSource = self;
    _gridView.actionDelegate = self;
    _gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _gridView.style = GMGridViewStylePush;
    _gridView.itemSpacing = 10;
    _gridView.minEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    _gridView.centerGrid = YES;
    _gridView.layoutStrategy = [GMGridViewLayoutStrategyFactory strategyFromType:GMGridViewLayoutHorizontal];
    
    [_gridContentView addSubview:_gridView];
    
    
    [self _openNewsController];
}

- (void) viewWillAppear:(BOOL)animated
{
    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation))
    {
        [self willAnimateRotationToInterfaceOrientation:self.interfaceOrientation duration:0.0f];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)chatAction:(id)sender
{
   
}

- (IBAction)refreshAction:(id)sender
{
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [UIView animateWithDuration:duration animations:^{
        
        [self _layoutToInterfaceOrientation:toInterfaceOrientation];
        
    } completion:^(BOOL finished) {
        
        if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation))
        {
            _gridView.layoutStrategy = [GMGridViewLayoutStrategyFactory strategyFromType:GMGridViewLayoutHorizontal];
        }
        else
        {
            _gridView.layoutStrategy = [GMGridViewLayoutStrategyFactory strategyFromType:GMGridViewLayoutVertical];
        }
        
        [_gridView reloadData];
        
        _currentCotnroller.view.frame = _contentView.bounds;
        
        if ([_currentCotnroller respondsToSelector:@selector(layoutInterface)])
        {
            [(id)_currentCotnroller layoutInterface];
        }
    }];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    
}

#pragma mark - GMGridViewDataSource

- (NSInteger)numberOfItemsInGMGridView:(GMGridView *)gridView
{
    return _imageNames.count;
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
    
    imageContentView.image = [UIImage imageNamed:[_imageNames objectAtIndex:index]];
    
    return cell;
}

#pragma mark - Protocol GMGridViewActionDelegate

- (void)GMGridView:(GMGridView *)gridView didTapOnItemAtIndex:(NSInteger)position
{
    switch (position)
    {
        case 0:
        {
            [self _openNewsController];
        }
            break;
        case 1:
        {
            [self _openRubricsController];
        }
            break;
        default:
            break;
    }
}

#pragma mark - Private

- (void)_topSegmentAction:(TopSegmentBar *)topSegBar
{
    switch (topSegBar.currentIndex)
    {
        case 0:
        {
            [self _openNewsController];
        }
            break;
        case 1:
        {
            [self _openRubricsController];
        }
            break;
        case 2:
        {
            contentOffset = 0;
            [self _openHighController];
        }
            break;
        case 3:
        {
            contentOffset = 1;
            [self _openHighController];
        }
            break;
        case 4:
        {
            contentOffset = 2;
            [self _openHighController];
        }
            break;
        
        case 5:
        {
            [self _openComitetController];
        }
            break;
            
        case 6:
        {
            [self _openDocController];
        }
            break;
        
        default:
            break;
    }
}

- (void)_openNewsController
{
    if (_currentCotnroller == _newsViewController && _newsViewController.view.superview == _contentView)
    {
        return;
    }
    
    [self _removeCurrentController];
    
    _newsViewController = [CNewsViewController viewController];
    _currentCotnroller = _newsViewController;
    _newsViewController.view.frame = _contentView.bounds;
    [_newsViewController layoutInterface];
    [_contentView addSubview:_newsViewController.view];
}

- (void)_openRubricsController
{
    if (_currentCotnroller == _rubricsViewController && _rubricsViewController.view.superview == _contentView)
    {
        return;
    }
    
    [self _removeCurrentController];
    
    _rubricsViewController = [CRubricsViewController viewController];
    _currentCotnroller = _rubricsViewController;
    _rubricsViewController.view.frame = _contentView.bounds;
    [_rubricsViewController layoutInterface];
    [_contentView addSubview:_rubricsViewController.view];
}

- (void) _openHighController
{
    if (_highModel)
    {
        _highModel.delegate = nil;
        [_highModel cancel];
        _highModel = nil;
    }
    
    _highModel =  [[CUHighModel alloc] init];
    
    [(CUHighModel *)_highModel setThemeOffset:0];
    [(CUHighModel *)_highModel setThemeCount:25];
    [(CUHighModel *)_highModel setParenID:0];
    _highModel.delegate = self;
    
    [(CUHighModel *)_highModel refresh:nil];

}

- (void) _openComitetController
{
    if (_currentCotnroller == _comitetViewController && _comitetViewController.view.superview == _contentView)
    {
        return;
    }
    
    [self _removeCurrentController];
    
    _comitetViewController = [CComitetViewController viewController];
    _currentCotnroller = _comitetViewController;
    _comitetViewController.view.frame = _contentView.bounds;
    [_comitetViewController layoutInterface];
    [_contentView addSubview:_comitetViewController.view];
    
}

-(void) _openDocController
{
    
    if (_currentCotnroller == _docViewController && _docViewController.view.superview == _contentView)
    {
        return;
    }
    
    [self _removeCurrentController];
    
    _docViewController = [CDocViewController viewController];
    _currentCotnroller = _docViewController;
    _docViewController.view.frame = _contentView.bounds;
    [_docViewController layoutInterface];
    [_contentView addSubview:_docViewController.view];
    
}
- (void)_removeCurrentController
{
    [_currentCotnroller removeFromParentViewController];
    [_currentCotnroller.view removeFromSuperview];
    _currentCotnroller = nil;
    _newsViewController = nil;
    _rubricsViewController = nil;
}

- (void)_layoutToInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    if (UIInterfaceOrientationIsPortrait(orientation))
    {
        _topInfoView.frame = CGRectMake(0.0f, 0.0f, 768.0f, 44.0f);
        _topSegmentBar.frame = _topInfoView.bounds;
        
        _contentView.frame = CGRectMake(0.0f, 44.0f, 768.0f, 882.0f);
    }
    else
    {
        _topInfoView.frame = CGRectMake(0.0f, 0.0f, 1024.0f, 44.0f);
        _topSegmentBar.frame = _topInfoView.bounds;
        
        _contentView.frame = CGRectMake(0.0f, 44.0f, 1024.0f, 626.0f);
    }
}


#pragma mark -
#pragma mark - CUModelDelegate<NSObject>
- (void)model:(CUModel*)model_ serverError:(NSError*)error_
{
    FTLog(@"CUModelDelegate serverError");
    
    [self hideActivityIndicator];
}

- (void)modelDidUpdatedFromServer:(CUModel*)model_
{
    if (model_ == _highModel)
    {
        if (!_contentViewController)
        {
            _contentViewController = [CContentViewController viewController];
            _contentViewController.item = [[[[[model_ items] lastObject] objectForKey:@"news"] objectForKey:@"item"] objectAtIndex:contentOffset];
            _contentViewController.modalPresentationStyle = UIModalPresentationPageSheet;
            [self presentViewController:_contentViewController animated:YES completion:^{
                
            }];

        }
        else
        {
            _contentViewController.item = [[[[[model_ items] lastObject] objectForKey:@"news"] objectForKey:@"item"] objectAtIndex:contentOffset];
            [_contentViewController refresh];
        }
        
        _contentViewController = [CContentViewController viewController];
        _contentViewController.item = [[[[[model_ items] lastObject] objectForKey:@"news"] objectForKey:@"item"] objectAtIndex:contentOffset];
        _contentViewController.modalPresentationStyle = UIModalPresentationPageSheet;
        [self presentViewController:_contentViewController animated:YES completion:^{
            
        }];
        
        [self hideActivityIndicator];
    }
}

- (void)modelDidUpdatedFromCache:(CUModel*)model_
{
    if (model_ == _highModel)
    {
        if (_contentViewController)
        {
            [_contentViewController dismissModalViewControllerAnimated:NO];
        }
        
        _contentViewController = [CContentViewController viewController];
        _contentViewController.delegate = self;
        _contentViewController.item = [[[[[model_ items] lastObject] objectForKey:@"news"] objectForKey:@"item"] objectAtIndex:contentOffset];;
        _contentViewController.modalPresentationStyle = UIModalPresentationPageSheet;
        [self presentViewController:_contentViewController animated:YES completion:^{
            
        }];
    }
}

- (void)modelStartLoadFromServer:(CUModel*)model_
{
    if (model_ == _highModel)
    {
        [self showActivityIndicator];
    }
}

@end
