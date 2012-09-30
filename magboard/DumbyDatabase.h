//
//  DumbyDatabase.h
//  magboard
//
//  Created by Jocelyn Clifford-Frith on 30/09/2012.
//  Copyright (c) 2012 Gripenskolan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DumbyDatabase : NSObject {
    @private
    NSMutableDictionary *_table;
}

- (NSArray *)groupsForGroupTypeID: (NSUInteger)groupTypeID;
- (NSArray *)tasksForGroupID: (NSUInteger)groupID;

@end
