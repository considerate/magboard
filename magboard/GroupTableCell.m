//
//  GroupTableCell.m
//  magboard
//
//  Created by Jocelyn Clifford-Frith on 04/11/2012.
//  Copyright (c) 2012 Gripenskolan. All rights reserved.
//

#import "GroupTableCell.h"

@implementation GroupTableCell
@synthesize name;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
