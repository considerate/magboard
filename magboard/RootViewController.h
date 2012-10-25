//
//  RootViewController.h
//  magboard
//
//  Created by Jocelyn Clifford-Frith on 23/09/2012.
//  Copyright (c) 2012 Gripenskolan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CouchCocoa/CouchCocoa.h>
#import <CouchCocoa/CouchTouchDBServer.h>

@interface RootViewController : UIViewController {
    @private
    CouchDatabase *_database;
    NSMutableArray *groupViewControllers;
}

@property (nonatomic, assign) NSUInteger sortByGroupTypeID;
@property (nonatomic, retain) NSString *displayingGroupsWithTypeID;

- (void)useDatabase: (CouchDatabase *)database;
- (void)updateDisplay;
- (void)makeControllerWithGroupID: (NSString *)groupID;

@end
