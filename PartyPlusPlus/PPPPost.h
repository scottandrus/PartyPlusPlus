//
//  PPPPost.h
//  PartyPlusPlus
//
//  Created by Graham Gaylor on 10/14/12.
//  Copyright (c) 2012 Tapatory. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PPPPost : NSObject

@property (strong, nonatomic) NSString *posterName;
@property (strong, nonatomic) NSString *imageURL;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSString *dateString;
@property (strong, nonatomic) NSDate *date;

- (id)initWithImageUrl:(NSString *)image andDateString:(NSString *)date andPoster:(NSString *)poster;
- (id)initWithMessage:(NSString *)text andDateString:(NSString *)date andPoster:(NSString *)poster;


@end
