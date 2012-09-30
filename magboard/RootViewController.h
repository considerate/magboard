//
//  RootViewController.h
//  magboard
//
//  Created by Jocelyn Clifford-Frith on 23/09/2012.
//  Copyright (c) 2012 Gripenskolan. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "GroupType.h"
//#import "Group.h"
//#import "Task.h"
#import "DumbyDatabase.h"

@interface RootViewController : UIViewController {
    NSMutableArray *groupViewPairs;
    NSUInteger _sortbyGroupType;
}

//@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
//@property (nonatomic, retain) NSMutableArray *groupTypes;
//@property (nonatomic, assign) GroupType *sortByGroupType;

@property (nonatomic, retain) DumbyDatabase *database;
@property (nonatomic, assign) NSUInteger sortByGroupTypeID;

//- (void)makeViewForGroup: (Group *)group;
//- (void)makeViewForTask: (Task *)task withGroup: (Group *)group;

// To later override -makeViewForGroup:
//- (void)makeControllerForGroup: (Group *)group;
- (void)makeControllerForGroupID: (NSUInteger)groupID;

@end
