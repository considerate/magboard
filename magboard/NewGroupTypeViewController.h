//
//  NewGroupTypeViewController.h
//  magboard
//
//  Created by Jocelyn Clifford-Frith on 23/09/2012.
//  Copyright (c) 2012 Gripenskolan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CouchCocoa/CouchCocoa.h>
#import <CouchCocoa/CouchTouchDBServer.h>

@interface NewGroupTypeViewController : UIViewController {
    
    IBOutlet UITextField *textField;
    CouchDatabase *_database;
}

- (IBAction)addGroupType:(id)sender;
- (IBAction)cancel:(id)sender;

- (void)useDatabase: (CouchDatabase *)database;

@end
