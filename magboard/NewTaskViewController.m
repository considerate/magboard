//
//  NewTaskViewController.m
//  magboard
//
//  Created by Jocelyn Clifford-Frith on 23/09/2012.
//  Copyright (c) 2012 Gripenskolan. All rights reserved.
//

#import "NewTaskViewController.h"
#import "RootViewController.h"
#import "Group.h"
#import "Task.h"

@interface NewTaskViewController ()

@end

@implementation NewTaskViewController

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
    
    RootViewController *rootViewController = (RootViewController *)self.presentingViewController;
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    groupsForSortingType = [rootViewController.sortByGroupType.groups sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
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

- (IBAction)addTask:(id)sender
{
    // Can't create group with no name;
    if ([[textField text] length]==0)
        return;
    
    RootViewController *rootViewController = (RootViewController *)self.presentingViewController;
    
    Task *newTask = (Task *)[NSEntityDescription insertNewObjectForEntityForName:@"Task" inManagedObjectContext:rootViewController.managedObjectContext];
    newTask.name = [textField text];
    Group *group = [groupsForSortingType objectAtIndex:[pickerView selectedRowInComponent:0]];
    [newTask addGroupsObject:group];
    
    
    // Save to persistent store
    NSError *error = nil;
    if (![rootViewController.managedObjectContext save:&error]) {
        // Handle the error.
    }
    
    [rootViewController makeViewForTask:newTask withGroup:group];
    
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)cancel:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark UIPickerView data and delegate methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [groupsForSortingType count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [(Group *)[groupsForSortingType objectAtIndex:row] name];
}

@end
