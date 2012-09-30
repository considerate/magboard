//
//  DumbyDatabase.m
//  magboard
//
//  Created by Jocelyn Clifford-Frith on 30/09/2012.
//  Copyright (c) 2012 Gripenskolan. All rights reserved.
//

#import "DumbyDatabase.h"

@implementation DumbyDatabase

- (id)init
{
    if (self = [super init]) {
        
        // Setup dumby table data
        
        _table = [[NSMutableDictionary alloc] init];
        
        
        // Build group types
        NSArray *groupTypes = @[
        @{ @"id" : @1 , @"name" : @"people" },
        @{ @"id" : @2 , @"name" : @"projects" }
        ];
        [_table setObject:groupTypes forKey:@"GroupTypes"];
        
        // Build groups
        NSArray *groups = @[
        // People
        @{ @"id" : @1 , @"name" : @"Harry" , @"type" : @1 },
        @{ @"id" : @2 , @"name" : @"Bob" , @"type" : @1 },
        // Projects
        @{ @"id" : @3 , @"name" : @"Japanese" , @"type" : @2 },
        @{ @"id" : @4 , @"name" : @"Cleaning" , @"type" : @2 }
        ];
        [_table setObject:groups forKey:@"Groups"];
        
        // Build tasks
        NSArray *tasks = @[
        // Japanese tasks
        @{ @"id" : @1 , @"name" : @"Shukudai" , @"groups" : @[ @1, @3 ] },
        @{ @"id" : @2 , @"name" : @"Kanji Practice" , @"groups" : @[ @1, @3 ] },
        @{ @"id" : @3 , @"name" : @"Flashcards" , @"groups" : @[ @2, @3 ] },
        // Cleaning tasks
        @{ @"id" : @4 , @"name" : @"Vacuuming" , @"groups" : @[ @1, @4 ] },
        @{ @"id" : @5 , @"name" : @"Washing up" , @"groups" : @[ @1, @4 ] },
        @{ @"id" : @6 , @"name" : @"Dusting" , @"groups" : @[ @2, @4 ] }
        ];
        [_table setObject:tasks forKey:@"Tasks"];
        
    }
    return self;
}

- (NSArray *)groupTypes
{
    return [_table objectForKey:@"GroupTypes"];
}

- (NSArray *)groupsForGroupTypeID: (NSUInteger)groupID
{
    NSMutableArray *matchingTasks = [[NSMutableArray alloc] init];
    for (NSDictionary *task in [_table objectForKey:@"Tasks"]) {
        for (NSNumber *taskGroupID in [task objectForKey:@"groups"]) {
            if ([taskGroupID isEqualToNumber:[NSNumber numberWithInteger:groupID]]) {
                [matchingTasks addObject:task];
                break;
            }
        }
    }
    return matchingTasks;
}

- (NSArray *)tasksForGroupID: (NSUInteger)groupTypeID
{
    NSMutableArray *matchingGroups = [[NSMutableArray alloc] init];
    for (NSDictionary *group in [_table objectForKey:@"Groups"]) {
        for (NSNumber *groupGroupTypeID in [group objectForKey:@"type"]) {
            if ([groupGroupTypeID isEqualToNumber:[NSNumber numberWithInteger:groupTypeID]]) {
                [matchingGroups addObject:group];
                break;
            }
        }
    }
    return matchingGroups;
}

@end
