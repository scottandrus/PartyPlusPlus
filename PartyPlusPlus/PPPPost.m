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

- (id)initWithImageUrl:(NSString *)image andDateString:(NSString *)date andPoster:(NSString *)poster {
    self.imageURL = image;
    self.dateString = date;
    self.text = nil;
    self.date = nil;
    self.posterName = poster;
    
    return self;
}
- (id)initWithMessage:(NSString *)text andDateString:(NSString *)date andPoster:(NSString *)poster {
    self.imageURL = nil;
    self.dateString = date;
    self.text = text;
    self.date = nil;
    self.posterName = poster;
    
    return self;
}



@end
