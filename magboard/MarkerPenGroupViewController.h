//
//  MarkerPenGroupViewController.h
//  magboard
//
//  Created by Jocelyn Clifford-Frith on 25/09/2012.
//  Copyright (c) 2012 Gripenskolan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Group.h"

@interface MarkerPenGroupViewController : UIViewController {
    IBOutlet UILabel *nameLabel;
}

@property (nonatomic, retain) Group *group;

@end
