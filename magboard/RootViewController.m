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

//@synthesize managedObjectContext = __managedObjectContext;
//@synthesize groupTypes = __groupTypes;
//@synthesize sortByGroupType = __sortByGroupType;
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
    /*NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"GroupType" inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO];
    [request setSortDescriptors:@[ sortDescriptor ]];
    
    NSError *error = nil;
    NSMutableArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResults == nil) {
        // Handle the error.
    }
    self.groupTypes = mutableFetchResults;*/
    
    self.database = [[DumbyDatabase alloc] init];
    
    // If it exists set the first GroupType as sortByType
    /*if ([self.groupTypes count]>0) {
        self.sortByGroupType = [self.groupTypes objectAtIndex:0];
    }*/
    NSArray *groupTypes = [self.database groupTypes];
    if ([groupTypes count]>0) {
        NSNumber *groupTypeID = [[groupTypes objectAtIndex:0] objectForKey:@"id"];
        self.sortByGroupTypeID = [groupTypeID unsignedIntegerValue];
    }
    
    /*groupViewPairs = [[NSMutableArray alloc] init];
    for (Group *group in self.sortByGroupType.groups) {
        //[self makeViewForGroup:group];
        [self makeControllerForGroup:group];
    }*/
    NSArray *groupsToDisplay = [self.database groupsForGroupTypeID:self.sortByGroupTypeID];
    for (NSDictionary *group in groupsToDisplay) {
        [self makeControllerForGroupID:[[group objectForKey:@"id"] unsignedIntegerValue]];
    }
}


#define GROUP_VIEW_DIAMETER 140.0f
#define GROUP_VIEW_SPACING 150.0f

/*- (void)makeViewForGroup:(Group *)group
{
    // Calculate column and row
    int arrayIndex = [groupViewPairs count];
    int x = arrayIndex%2;
    int y = arrayIndex/2;
    CGRect frame = CGRectMake(x*GROUP_VIEW_SPACING+10.0f, y*GROUP_VIEW_SPACING+80.0f, GROUP_VIEW_DIAMETER, GROUP_VIEW_DIAMETER);
    MarkerPenGroupView *groupView = [[MarkerPenGroupView alloc] initWithFrame:frame];
    
    // Add text label for group name
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, GROUP_VIEW_DIAMETER, 20.f)];
    label.text = group.name;
    [groupView addSubview:label];
    
    // Associate view with data
    KeyValuePair *pair = [[KeyValuePair alloc] initWithKey:group andValue:groupView];
    [groupViewPairs addObject:pair];
    
    // Add Task views
    for (Task *task in group.tasks) {
        [self makeViewForTask:task withGroup:group];
    }
    NSLog(@"tasks: %i",[group.tasks count]);
    
    [self.view addSubview:groupView];
}*/


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

/*- (void)makeControllerForGroup:(Group *)group
{
    MarkerPenGroupViewController *controller = [[MarkerPenGroupViewController alloc] initWithNibName:@"GroupView" bundle:nil];
    controller.group = group;
    [self addChildViewController:controller];
    [self.view addSubview:controller.view];
}*/

- (void)makeControllerForGroupID: (NSUInteger)groupID
{
    MarkerPenGroupViewController *controller = [[MarkerPenGroupViewController alloc] initWithNibName:@"GroupView" bundle:nil];
    controller.groupID = groupID;
    [self addChildViewController:controller];
    [self.view addSubview:controller.view];
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

- (void)updateTasksForGroup:(Group *)group
{
    
}

@end
