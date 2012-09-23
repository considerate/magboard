//
//  Group.h
//  magboard
//
//  Created by Jocelyn Clifford-Frith on 23/09/2012.
//  Copyright (c) 2012 Gripenskolan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GroupType;

@interface Group : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *tasks;
@property (nonatomic, retain) GroupType *type;
@end

@interface Group (CoreDataGeneratedAccessors)

- (void)addTasksObject:(NSManagedObject *)value;
- (void)removeTasksObject:(NSManagedObject *)value;
- (void)addTasks:(NSSet *)values;
- (void)removeTasks:(NSSet *)values;

@end
