//
//  MarkerPenGroupViewController.m
//  magboard
//
//  Created by Jocelyn Clifford-Frith on 25/09/2012.
//  Copyright (c) 2012 Gripenskolan. All rights reserved.
//

#import "MarkerPenGroupViewController.h"
#import "MagnetView.h"

@interface MarkerPenGroupViewController ()

@end

@implementation MarkerPenGroupViewController

@synthesize groupID = __groupID;
@synthesize database = __database;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#define TASK_VIEW_DIAMETER 60.0f
#define TASK_VIEW_SPACING 64.0f

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    CouchDocument *groupDoc = [self.database documentWithID:self.groupID];
    [nameLabel setText:[groupDoc propertyForKey:@"name"]];
    
    // Retrieve tasks for group
    CouchQuery *tasksQuery = [[self.database designDocumentWithName:@"tasks"] queryViewNamed:@"taskByGroupID"];
    tasksQuery.startKey = self.groupID;
    tasksQuery.endKey = self.groupID;
    [tasksQuery start];
    
    for (NSUInteger i=0; i<[tasksQuery.rows count]; i++) {
        CouchDocument *taskDoc = [[tasksQuery.rows rowAtIndex:i] document];
        
        int x = i%2;
        int y = i/2;
        CGRect frame = CGRectMake(x*TASK_VIEW_SPACING + 8.0f,
                                  y*TASK_VIEW_SPACING + 8.0f,
                                  TASK_VIEW_DIAMETER,
                                  TASK_VIEW_DIAMETER);
        
        MagnetView *taskView = [[MagnetView alloc] initWithFrame:frame];
        [taskView setLabel:[taskDoc propertyForKey:@"name"]];
        
        [self.view addSubview:taskView];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)makeViewForTask: (NSUInteger)taskID atIndex: (NSUInteger)index
{
    // Calculate column and row
    /*int arrayIndex = index;
    int x = arrayIndex%2;
    int y = arrayIndex/2;
    CGRect frame = CGRectMake(x*TASK_VIEW_SPACING + 8.0f,
                              y*TASK_VIEW_SPACING + 8.0f,
                              TASK_VIEW_DIAMETER,
                              TASK_VIEW_DIAMETER);
    
    NSDictionary *task = [self.database taskForID:taskID];
    MagnetView *taskView = [[MagnetView alloc] initWithFrame:frame];
    [taskView setLabel:[task objectForKey:@"name"]];
    
    [self.view addSubview:taskView];*/
}

@end
