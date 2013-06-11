//
//  ViewController.h
//  LeCoran
//
//  Created by Andrey Kuritsin on 21.06.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ViewController : UIViewController 
{
    @protected
        UIImageView *_backgroundImageView;
}

@property (nonatomic, strong) IBOutlet UIImageView *backgroundImageView;

@property (nonatomic, readonly) UILabel *titleLabel;

+(id)viewController;

@end
