//
//  BaseViewController.h
//  
//
//  Created by Andrey Kuritsin on 29.11.11.
//  Copyright (c) 2011 Andrey Kuritsin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController(ActivityIndicator)

- (void)showActivityIndicator;
- (void)hideActivityIndicator;
- (BOOL)isActivity;

@end