//
//  RootViewController.m
//  magboard
//
//  Created by Jocelyn Clifford-Frith on 23/09/2012.
//  Copyright (c) 2012 Gripenskolan. All rights reserved.
//

#import "RootViewController.h"
#import "MarkerPenGroupView.h"
#import "MagnetView.h"
#import "MarkerPenGroupViewController.h"
#import "NewGroupTypeViewController.h"
#import <CouchCocoa/CouchDesignDocument_Embedded.h>

@interface RootViewController ()

@end

@implementation RootViewController

@synthesize database = __database;
@synthesize sortByGroupTypeID = __sortByGroupTypeID;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)useDatabase:(CouchDatabase *)database
{
    _database = database;
    
    // Create a 'view' containing list groupTypes sorted alphabetically:
    CouchDesignDocument* groupTypeDesign = [_database designDocumentWithName: @"groupType"];
    [groupTypeDesign defineViewNamed: @"byName" mapBlock: MAPBLOCK({
        if ([[doc objectForKey:@"type"] isEqualToString:@"groupType"]) {
            id name = [doc objectForKey: @"name"];
            if (name) emit(name, doc);
        }
    }) version: @"1.0"];
    
    // and a validation function requiring parseable names:
    groupTypeDesign.validationBlock = VALIDATIONBLOCK({
        if (newRevision.deleted)
            return YES;
        id name = [newRevision.properties objectForKey: @"name"];
        if (name && ! [RESTBody stringWithJSONObject:name]) {
            context.errorMessage = [@"invalid name " stringByAppendingString: name];
            return NO;
        }
        return YES;
    });
    
    // Create a 'view' containing list groups sorted by typeID:
    CouchDesignDocument* groupDesign = [_database designDocumentWithName: @"group"];
    [groupDesign defineViewNamed: @"byTypeID" mapBlock: MAPBLOCK({
        if ([[doc objectForKey:@"type"] isEqualToString:@"group"]) {
            id typeID = [doc objectForKey: @"typeID"];
            if (typeID) emit(typeID, doc);
        }
    }) version: @"1.0"];
    
    // and a validation function requiring parseable typeID:
    groupDesign.validationBlock = VALIDATIONBLOCK({
        if (newRevision.deleted)
            return YES;
        id typeID = [newRevision.properties objectForKey: @"typeID"];
        if (typeID && ! [RESTBody stringWithJSONObject:typeID]) {
            context.errorMessage = [@"invalid typeID " stringByAppendingString: typeID];
            return NO;
        }
        return YES;
    });
    
    // Create a 'view' containing list groups sorted by typeID:
    CouchDesignDocument* taskDesign = [_database designDocumentWithName: @"task"];
    [taskDesign defineViewNamed: @"byDate" mapBlock: MAPBLOCK({
        if ([[doc objectForKey:@"type"] isEqualToString:@"group"]) {
            id creationDate = [doc objectForKey: @"creationDate"];
            if (creationDate) emit(creationDate, doc);
        }
    }) version: @"1.0"];
    
    // and a validation function requiring parseable creationDate:
    taskDesign.validationBlock = VALIDATIONBLOCK({
        if (newRevision.deleted)
            return YES;
        id creationDate = [newRevision.properties objectForKey: @"creationDate"];
        if (creationDate && ! [RESTBody dataWithJSONObject:creationDate]) {
            context.errorMessage = [@"invalid creationDate " stringByAppendingString: creationDate];
            return NO;
        }
        return YES;
    });
}

- (void)populateDatabase
{
    // Populate groupTypes
    NSArray *groupTypes = @[
    @{ @"type" : @"groupType", @"name" : @"people" },
    @{ @"type" : @"groupType", @"name" : @"projects" }
    ];
    for (NSDictionary *groupTypeDictionary in groupTypes) {
        // Create the new document's properties:
        NSDictionary *inDocument = groupTypeDictionary;
        
        // Save the document, asynchronously:
        CouchDocument* doc = [_database untitledDocument];
        RESTOperation* op = [doc putProperties:inDocument];
        [op onCompletion: ^{}];
        [op start];
    }
    
    // Populate groups
    NSArray *groups = @[
    // People
    @{ @"type" : @"group", @"name" : @"Harry" },
    @{ @"type" : @"group", @"name" : @"Bob" },
    // Projects
    @{ @"type" : @"group", @"name" : @"Japanese" },
    @{ @"type" : @"group", @"name" : @"Cleaning" }
    ];
    for (NSDictionary *groupDictionary in groups) {
        // Create the new document's properties:
        NSDictionary *inDocument = groupDictionary;
        
        // Save the document, asynchronously:
        CouchDocument* doc = [_database untitledDocument];
        RESTOperation* op = [doc putProperties:inDocument];
        [op onCompletion: ^{}];
        [op start];
    }
    
    // Populate tasks
    NSArray *tasks = @[
    // Japanese tasks
    @{ @"type" : @"task", @"name" : @"Shukudai", @"creationDate" : [RESTBody JSONObjectWithDate:[NSDate dateWithTimeIntervalSince1970:100000000]] },
    @{ @"type" : @"task", @"name" : @"Kanji Practice", @"creationDate" : [RESTBody JSONObjectWithDate:[NSDate dateWithTimeIntervalSince1970:200000000]] },
    @{ @"type" : @"task", @"name" : @"Flashcards", @"creationDate" : [RESTBody JSONObjectWithDate:[NSDate dateWithTimeIntervalSince1970:300000000]] },
    // Cleaning tasks
    @{ @"type" : @"task", @"name" : @"Vacuuming", @"creationDate" : [RESTBody JSONObjectWithDate:[NSDate dateWithTimeIntervalSince1970:400000000]] },
    @{ @"type" : @"task", @"name" : @"Washing up", @"creationDate" : [RESTBody JSONObjectWithDate:[NSDate dateWithTimeIntervalSince1970:500000000]] },
    @{ @"type" : @"task", @"name" : @"Dusting", @"creationDate" : [RESTBody JSONObjectWithDate:[NSDate dateWithTimeIntervalSince1970:600000000]] }
    ];
    for (NSDictionary *taskDictionary in tasks) {
        // Create the new document's properties:
        NSDictionary *inDocument = taskDictionary;
        
        // Save the document, asynchronously:
        CouchDocument* doc = [_database untitledDocument];
        RESTOperation* op = [doc putProperties:inDocument];
        [op onCompletion: ^{}];
        [op start];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // Load in groupTypes from persistent store.
    self.database = [[DumbyDatabase alloc] init];
    
    // If it exists set the first GroupType as sortByType
    NSArray *groupTypes = [self.database groupTypes];
    if ([groupTypes count]>0) {
        NSNumber *groupTypeID = [[groupTypes objectAtIndex:0] objectForKey:@"id"];
        self.sortByGroupTypeID = [groupTypeID unsignedIntegerValue];
    }
    
    // Display groups and add contollers
    NSArray *groupsToDisplay = [self.database groupsForGroupTypeID:self.sortByGroupTypeID];
    for (NSUInteger i=0; i<[groupsToDisplay count]; i++) {
        NSUInteger groupID = [[[groupsToDisplay objectAtIndex:i] objectForKey:@"id"] unsignedIntegerValue];
        [self makeControllerForGroupID:groupID atIndex:i];
    }
    
    // Setup queries if database is connected.
    NSAssert(_database!=nil, @"Not hooked up to database yet");
    
    // Create a GroupType query sorted by ascending name:
    _allGroupTypesQuery = [[_database designDocumentWithName: @"groupType"]
                         queryViewNamed: @"byName"];
    _allGroupTypesQuery.descending = NO;
    
    // Create a Group query sorted by ascending typeID:
    _allGroupsQuery = [[_database designDocumentWithName: @"group"]
                     queryViewNamed: @"byTypeID"];
    _allGroupsQuery.descending = NO;
    
    // Create a Task query sorted by descending creationDate:
    _allTasksQuery = [[_database designDocumentWithName: @"task"]
                     queryViewNamed: @"byDate"];
    _allTasksQuery.descending = YES;
    
    // Log all data
    CouchQuery *allDocuments = [_database getAllDocuments];
    NSLog(@"total documents: %i",[allDocuments.rows count]);
    NSLog(@"groupTypes:%i groups:%i tasks:%i",
          [_allGroupTypesQuery.rows count],
          [_allGroupsQuery.rows count],
          [_allTasksQuery.rows count]);
    for (CouchQueryRow *row in _allGroupTypesQuery.rows) {
        CouchDocument *doc = row.document;
        NSLog(@"groupType ID: %@ name: %@", doc.documentID, [doc propertyForKey:@"name"]);
    }
    for (CouchQueryRow *row in _allGroupsQuery.rows) {
        CouchDocument *doc = row.document;
        NSLog(@"group ID: %@ name: %@", doc.documentID, [doc propertyForKey:@"name"]);
    }
    for (CouchQueryRow *row in _allTasksQuery.rows) {
        CouchDocument *doc = row.document;
        NSLog(@"task ID: %@ name: %@", doc.documentID, [doc propertyForKey:@"name"]);
    }
}


#define GROUP_VIEW_DIAMETER 140.0f
#define GROUP_VIEW_SPACING 150.0f

- (void)makeControllerForGroupID: (NSUInteger)groupID atIndex: (NSUInteger)index
{
    MarkerPenGroupViewController *controller = [[MarkerPenGroupViewController alloc] initWithNibName:@"GroupView" bundle:nil];
    controller.database = self.database;
    controller.groupID = groupID;
    [self addChildViewController:controller];
    
    
    // Calculate column and row
    int arrayIndex = index;
    int x = arrayIndex%2;
    int y = arrayIndex/2;
    CGRect frame = CGRectMake(x*GROUP_VIEW_SPACING+10.0f, y*GROUP_VIEW_SPACING+80.0f, GROUP_VIEW_DIAMETER, GROUP_VIEW_DIAMETER);
    controller.view.frame = frame;
    
    [self.view addSubview:controller.view];
}


#define TASK_VIEW_DIAMETER 60.0f
#define TASK_VIEW_SPACING 70.0f

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    id controller = segue.destinationViewController;
    if ([controller class] == [NewGroupTypeViewController class]) {
        [(NewGroupTypeViewController *)controller useDatabase:_database];
    }
}


@end
