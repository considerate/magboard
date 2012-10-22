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
    CouchDesignDocument* designDoc = [_database designDocumentWithName: @"tasks"];
    [designDoc defineViewNamed: @"groupByName" mapBlock: MAPBLOCK({
        if ([[doc objectForKey:@"type"] isEqualToString:@"groupType"]) {
            id name = [doc objectForKey: @"name"];
            if (name) emit(name, doc);
        }
    }) version: @"1.0"];
    
    // and a validation function requiring parseable names:
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
    
    // Create a 'view' containing list groups sorted by typeID:
    [designDoc defineViewNamed: @"groupByTypeID" mapBlock: MAPBLOCK({
        if ([[doc objectForKey:@"type"] isEqualToString:@"group"]) {
            id typeID = [doc objectForKey: @"typeID"];
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
    
    
    [self populateDatabase];
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
                            for (NSDictionary *taskDictionary in tasks) {
                                // Create the new document's properties:
                                NSDictionary *inDocument = taskDictionary;
                                
                                // Save the document, asynchronously:
                                CouchDocument* doc = [_database untitledDocument];
                                RESTOperation* op = [doc putProperties:inDocument];
                                [op onCompletion: ^{
                                    NSLog(@"saved task: %@, with groupIDs: %@",[doc propertyForKey:@"name"],[doc propertyForKey:@"groupIDs"]);
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
