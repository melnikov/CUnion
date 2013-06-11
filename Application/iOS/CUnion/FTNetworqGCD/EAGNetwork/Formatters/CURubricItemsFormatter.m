//
//  CURubricItemsFormatter.m
//  
//
//  Created by Андрей Паршаков on 26.07.12.
//  Copyright (c) 2012 bmm. All rights reserved.
//

#import "CURubricItemsFormatter.h"
#import "NSObject+SBJson.h"
#import "XMLReader.h"

@implementation CURubricItemsFormatter

- (NSString*)getURL
{
    return [NSString stringWithFormat:@"%@/rubric_items", HOST_POST_KOMSG];
}

- (id)parseServerData:(id)data_
{
    NSMutableData *xmlData = [data_ objectForKey:@"nsdata"];
    NSError *parseError = nil;
    NSDictionary *dict = [XMLReader dictionaryForXMLData:xmlData error:&parseError];
    if(parseError==nil)
    {
        return dict;
    }
    else
    {
        return nil;
    }
    
}

@end
