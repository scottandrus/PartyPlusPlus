//
//  PPPPost.h
//  PartyPlusPlus
//
//  Created by Graham Gaylor on 10/14/12.
//  Copyright (c) 2012 Tapatory. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PPPPost : NSObject

@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSDate *date;

- (id)initWithImage:(UIImage *)image andDate:(NSDate *)date;
- (id)initWithText:(NSString *)text andDate:(NSDate *)date;


@end
