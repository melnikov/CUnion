//
//  CUNewsItemsModel.h
//  
//
//  Created by Андрей Паршаков on 26.07.12.
//  Copyright (c) 2012 bmm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CUModel.h"

@interface CUNewsItemsModel : CUModel
{
    NSInteger _rubricID;
    NSInteger _themeOffset;
    NSInteger _themeCount;
}
@property(nonatomic,assign) NSInteger rubricID;
@property(nonatomic,assign) NSInteger themeOffset;
@property(nonatomic,assign) NSInteger themeCount;

@end
