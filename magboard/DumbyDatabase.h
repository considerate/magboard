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

- (NSArray *)groupTypes;
- (NSArray *)groupsForGroupTypeID: (NSUInteger)groupTypeID;
- (NSDictionary *)groupForID: (NSUInteger)groupID;
- (NSArray *)tasksForGroupID: (NSUInteger)groupID;

@end
