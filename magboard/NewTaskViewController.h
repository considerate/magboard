//
//  NewTaskViewController.h
//  magboard
//
//  Created by Jocelyn Clifford-Frith on 23/09/2012.
//  Copyright (c) 2012 Gripenskolan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CouchCocoa/CouchCocoa.h>

@interface NewTaskViewController : UITableViewController <UITextFieldDelegate>

@property (strong, nonatomic) CouchDatabase *database;
@property (strong, nonatomic) NSMutableDictionary *taskProperties;

- (IBAction)save:(id)sender;
- (IBAction)cancel:(id)sender;

@end
