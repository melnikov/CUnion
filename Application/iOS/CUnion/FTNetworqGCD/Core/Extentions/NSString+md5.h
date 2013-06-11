//
//  NSString+md5.h
//  FTUtils
//
//  Created by andrey on 07.02.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 Категория, включающая в NSString методы:
 - расчет  md5
 - sha256
 - кодирования строки в esc коды
 */

@interface NSString(md5)

- (NSString*)md5HexDigest;
- (NSString*)sha256HexDigest;
- (NSString *)urlEncodeValue;
- (NSString*)clearString;

@end
