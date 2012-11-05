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
#import "NewTaskViewController.h"
#import <CouchCocoa/CouchDesignDocument_Embedded.h>

#define PREPOPULATE_DATABASE YES

@interface RootViewController ()

@end

@implementation RootViewController

@synthesize sortByGroupTypeID = __sortByGroupTypeID;
@synthesize displayingGroupsWithTypeID = __displayingGroupsWithTypeID;


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
    
    
    
    // Define design document for all data and the corresponding validation function requiring parseable names:
    CouchDesignDocument* designDoc = [_database designDocumentWithName: @"tasks"];
    designDoc.validationBlock = VALIDATIONBLOCK({
        if (newRevision.deleted)
            return YES;
        
        //Require creation date for all types
        id creationDate = [newRevision.properties objectForKey: @"creationDate"];
        if (creationDate && ! [RESTBody dateWithJSONObject:creationDate]) {
            context.errorMessage = [@"invalid creationDate " stringByAppendingString: creationDate];
            return NO;
        }
        return YES;
    });
    
    // Create a 'view' containing list groupTypes sorted alphabetically:
    [designDoc defineViewNamed: @"groupTypeByName" mapBlock: MAPBLOCK({
        if ([[doc objectForKey:@"type"] isEqualToString:@"groupType"]) {
            id name = [doc objectForKey: @"name"];
            if (name) emit(name, doc);
        }
    }) version: @"1.0"];
    
    // Create a 'view' containing list groups sorted by groupTypeID:
    [designDoc defineViewNamed: @"groupByGroupTypeID" mapBlock: MAPBLOCK({
        if ([[doc objectForKey:@"type"] isEqualToString:@"group"]) {
            id typeID = [doc objectForKey: @"groupTypeID"];
            if (typeID) emit(typeID, doc);
        }
    }) version: @"1.0"];
    
    
    
    // Create a 'view' containing a list of tasks sorted by creationDate:
    [designDoc defineViewNamed: @"taskByDate" mapBlock: MAPBLOCK({
        if ([[doc objectForKey:@"type"] isEqualToString:@"task"]) {
            id creationDate = [doc objectForKey: @"creationDate"];
            if (creationDate) emit(creationDate, doc);
        }
    }) version: @"1.0"];
    
    
    
    // Create a 'view' containing a list of tasks sorted by groups:
    [designDoc defineViewNamed: @"taskByGroupID" mapBlock: MAPBLOCK({
        if ([[doc objectForKey:@"type"] isEqualToString:@"task"]) {
            // Tasks are listed for as many groups are they are part of
            NSArray *groupIDs = [(NSString *)[doc objectForKey:@"groupIDs"] componentsSeparatedByString:@","];
            for (id groupID in groupIDs) {
                emit(groupID, doc);
            }
        }
    }) version: @"1.0"];
    
    
#ifdef PREPOPULATE_DATABASE
    [self populateDatabase];
#endif
}

- (void)populateDatabase
{
    // Clear existing documents
    for (CouchQueryRow *row in [[_database getAllDocuments] rows]) {
        [_database deleteDocuments:@[ row.document ]];
    }
    
    // Populate groupTypes
    NSArray *groupTypes = @[
    @{ @"type" : @"groupType", @"name" : @"people" },
    @{ @"type" : @"groupType", @"name" : @"projects" }
    ];
    NSMutableArray *groupTypeDocs = [[NSMutableArray alloc] init];
    __block int groupTypesSaved = 0;
    for (NSDictionary *groupTypeDictionary in groupTypes) {
        // Create the new document's properties:
        NSDictionary *inDocument = groupTypeDictionary;
        
        // Save the document, asynchronously:
        CouchDocument* doc = [_database untitledDocument];
        RESTOperation* op = [doc putProperties:inDocument];
        [op onCompletion: ^{
            NSLog(@"saved groupType: %@, with ID: %@",[doc propertyForKey:@"name"],[doc documentID]);
            [groupTypeDocs addObject:doc];
            
            // Creation of groups is dependent of groupTypes having IDs
            groupTypesSaved++;
            if (groupTypesSaved == [groupTypes count]) {
                
                // Populate groups
                NSArray *groups = @[
                // People
                @{ @"type" : @"group", @"name" : @"Harry", @"groupTypeID" : [[groupTypeDocs objectAtIndex:0] documentID] },
                @{ @"type" : @"group", @"name" : @"Bob", @"groupTypeID" : [[groupTypeDocs objectAtIndex:0] documentID] },
                // Projects
                @{ @"type" : @"group", @"name" : @"Japanese", @"groupTypeID" : [[groupTypeDocs objectAtIndex:1] documentID] },
                @{ @"type" : @"group", @"name" : @"Cleaning", @"groupTypeID" : [[groupTypeDocs objectAtIndex:1] documentID] }
                ];
                NSMutableArray *groupDocs = [[NSMutableArray alloc] init];
                __block int groupsSaved = 0;
                for (NSDictionary *groupDictionary in groups) {
                    // Create the new document's properties:
                    NSDictionary *inDocument = groupDictionary;
                    
                    // Save the document, asynchronously:
                    CouchDocument* doc = [_database untitledDocument];
                    RESTOperation* op = [doc putProperties:inDocument];
                    [op onCompletion: ^{
                        NSLog(@"saved group: %@, with ID: %@, and groupTypeID: %@",[doc propertyForKey:@"name"],[doc documentID],[doc propertyForKey:@"groupTypeID"]);
                        [groupDocs addObject:doc];
                        
                        // Creation of tasks is dependent of groups having IDs
                        groupsSaved++;
                        if (groupsSaved == [groups count]) {
                            
                            // Populate tasks
                            NSArray *tasks = @[
                            // Japanese tasks
                            @{ @"type" : @"task", @"name" : @"Shukudai", @"creationDate" : [RESTBody JSONObjectWithDate:[NSDate dateWithTimeIntervalSince1970:100000000]], @"groupIDs" : [[NSArray arrayWithObjects:[[groupDocs objectAtIndex:0] documentID], [[groupDocs objectAtIndex:2] documentID], nil] componentsJoinedByString:@","] },
                            @{ @"type" : @"task", @"name" : @"Kanji Practice", @"creationDate" : [RESTBody JSONObjectWithDate:[NSDate dateWithTimeIntervalSince1970:200000000]], @"groupIDs" : [[NSArray arrayWithObjects:[[groupDocs objectAtIndex:0] documentID], [[groupDocs objectAtIndex:2] documentID], nil] componentsJoinedByString:@","] },
                            @{ @"type" : @"task", @"name" : @"Flashcards", @"creationDate" : [RESTBody JSONObjectWithDate:[NSDate dateWithTimeIntervalSince1970:300000000]], @"groupIDs" : [[NSArray arrayWithObjects:[[groupDocs objectAtIndex:1] documentID], [[groupDocs objectAtIndex:2] documentID], nil] componentsJoinedByString:@","] },
                            // Cleaning tasks
                            @{ @"type" : @"task", @"name" : @"Vacuuming", @"creationDate" : [RESTBody JSONObjectWithDate:[NSDate dateWithTimeIntervalSince1970:400000000]], @"groupIDs" : [[NSArray arrayWithObjects:[[groupDocs objectAtIndex:0] documentID], [[groupDocs objectAtIndex:3] documentID], nil] componentsJoinedByString:@","] },
                            @{ @"type" : @"task", @"name" : @"Washing up", @"creationDate" : [RESTBody JSONObjectWithDate:[NSDate dateWithTimeIntervalSince1970:500000000]], @"groupIDs" : [[NSArray arrayWithObjects:[[groupDocs objectAtIndex:0] documentID], [[groupDocs objectAtIndex:3] documentID], nil] componentsJoinedByString:@","] },
                            @{ @"type" : @"task", @"name" : @"Dusting", @"creationDate" : [RESTBody JSONObjectWithDate:[NSDate dateWithTimeIntervalSince1970:600000000]], @"groupIDs" : [[NSArray arrayWithObjects:[[groupDocs objectAtIndex:1] documentID], [[groupDocs objectAtIndex:3] documentID], nil] componentsJoinedByString:@","] }
                            ];
                            __block int tasksSaved = 0;
                            for (NSDictionary *taskDictionary in tasks) {
                                // Create the new document's properties:
                                NSDictionary *inDocument = taskDictionary;
                                
                                // Save the document, asynchronously:
                                CouchDocument* doc = [_database untitledDocument];
                                RESTOperation* op = [doc putProperties:inDocument];
                                [op onCompletion: ^{
                                    NSLog(@"saved task: %@, with groupIDs: %@",[doc propertyForKey:@"name"],[doc propertyForKey:@"groupIDs"]);
                                    // Update display after final data entry.
                                    tasksSaved++;
                                    if (tasksSaved == [tasks count]) {
                                        // Display groups for first listed GroupType;
                                        self.displayingGroupsWithTypeID = [[groupTypeDocs objectAtIndex:0] documentID];
                                    }
                                }];
                                [op start];
                            }
                        }
                    }];
                    [op start];
                }
            }
        }];
        [op start];
    }
}

- (void)setDisplayingGroupsWithTypeID:(NSString *)displayingGroupsWithTypeID
{
    // Only update display if groupTypeID has changed
    if (__displayingGroupsWithTypeID != displayingGroupsWithTypeID) {
        __displayingGroupsWithTypeID = displayingGroupsWithTypeID;
        [self updateDisplay];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    groupViewControllers = [[NSMutableArray alloc] init];
    
    // Only set sortByGroupType and update display if using previous persistent data. Prepopulation happens asynchronously and might not be ready. Else these actions are triggered at the end of prepopulation. This can be later refactored into observers on a live query.
#ifndef PREPOPULATE_DATABASE
    
    // If it exists set the first GroupType as sortByType
    CouchQuery *query = [[_database designDocumentWithName:@"tasks"] queryViewNamed:@"groupTypeByName"];
    [query start];
    if ([query.rows count] > 0) {
        self.displayingGroupsWithTypeID = [[query.rows rowAtIndex:0] documentID];
    }
    
#endif
    
}


#define GROUP_VIEW_DIAMETER 140.0f
#define GROUP_VIEW_SPACING 150.0f

- (void)updateDisplay
{
    // Query for groups for specified groupType
    CouchQuery *query = [[_database designDocumentWithName:@"tasks"] queryViewNamed:@"groupByGroupTypeID"];
    query.startKey = self.displayingGroupsWithTypeID;
    query.endKey = self.displayingGroupsWithTypeID;
    [query start];
    
    
    // Build controllers (later only build if they don't already exist)
    for (CouchQueryRow *row in query.rows) {
        [self makeControllerWithGroupID:row.documentID];
    }
    
    // Arrange controllers on the screen and add the view hierarchy
    for (int i=0; i<[groupViewControllers count]; i++) {
        UIView *view = [[groupViewControllers objectAtIndex:i] view];
        int x = i%2;
        int y = i/2;
        CGRect frame = CGRectMake(x*GROUP_VIEW_SPACING+10.0f, y*GROUP_VIEW_SPACING+80.0f, GROUP_VIEW_DIAMETER, GROUP_VIEW_DIAMETER);
        view.frame = frame;
        [self.view addSubview:view];
    }
}

- (void)makeControllerWithGroupID:(NSString *)groupID
{
    MarkerPenGroupViewController *controller = [[MarkerPenGroupViewController alloc] initWithNibName:@"GroupView" bundle:nil];
    controller.database = _database;
    controller.groupID = groupID;
    [self addChildViewController:controller];
    [groupViewControllers addObject:controller];
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
    if ([controller class] == [UINavigationController class]) {
        id topViewController = [(UINavigationController *)controller topViewController];
        if ([topViewController class] == [NewTaskViewController class] ) {
            [(NewTaskViewController *)topViewController setDatabase:_database];
        }
    }
}


@end
