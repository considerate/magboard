//
//  RootViewController.h
//  magboard
//
//  Created by Jocelyn Clifford-Frith on 23/09/2012.
//  Copyright (c) 2012 Gripenskolan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupType.h"
#import "Group.h"
#import "Task.h"

@interface RootViewController : UIViewController {
    NSMutableArray *groupViewPairs;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSMutableArray *groupTypes;
@property (nonatomic, assign) GroupType *sortByGroupType;

- (void)makeViewForGroup: (Group *)group;
- (void)makeViewForTask: (Task *)task withGroup: (Group *)group;

@end
