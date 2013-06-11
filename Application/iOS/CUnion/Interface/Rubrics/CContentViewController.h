//
//  CContentViewController.h
//  CUnion
//
//  Created by Andrey Kuritsin on 26.11.12.
//  Copyright (c) 2012 Andrey Kuritsin. All rights reserved.
//

#import "ViewController.h"

@class CContentViewController;

@protocol CContentViewControllerDelegate <NSObject>
@optional

- (void)contentViewControllerDidHide:(CContentViewController *)controller;

@end

@interface CContentViewController : ViewController<UIWebViewDelegate>
{
    @protected
        NSString *_host;
}

@property (strong, nonatomic) IBOutlet UIView *titleView;
@property (strong, nonatomic) IBOutlet UILabel *titleTextLabel;

@property (strong, nonatomic) IBOutlet UIButton *closeBtn;

@property (strong, nonatomic) IBOutlet UIWebView *webView;

@property (strong, nonatomic) NSDictionary *item;

@property (weak, nonatomic) id<CContentViewControllerDelegate> delegate;

- (IBAction)closeAction:(id)sender;

- (void)layoutInterface;

- (void)refresh;

@end
