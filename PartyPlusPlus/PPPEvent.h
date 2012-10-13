//
//  PPPEvent.h
//  PartyPlusPlus
//
//  Created by Scott Andrus on 10/13/12.
//  Copyright (c) 2012 Tapatory. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface PPPEvent : NSObject

@property (strong, nonatomic) NSNumber *eventId;
@property (strong, nonatomic) NSArray *peopleAttending;
@property (strong, nonatomic) NSString *rsvpStatus;
@property (strong, nonatomic) NSString *eventName;
@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) NSString *dateString;
@property (strong, nonatomic) NSString *locationString;
@property (strong, nonatomic) UIImage *image;

@property (assign, nonatomic) CLLocationCoordinate2D location;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)eventDictionary;

@end
