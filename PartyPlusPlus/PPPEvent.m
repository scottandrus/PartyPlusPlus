//
//  PPPEvent.m
//  PartyPlusPlus
//
//  Created by Scott Andrus on 10/13/12.
//  Copyright (c) 2012 Tapatory. All rights reserved.
//

#import "PPPEvent.h"

#define ID_KEY @"id"
#define PEOPLE_ATTENDING_KEY @"attending"
#define EVENT_NAME_KEY @"name"
#define DATE_STRING_KEY @"start_time"
#define LOCATION_STRING_KEY @"location"
#define PICTURE_KEY @"picture"
#define DATA_KEY @"data"
#define URL_KEY @"url"
#define DESCRIPTION_KEY @"description"
#define IMAGE_URL_KEY @"image_url"


@implementation PPPEvent


@synthesize eventId;
@synthesize peopleAttending;
@synthesize rsvpStatus;
@synthesize eventName;
@synthesize date;
@synthesize dateString;
@synthesize timeString;
@synthesize locationString;
@synthesize location;
@synthesize imageURL;
@synthesize image;


- (id)initWithDictionary:(NSDictionary *)dictionary {
	self = [super init];
	if (self) {
		self.eventId = [dictionary objectForKey:ID_KEY];
//		self.peopleAttending = [self convertDateToFormattedStringWithJSONString:[dictionary objectForKey:DATE_KEY]];
		self.eventName = [dictionary objectForKey:EVENT_NAME_KEY];
        
        NSDictionary *dateDict = [self parseDateFromString:[dictionary objectForKey:DATE_STRING_KEY]];
        
		self.date = [dateDict objectForKey:@"DATE"];
		self.dateString = [dateDict objectForKey:@"DATESTR"];
        self.timeString = [dateDict objectForKey:@"TIMESTR"];
//		self.location = [dictionary objectForKey:LOCATION_KEY];
		self.locationString = [dictionary objectForKey:LOCATION_STRING_KEY] ? [dictionary objectForKey:LOCATION_STRING_KEY] : [[NSNull alloc] init];
        self.imageURL = [[[dictionary objectForKey:PICTURE_KEY] objectForKey:DATA_KEY] objectForKey:URL_KEY];
	}
	return self;
}

// http://stackoverflow.com/questions/4329485/how-to-format-facebook-twitter-dates-from-the-json-feed-in-objective-c
- (NSDictionary *)parseDateFromString:(NSString *)string {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    //2010-12-01T21:35:43+0000
    [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];
    NSDate *aDate = [df dateFromString:string];
    NSString *aDateString;
    
    // If it's more than a week away
    if ([aDate timeIntervalSinceNow] > 7 * 24 * 60 * 60) {
        [df setDateFormat:@"MMMM dd"];
        aDateString = [df stringFromDate:aDate];
    }
    // If it's more than tomorrow away
    else if ([aDate timeIntervalSinceNow] > 2 * 24 * 60 * 60) {
        [df setDateFormat:@"eeee"];
        aDateString = [df stringFromDate:aDate];
    }
    // It's more than today away
    else if ([aDate timeIntervalSinceNow] > 24 * 60 * 60) {
        aDateString = [NSString stringWithFormat:@"Tomorrow"];
    }
    // It's tonight
    else {
        aDateString = [NSString stringWithFormat:@"Tonight"];
    }
    
    NSString *aTimeString;
    if ([aDate timeIntervalSinceNow] > 5) {
        [df setDateFormat:@"h:mm a"];
        aTimeString = [df stringFromDate:aDate];
    } else aTimeString = @"Now";
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:aDate, @"DATE", aDateString, @"DATESTR", aTimeString, @"TIMESTR", nil];
    
    return dict;
}

- (NSString *)description {
	return [[self eventDictionary] description];
}

- (NSDictionary *)eventDictionary {
	NSMutableDictionary *eventDict = [NSMutableDictionary dictionaryWithCapacity:4];
	[eventDict setObject:self.eventId forKey:ID_KEY];
    [eventDict setObject:self.eventName forKey:EVENT_NAME_KEY];
    [eventDict setObject:self.dateString forKey:DATE_STRING_KEY];
    [eventDict setObject:self.locationString forKey:LOCATION_STRING_KEY];
    [eventDict setObject:self.imageURL forKey:IMAGE_URL_KEY];
	
	return [eventDict copy];
}


@end
