//
//  BaseViewController.m
//  
//
//  Created by Andrey Kuritsin on 29.11.11.
//  Copyright (c) 2011 Andrey Kuritsin. All rights reserved.
//

#import "UIViewController+ActivityIndicator.h"
#import <QuartzCore/QuartzCore.h>

#define BG_WIDTH  50.0f
#define BG_HEIGHT 50.0f

#define BG_CORNER_RADIUS 5.0f

static NSMutableDictionary *activityViewsDict = nil;

@implementation UIViewController(ActivityIndicator)

- (void)showActivityIndicator
{
    if (!activityViewsDict) 
    {
        activityViewsDict = [[NSMutableDictionary alloc] init];
    }
    
    NSString *key = [self description];
    
    if (![activityViewsDict objectForKey:key]) 
    {
        
        CGSize size = self.view.bounds.size;
        UIView *indicatorBG = [[UIView alloc] initWithFrame:CGRectMake((size.width - BG_WIDTH)/2.0f, (size.height - BG_HEIGHT)/2.2f, BG_WIDTH, BG_HEIGHT)];
        indicatorBG.autoresizingMask = UIViewAutoresizingNone;
        indicatorBG.backgroundColor = [UIColor blackColor];
        indicatorBG.alpha = 0.7;
        indicatorBG.layer.cornerRadius = BG_CORNER_RADIUS;
        
        UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        indicatorView.autoresizingMask = UIViewAutoresizingNone;
        
        size = indicatorView.bounds.size;
        indicatorView.frame = CGRectMake((BG_WIDTH - size.width)/2.0f, (BG_HEIGHT - size.height)/2.0f, size.width, size.height);
        [indicatorBG addSubview:indicatorView];
        
        [self.view addSubview:indicatorBG];
        [indicatorView startAnimating];
        
        [activityViewsDict setObject:indicatorBG forKey:key];
    }
}

- (void)hideActivityIndicator
{
    NSString *key = [self description];
    if ([activityViewsDict objectForKey:key]) 
    {
        UIView *indicatorBG = (UIView *)[activityViewsDict objectForKey:key];
        
        [indicatorBG removeFromSuperview];
        
        [activityViewsDict removeObjectForKey:key];
        
        if ([activityViewsDict count] == 0) 
        {
            activityViewsDict = nil;
        }
    }
}

- (BOOL)isActivity
{
    NSString *key = [self description];
    if ([activityViewsDict objectForKey:key]) 
    {
        return YES;
    }
    
    return NO;
}

@end
