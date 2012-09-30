//
//  RootViewController.h
//  magboard
//
//  Created by Jocelyn Clifford-Frith on 23/09/2012.
//  Copyright (c) 2012 Gripenskolan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DumbyDatabase.h"

@interface RootViewController : UIViewController

@property (nonatomic, retain) DumbyDatabase *database;
@property (nonatomic, assign) NSUInteger sortByGroupTypeID;

- (void)makeControllerForGroupID: (NSUInteger)groupID;

@end
