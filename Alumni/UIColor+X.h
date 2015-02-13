//
//  UIColor+UIColorx.h
//  FrogFarm
//
//  Created by czh0766 on 11-12-14.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (X)

+(UIColor *)color255WithRed:(int)red green:(int)green blue:(int)blue;

+(UIColor*) color255WithRed:(int)red green:(int)green blue:(int)blue alpha:(int)alpha;

+(UIColor*) colorWithHexString: (NSString *)stringToConvert alpha:(int)alpha;

+(UIColor*) colorWithHexString: (NSString *)stringToConvert;

+(UIColor*) colorWithWord:(NSString*)word;

+(UIColor*) colorWithString: (NSString *)string;

-(NSString*) toHexString;

-(float) red;

-(float) green;

-(float) blue;

-(float) alpha;

@end
