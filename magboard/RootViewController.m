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
