//
//  NSString+md5.m
//  FTUtils
//
//  Created by andrey on 07.02.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSString+md5.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString(md5)


- (NSString*)md5HexDigest
{
	const char* str = [self UTF8String];
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	CC_MD5(str, strlen(str), result);
	
	NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
	for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) 
	{
		[ret appendFormat:@"%02x",result[i]];
	}
	return ret;
}

- (NSString*)sha256HexDigest
{
	const char* str = [self UTF8String];
	unsigned char result[CC_SHA256_DIGEST_LENGTH];
	CC_SHA256(str, strlen(str), result);
	
	NSMutableString *ret = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH*2];
	for(int i = 0; i<CC_SHA256_DIGEST_LENGTH; i++) 
	{
		[ret appendFormat:@"%02x",result[i]];
	}
	return ret;
}

- (NSString *)urlEncodeValue
{
	return CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)self, NULL, CFSTR("!*'():@&=+$,/?%#[]"), kCFStringEncodingUTF8));
}

- (NSString*)clearString
{
	NSMutableString *s = [NSMutableString stringWithString:self];
	unsigned int slen = [s length], loc;
	for (loc=0; loc < slen; loc++)
	{
		unichar c = [s characterAtIndex:loc];
		
		if (c == '\n' || c == '\r' || c < 0x20) {
			// Forward check for additional newlines
			unsigned int len = 1;
			[s replaceCharactersInRange:NSMakeRange(loc, len) withString:@""];
			slen -= 1; // s is now shorter so let's update slen
			loc -= 1;
		}
	}
	
	return s;
}


@end
