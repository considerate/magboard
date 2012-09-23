//
//  NewGroupTypeViewController.h
//  magboard
//
//  Created by Jocelyn Clifford-Frith on 23/09/2012.
//  Copyright (c) 2012 Gripenskolan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupType.h"

@interface NewGroupTypeViewController : UIViewController {
    
    IBOutlet UITextField *textField;
}

- (IBAction)addGroupType:(id)sender;
- (IBAction)cancel:(id)sender;

@end
