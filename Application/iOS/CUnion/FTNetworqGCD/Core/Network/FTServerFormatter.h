//
//  FTServerFormatter.h
//  ARCore
//
//  Created by Андрей Паршаков on 14.11.11.
//  Copyright (c) 2011 bmm. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 Класс используемы моделью для получния основных параметров форматирования загружаемых данных
 */

@interface FTServerFormatter : NSObject
{
    @protected
        NSMutableDictionary* _params;
}

- (NSString*)getURL;
- (NSString*)getCacheURL;
- (void)setParameter:(id)param_ forKey:(NSString*)key_;
- (NSDictionary*)getParameters;
- (id)parseServerData:(id)data_;

@end
