//
//  PPPMessagePost.h
//  PartyPlusPlus
//
//  Created by Graham Gaylor on 10/14/12.
//  Copyright (c) 2012 Tapatory. All rights reserved.
//

#import "PPPPost.h"

@interface PPPMessagePost : PPPPost

@property (strong, nonatomic) NSString *message;

- (id)initWithMessage:(NSString *)text andDateString:(NSString *)date andPoster:(NSString *)poster;

@end
