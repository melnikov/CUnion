//
//  CUServerManager.h
//  
//
//  Created by Андрей Паршаков on 26.07.12.
//  Copyright (c) 2012 bmm. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FTRequestManager;
@class FTRequestQueue;
@class FTServerLoader;
@class FTCache;

typedef enum _CUServerLoaderType{
    CUServerLoaderThemeNews,
    CUServerLoaderItemsNews,
    CUServerLoaderRubricList,
    CUServerLoaderRubricItems,
    CUServerLoaderHigh,
    CUServerLoaderMain,
    CUServerLoaderComitetItems,
    CUServerLoaderComitetContent,
} CUServerLoaderType;

@interface CUServerManager : NSObject
{
@private
    FTRequestManager *_getManager;
    FTRequestManager *_postManager;
    FTRequestQueue   *_mainQueue;
    FTCache *_dbCache;
}

+ (CUServerManager*)sharedManager;
- (FTServerLoader*)makeLoader:(CUServerLoaderType)type_;
- (FTCache*)getDBCache;
@end
