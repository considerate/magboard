//
//  NewTaskViewController.h
//  magboard
//
//  Created by Jocelyn Clifford-Frith on 23/09/2012.
//  Copyright (c) 2012 Gripenskolan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewTaskViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate> {
    
    IBOutlet UITextField *textField;
    IBOutlet UIPickerView *pickerView;
    
    NSArray *groupsForSortingType;
}

- (IBAction)addTask:(id)sender;
- (IBAction)cancel:(id)sender;

@end
