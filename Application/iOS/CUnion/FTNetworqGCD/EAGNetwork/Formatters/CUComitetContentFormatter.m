//
//  CUComitetContentFormatter.m
//
//
//  Created by Андрей Паршаков on 26.07.12.
//  Copyright (c) 2012 bmm. All rights reserved.
//

#import "CUComitetContentFormatter.h"
#import "NSObject+SBJson.h"

@implementation CUComitetContentFormatter

- (NSString*)getURL
{
    return [NSString stringWithFormat:@"%@/get_content", HOST_POST_KOMSG];
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

#pragma mark - NSXMLParser Parsing Callbacks
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *) qualifiedName attributes:(NSDictionary *)attributeDict
{
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    
}

@end
