//
//  RequestStringMaker.h
//  testMakeRequest
//
//  Created by Andrey Kuritsin on 22.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

/*
 Класс формирователь строки запроса
 */

#import <Foundation/Foundation.h>

@interface RequestStringMaker : NSObject
{
    @private
        NSMutableString *_reqString;
}

- (NSString *)makeStringWithParams:(NSDictionary *)params;

@end
