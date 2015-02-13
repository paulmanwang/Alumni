//
//  UIColor+UIColorx.m
//  FrogFarm
//
//  Created by czh0766 on 11-12-14.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "UIColor+X.h"
#import "NSNumber+X.h"

@implementation UIColor (X)

+(UIColor *)color255WithRed:(int)red green:(int)green blue:(int)blue{
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:255.0/255.0];
}

+(UIColor *)color255WithRed:(int)red green:(int)green blue:(int)blue alpha:(int)alpha {
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha/255.0];
}

+ (UIColor *) colorWithHexString: (NSString *)stringToConvert alpha:(int)alpha
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor whiteColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"] || [cString hasPrefix:@"0x"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor whiteColor];
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha: (float)alpha/255.0];
}

+ (UIColor *) colorWithHexString: (NSString *) stringToConvert
{
    return [UIColor colorWithHexString:stringToConvert alpha:255];
}

+(UIColor*) colorWithWord:(NSString*)word {
    if ([word isEqualToString:@"red"]) {
        return [UIColor redColor];
    } else if ([word isEqualToString:@"green"]) {
        return [UIColor greenColor];
    } else if ([word isEqualToString:@"blue"]) {
        return [UIColor blueColor];
    } else if ([word isEqualToString:@"yellow"]) {
        return [UIColor yellowColor];
    } else if ([word isEqualToString:@"white"]) {
        return [UIColor whiteColor];
    } else if ([word isEqualToString:@"gray"]) {
        return [UIColor grayColor];
    } else if ([word isEqualToString:@"black"]) {
        return [UIColor blackColor];
    }
    return nil;
}

+(UIColor*) colorWithString: (NSString *)string {
    if ([string hasPrefix:@"0x"] || [string hasPrefix:@"0X"] || [string hasPrefix:@"#"]) {
        return [self colorWithHexString:string];
    } else {
        return [self colorWithWord:string];
    }
}

-(NSString *)toHexString {
    NSString* red = [[NSNumber numberWithInt:[self red] * 255] hexStringValue];
    if (red.length < 2) {
        red = [NSString stringWithFormat:@"0%@", red];
    }
    NSString* green = [[NSNumber numberWithInt:[self green] * 255] hexStringValue];
    if (green.length < 2) {
        green = [NSString stringWithFormat:@"0%@", green];
    }
    NSString* blue = [[NSNumber numberWithInt:[self blue] * 255] hexStringValue];
    if (blue.length < 2) {
        blue = [NSString stringWithFormat:@"0%@", blue];
    }
    
    return [NSString stringWithFormat:@"#%@%@%@", red, green, blue];
}

-(float) red {
    const CGFloat* components = CGColorGetComponents(self.CGColor);
    float red = components[0];
    //free(components);
    return red;
}

-(float) green {
    const CGFloat* components = CGColorGetComponents(self.CGColor);
    float green = components[1];
    //free(components);
    return green;
}

-(float) blue {
    const CGFloat* components = CGColorGetComponents(self.CGColor);
    float blue = components[2];
    //free(components);
    return blue;
}

-(float) alpha {
    const CGFloat* components = CGColorGetComponents(self.CGColor);
    float alpha = components[3];
    //free(components);
    return alpha;
}

@end
