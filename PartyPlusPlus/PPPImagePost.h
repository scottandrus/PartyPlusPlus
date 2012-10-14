//
//  PPPPhotoPost.h
//  PartyPlusPlus
//
//  Created by Graham Gaylor on 10/14/12.
//  Copyright (c) 2012 Tapatory. All rights reserved.
//

#import "PPPPost.h"

@interface PPPImagePost : PPPPost

@property (strong, nonatomic) NSString *imageURL;

- (id)initWithImageUrl:(NSString *)image andDateString:(NSString *)date andPoster:(NSString *)poster;

@end
