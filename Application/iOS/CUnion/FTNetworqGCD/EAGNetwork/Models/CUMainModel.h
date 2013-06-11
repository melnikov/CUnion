//
//  CUMainModel.h
//  
//
//  Created by Андрей Паршаков on 26.07.12.
//  Copyright (c) 2012 bmm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CUModel.h"

@interface CUMainModel : CUModel
{
    NSInteger _parenID;
    NSInteger _themeOffset;
    NSInteger _themeCount;
}

@property(nonatomic,assign) NSInteger parenID;
@property(nonatomic,assign) NSInteger themeOffset;
@property(nonatomic,assign) NSInteger themeCount;
@end
