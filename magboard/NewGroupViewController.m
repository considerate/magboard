//
//  NewGroupViewController.m
//  magboard
//
//  Created by Jocelyn Clifford-Frith on 23/09/2012.
//  Copyright (c) 2012 Gripenskolan. All rights reserved.
//

#import "NewGroupViewController.h"
#import "RootViewController.h"
//#import "Group.h"

@interface NewGroupViewController ()

@end

@implementation NewGroupViewController

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

- (IBAction)addGroup:(id)sender
{
    // Can't create group with no name;
    if ([[textField text] length]==0)
        return;
    
    /*RootViewController *rootViewController = (RootViewController *)self.presentingViewController;
    
    Group *newGroup = (Group *)[NSEntityDescription insertNewObjectForEntityForName:@"Group" inManagedObjectContext:rootViewController.managedObjectContext];
    newGroup.name = [textField text];
    newGroup.type = [rootViewController.groupTypes objectAtIndex:[pickerView selectedRowInComponent:0]];
    
    
    // Save to persistent store
    NSError *error = nil;
    if (![rootViewController.managedObjectContext save:&error]) {
        // Handle the error.
    }
    
    // Add to view
    [rootViewController makeViewForGroup:newGroup];*/
    
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
    //RootViewController *rootViewController = (RootViewController *)self.presentingViewController;
    return 0; //[rootViewController.groupTypes count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    //RootViewController *rootViewController = (RootViewController *)self.presentingViewController;
    /*GroupType *groupType = [rootViewController.groupTypes objectAtIndex:row];
    return groupType.name;*/
    return nil;
}

@end
