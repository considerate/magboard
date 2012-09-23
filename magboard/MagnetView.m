//
//  MagnetView.m
//  magboard
//
//  Created by Jocelyn Clifford-Frith on 23/09/2012.
//  Copyright (c) 2012 Gripenskolan. All rights reserved.
//

#import "MagnetView.h"

@implementation MagnetView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Simply draw a black cicle up to the view's bounds.
    CGContextSetLineWidth(context, 2.0f);
    CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
    CGContextAddEllipseInRect(context, self.bounds);
    CGContextFillPath(context);
}


@end
