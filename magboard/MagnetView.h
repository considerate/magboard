//
//  MagnetView.h
//  magboard
//
//  Created by Jocelyn Clifford-Frith on 23/09/2012.
//  Copyright (c) 2012 Gripenskolan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MagnetView : UIView {
    UILabel *_label;
    NSString *_taskName;
}

- (void)setLabel:(NSString *)label;

@end
