//
//  MarkerPenGroupView.m
//  magboard
//
//  Created by Jocelyn Clifford-Frith on 23/09/2012.
//  Copyright (c) 2012 Gripenskolan. All rights reserved.
//

#import "MarkerPenGroupView.h"

@implementation MarkerPenGroupView

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
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextAddEllipseInRect(context, CGRectInset(self.bounds, 1.0f, 1.0f));
    CGContextStrokePath(context);
    
    [super drawRect:rect];
}

- (BOOL)isOpaque
{
    return NO;
}


@end
