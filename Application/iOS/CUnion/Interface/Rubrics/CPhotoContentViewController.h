//
//  CPhotoContentViewController.h
//  CUnion
//
//  Created by Andrey Kuritsin on 27.11.12.
//  Copyright (c) 2012 Andrey Kuritsin. All rights reserved.
//

#import "CContentViewController.h"
#import "FGalleryViewController.h"
#import "CURubricItemsModel.h"

@interface CPhotoContentViewController : CContentViewController<FGalleryViewControllerDelegate, CUModelDelegate>
{
    @protected
        UINavigationController *_navController;
        FGalleryViewController *_photoGalleryViewController;
    
        NSArray *_imageItems;
    
        CURubricItemsModel *_model;
}

@property (strong, nonatomic) IBOutlet UIView *photoContentView;

@end
