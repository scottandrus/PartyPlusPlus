//
//  PPPMessagePost.m
//  PartyPlusPlus
//
//  Created by Graham Gaylor on 10/14/12.
//  Copyright (c) 2012 Tapatory. All rights reserved.
//

#import "PPPMessagePost.h"

@implementation PPPMessagePost
@synthesize message = _message;

- (id)initWithMessage:(NSString *)message andDateString:(NSString *)date andPoster:(NSString *)poster {
    self.dateString = date;
    self.message = message;
    self.date = nil;
    self.posterName = poster;
    
    return self;
}

@end
