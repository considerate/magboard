//
//  RootViewController.h
//  magboard
//
//  Created by Jocelyn Clifford-Frith on 23/09/2012.
//  Copyright (c) 2012 Gripenskolan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DumbyDatabase.h"
#import <CouchCocoa/CouchCocoa.h>
#import <CouchCocoa/CouchTouchDBServer.h>

@interface RootViewController : UIViewController {
    @private
    CouchDatabase *_database;
}

@property (nonatomic, retain) DumbyDatabase *database;
@property (nonatomic, assign) NSUInteger sortByGroupTypeID;

- (void)useDatabase: (CouchDatabase *)database;
- (void)makeControllerForGroupID: (NSUInteger)groupID atIndex: (NSUInteger)index;

@end
