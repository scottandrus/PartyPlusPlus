//
//  PPPPost.m
//  PartyPlusPlus
//
//  Created by Graham Gaylor on 10/14/12.
//  Copyright (c) 2012 Tapatory. All rights reserved.
//

#import "PPPPost.h"

@implementation PPPPost
@synthesize image = _image;
@synthesize text = _text;
@synthesize date = _date;

- (id)initWithImage:(UIImage *)image andDate:(NSDate *)date {
    self.image = image;
    self.date = date;
    self.text = @"";
    
    return self;
}
- (id)initWithText:(NSString *)text andDate:(NSDate *)date {
    
}



@end
