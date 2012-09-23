//
//  NewGroupTypeViewController.m
//  magboard
//
//  Created by Jocelyn Clifford-Frith on 23/09/2012.
//  Copyright (c) 2012 Gripenskolan. All rights reserved.
//

#import "NewGroupTypeViewController.h"
#import "RootViewController.h"
#import "GroupType.h"

@interface NewGroupTypeViewController ()

@end

@implementation NewGroupTypeViewController

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

- (IBAction)addGroupType:(id)sender
{
    // Can't create group with no name;
    if ([[textField text] length]==0)
        return;
    
    RootViewController *rootViewController = (RootViewController *)self.presentingViewController;
    
    GroupType *newGroupType = (GroupType *)[NSEntityDescription insertNewObjectForEntityForName:@"GroupType" inManagedObjectContext:rootViewController.managedObjectContext];
    newGroupType.name = [textField text];
    
    // Save to persistent store
    NSError *error = nil;
    if (![rootViewController.managedObjectContext save:&error]) {
        // Handle the error.
    }
    
    // Add to rootViewController
    [rootViewController.groupTypes addObject:newGroupType];
    
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)cancel:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

@end
