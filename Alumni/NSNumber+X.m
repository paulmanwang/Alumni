//
//  NSNumber+X.m
//  iWeibo
//
//  Created by czh0766 on 12-4-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NSNumber+X.h"

static NSString* HEX_TABLE[] = {@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",
    @"A",@"B",@"C",@"D",@"E",@"F"};

@implementation NSNumber (NSNumberx)

+(NSNumber *)numberWithHex:(NSString*)hexValue {
    hexValue = [hexValue lowercaseString];
    if ([hexValue hasPrefix:@"0x"]) {
        hexValue = [hexValue substringFromIndex:2];
    }
    int ret = 0;
    const char* ch = [hexValue UTF8String];
    NSUInteger length = hexValue.length;
    for (int i = 0; i < length; i++)
    {
        ret <<= 4;
        UInt8 value = 0;
        if (ch[i] >= '0' && ch[i] <= '9')
        {
            value = (ch[i] - '0');
        }
        else if(ch[i] >= 'a' && ch[i] <= 'f')
        {
            value = (ch[i] - 'a' + 10);
        }
        else if(ch[i] >= 'A' && ch[i] <= 'F')
        {
            value = (ch[i] - 'A' + 10);
        }
        ret += value;
    }
    return @(ret);
}

-(NSString*) hexStringValue {
    NSMutableString* value = [NSMutableString stringWithCapacity:5];
    int src = [self intValue];

    while (src >= 16) {
    int b = src % 16;
    [value insertString:HEX_TABLE[b] atIndex:0];
        src /= 16;
    } 

    [value insertString:HEX_TABLE[src] atIndex:0];
    return value;
}

@end
