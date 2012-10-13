//
//  PPPMainEventView.m
//  PartyPlusPlus
//
//  Created by Scott Andrus on 10/12/12.
//  Copyright (c) 2012 Tapatory. All rights reserved.
//

#import "PPPMainEventView.h"
#import "SAViewManipulator.h"

@implementation PPPMainEventView

//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        // Initialization code
//        
//        
//    }
//    return self;
//}

- (id)init
{
    self = [super init];
    if (self) {
        [self style];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if ((self = [super initWithCoder:aDecoder])){
        [self style];
    }
    return self;
}

- (void)style {
    [self addSubview:[[[NSBundle mainBundle] loadNibNamed:@"PPPMainEventView" owner:self options:nil] objectAtIndex:0]];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    self.clipsToBounds = YES;
    [SAViewManipulator addBorderToView:self withWidth:2 color:[UIColor blackColor] andRadius:10];
}


@end
