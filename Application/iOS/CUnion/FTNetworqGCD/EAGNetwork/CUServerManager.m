//
//  FUServerManager.m
//  
//
//  Created by Андрей Паршаков on 26.07.12.
//  Copyright (c) 2012 bmm. All rights reserved.
//

#import "CUServerManager.h"
#import "FTRequestManager.h"
#import "FTRequestQueue.h"
#import "FTCache.h"
#import "FTFileCache.h"
#import "FTServerLoader.h"
#import "CUThemeNewsFormatter.h"
#import "CUItemsNewsFormatter.h"
#import "CURubricListFormatter.h"
#import "CURubricItemsFormatter.h"
#import "CUHighFormatter.h"
#import "CUMainFormatter.h"
#import "CUComitetItemsFormatter.h"
#import "CUComitetContentFormatter.h"


#define DB_CACHE_NAME   @"com.postkomsg.db"

@implementation CUServerManager

static CUServerManager *instance;

+ (CUServerManager*)sharedManager
{
    if (!instance) {
        instance = [[CUServerManager alloc] init];
    }
    return instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        _dbCache     = [[FTFileCache alloc] initWithStoreName:DB_CACHE_NAME];
        _mainQueue   = [[FTRequestQueue alloc] init];
        _getManager  = [[FTSimpleGetRequest alloc] initWithQueue:_mainQueue cache:nil];
        _postManager = [[FTSimplePostRequest alloc] initWithQueue:_mainQueue cache:nil];
    }
    
    return self;
}

- (FTCache*)getDBCache
{
    return _dbCache;
}

- (FTServerLoader*)makeLoader:(CUServerLoaderType)type_
{
    // If need load files make file loader
    CUFormatter *formatter;
    FTServerLoader *loader;
    
    FTRequestManager *currentManager = nil;
    switch (type_) {
        case CUServerLoaderThemeNews:
        {
            formatter = [[CUThemeNewsFormatter alloc] init];
            currentManager = _getManager;
        }
            break;
            
        case CUServerLoaderItemsNews:
        {
            formatter = [[CUItemsNewsFormatter alloc] init];
            currentManager = _getManager;
        }
            break;
            
        case CUServerLoaderRubricList:
        {
            formatter = [[CURubricListFormatter alloc] init];
            currentManager = _getManager;
        }
            break;
            
        case CUServerLoaderRubricItems:
        {
            formatter = [[CURubricItemsFormatter alloc] init];
            currentManager = _getManager;
        }
            break;
            
        case CUServerLoaderHigh:
        {
            formatter = [[CUHighFormatter alloc] init];
            currentManager = _getManager;
        }
            break;
            
        case CUServerLoaderMain:
        {
            formatter = [[CUMainFormatter alloc] init];
            currentManager = _getManager;
        }
            break;
            
        case CUServerLoaderComitetItems:
        {
            formatter = [[CUComitetItemsFormatter alloc] init];
            currentManager = _getManager;
        }
            break;
            
        case CUServerLoaderComitetContent:
        {
            formatter = [[CUComitetContentFormatter alloc] init];
            currentManager = _getManager;
        }
            break;
            
        default:
            break;
    }
    loader = [[FTServerLoader alloc] initWithRequestManager:currentManager formatter:formatter];
    
    return loader;
}

@end
