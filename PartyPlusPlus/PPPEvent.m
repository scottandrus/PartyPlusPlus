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
#define DATE_STRING_KEY @"date"
#define LOCATION_STRING_KEY @"location"


@implementation PPPEvent


@synthesize eventId;
@synthesize peopleAttending;
@synthesize rsvpStatus;
@synthesize eventName;
@synthesize date;
@synthesize dateString;
@synthesize locationString;
@synthesize location;


- (id)initWithDictionary:(NSDictionary *)dictionary {
	self = [super init];
	if (self) {
		self.eventId = [dictionary objectForKey:ID_KEY];
//		self.peopleAttending = [self convertDateToFormattedStringWithJSONString:[dictionary objectForKey:DATE_KEY]];
		self.eventName = [dictionary objectForKey:EVENT_NAME_KEY];
//		self.date =
		self.dateString = [dictionary objectForKey:DATE_STRING_KEY];
//		self.location = [dictionary objectForKey:LOCATION_KEY];
		self.locationString = [dictionary objectForKey:LOCATION_STRING_KEY];
	}
	return self;
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
	
	return [eventDict copy];
}


@end
