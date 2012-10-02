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
        CGRect labelFrame = CGRectMake(0,
                                       frame.size.height/2,
                                       frame.size.width,
                                       20);
        _label = [[UILabel alloc] initWithFrame:labelFrame];
        [self addSubview:_label];
    }
    return self;
}

- (void)setLabel:(NSString *)label
{
    [_label setText:label];
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

- (BOOL)isOpaque
{
    return NO;
}


@end
