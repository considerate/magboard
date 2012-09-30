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
#import "KeyValuePair.h"
#import "MarkerPenGroupViewController.h"

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
    for (NSDictionary *group in groupsToDisplay) {
        [self makeControllerForGroupID:[[group objectForKey:@"id"] unsignedIntegerValue]];
    }
}


#define GROUP_VIEW_DIAMETER 140.0f
#define GROUP_VIEW_SPACING 150.0f

- (void)makeControllerForGroupID: (NSUInteger)groupID
{
    MarkerPenGroupViewController *controller = [[MarkerPenGroupViewController alloc] initWithNibName:@"GroupView" bundle:nil];
    controller.groupID = groupID;
    [self addChildViewController:controller];
    
    // Calculate column and row
    int arrayIndex = [groupViewPairs count];
    int x = arrayIndex%2;
    int y = arrayIndex/2;
    CGRect frame = CGRectMake(x*GROUP_VIEW_SPACING+10.0f, y*GROUP_VIEW_SPACING+80.0f, GROUP_VIEW_DIAMETER, GROUP_VIEW_DIAMETER);
    controller.view.frame = frame;
    
    [self.view addSubview:controller.view];
}


#define TASK_VIEW_DIAMETER 60.0f
#define TASK_VIEW_SPACING 70.0f

/*- (void)makeViewForTask:(Task *)task withGroup: (Group *)group
{
    // Search groupViewPairs for view
    MarkerPenGroupView *groupView = nil;
    NSLog(@"Pairs for %i group views",[groupViewPairs count]);
    for (KeyValuePair *kvp in groupViewPairs) {
        if ([kvp.key isEqual:group]) {
            NSLog(@"parent view found");
            groupView = kvp.value;
            break;
        }
    }
    
    // Calculate column and row
    int arrayIndex = 0;
    int x = arrayIndex%2;
    int y = arrayIndex/2;
    CGRect frame = CGRectMake(x*TASK_VIEW_SPACING+10.0f, y*TASK_VIEW_SPACING+10.0f, TASK_VIEW_DIAMETER, TASK_VIEW_DIAMETER);
    MagnetView *taskView = [[MagnetView alloc] initWithFrame:frame];
    
    // Add text label for task name
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, TASK_VIEW_DIAMETER/2.0f, TASK_VIEW_DIAMETER, 20.0f)];
    label.text = task.name;
    [taskView addSubview:label];
    
    [groupView addSubview:taskView];
}*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
