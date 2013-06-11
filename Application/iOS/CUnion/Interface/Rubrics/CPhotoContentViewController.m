//
//  CPhotoContentViewController.m
//  CUnion
//
//  Created by Andrey Kuritsin on 27.11.12.
//  Copyright (c) 2012 Andrey Kuritsin. All rights reserved.
//

#import "CPhotoContentViewController.h"
#import "UIViewController+ActivityIndicator.h"

@interface CPhotoContentViewController ()

@end

@implementation CPhotoContentViewController

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
    [_photoGalleryViewController hideActivityIndicator];
    [_model cancel];
    _model.delegate = nil;
    _model = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    _imageItems = nil;
    
    _photoGalleryViewController = [[FGalleryViewController alloc] initWithPhotoSource:self];
    _photoGalleryViewController.gallerySize = _photoContentView.bounds.size;
    
    _navController = [[UINavigationController alloc] initWithRootViewController:_photoGalleryViewController];
    _navController.navigationBar.tintColor = [UIColor blackColor];
    [_navController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_bar_bg.png"] forBarMetrics:UIBarMetricsDefault];
    
    [self addChildViewController:_navController];
    _navController.view.frame = _photoContentView.bounds;
    [_photoContentView addSubview:_navController.view];
    
    NSInteger rubric_id = [[self.item objectForKey:@"@id"] intValue];
    
    _model = [[CURubricItemsModel alloc] init];
    _model.delegate = self;
    [_model setRubricID:rubric_id];
    [_model setThemeCount:1000];
    [_model setThemeOffset:0];
    [_model refresh:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)layoutInterface
{
    CGSize size = self.view.bounds.size;
    
    CGFloat h = (size.height - 44.0f) * 0.5f;
    self.webView.frame = CGRectMake(0.0f, 44.0f, size.width, h);
    _photoContentView.frame = CGRectMake(0.0f, 44.0f + h, size.width, h);
    _navController.view.bounds = _photoContentView.bounds;
    
    _photoGalleryViewController.gallerySize = _photoContentView.bounds.size;
}

#pragma mark - Private



#pragma mark - FGalleryViewControllerDelegate

- (int)numberOfPhotosForPhotoGallery:(FGalleryViewController*)gallery
{
    return _imageItems.count;
}

- (FGalleryPhotoSourceType)photoGallery:(FGalleryViewController*)gallery sourceTypeForPhotoAtIndex:(NSUInteger)index
{
    return FGalleryPhotoSourceTypeNetwork;
}

- (NSString*)photoGallery:(FGalleryViewController*)gallery urlForPhotoSize:(FGalleryPhotoSize)size atIndex:(NSUInteger)index
{
    NSDictionary *item = [_imageItems objectAtIndex:index];
    NSDictionary *images = [item objectForKey:@"images"];
    
    NSDictionary *image = nil;
    if (size == FGalleryPhotoSizeFullsize)
    {
        image = [[images objectForKey:@"image"] objectForKey:@"img"];
    }
    else
    {
        image = [[images objectForKey:@"icon"] objectForKey:@"img"];
    }
    
    FTLog(@"%@",image);
    
    NSString *key = @"@src";
    NSString *src = [image objectForKey:key];
    
    if (src)
    {
        return [_host stringByAppendingPathComponent:src];
    }
    
    return nil;
}




#pragma mark - CUModelDelegate<NSObject>

- (void)model:(CUModel*)model serverError:(NSError*)error_
{
    
}

- (void)modelDidUpdatedFromServer:(CUModel*)model_
{
    
    NSArray *items = [model_ items];
    if (items.count > 0)
    {
        NSDictionary *news = [[items objectAtIndex:0] objectForKey:@"news"];
        items = [news objectForKey:@"item"];
    }
    
    if (items.count > 0)
    {
        _imageItems = items;
    }
    else
    {
        _imageItems = nil;
    }
    
    [_photoGalleryViewController reloadGallery];
    
    [_photoGalleryViewController hideActivityIndicator];
}

- (void)modelDidUpdatedFromCache:(CUModel*)model_
{
    
}

- (void)modelStartLoadFromServer:(CUModel*)model_
{
    [_photoGalleryViewController showActivityIndicator];
}

@end
