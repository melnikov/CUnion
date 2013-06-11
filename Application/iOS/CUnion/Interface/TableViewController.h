//
//  TableViewController.h
//  LeCoran
//
//  Created by Andrey Kuritsin on 21.06.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface TableViewController : ViewController<UITableViewDelegate, UITableViewDataSource> 
{
    @protected
        UITableView *_tableView;
}

@property (nonatomic,strong) IBOutlet UITableView *tableView;

@end
