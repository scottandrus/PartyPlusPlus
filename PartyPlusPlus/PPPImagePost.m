//
//  PPPPhotoPost.m
//  PartyPlusPlus
//
//  Created by Graham Gaylor on 10/14/12.
//  Copyright (c) 2012 Tapatory. All rights reserved.
//

#import "PPPImagePost.h"

@implementation PPPImagePost
@synthesize imageURL = _imageURL;

- (id)initWithImageUrl:(NSString *)image andDateString:(NSString *)date andPoster:(NSString *)poster {
    self.imageURL = image;
    self.dateString = date;
    self.date = nil;
    self.posterName = poster;
    
    return self;
}

@end
