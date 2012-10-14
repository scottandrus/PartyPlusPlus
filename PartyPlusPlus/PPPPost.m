//
//  PPPPost.m
//  PartyPlusPlus
//
//  Created by Graham Gaylor on 10/14/12.
//  Copyright (c) 2012 Tapatory. All rights reserved.
//

#import "PPPPost.h"

@implementation PPPPost
@synthesize imageURL = _imageUrl;
@synthesize text = _text;
@synthesize date = _date;

- (id)initWithImageUrl:(NSString *)image andDateString:(NSString *)date {
    self.imageURL = image;
    self.dateString = date;
    self.text = nil;
    self.date = nil;
    
    return self;
}
- (id)initWithText:(NSString *)text andDateString:(NSString *)date {
    self.imageURL = nil;
    self.dateString = date;
    self.text = text;
    self.date = nil;
    
    return self;
}



@end
