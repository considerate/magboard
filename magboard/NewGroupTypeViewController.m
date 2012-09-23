//
//  NewGroupTypeViewController.m
//  magboard
//
//  Created by Jocelyn Clifford-Frith on 23/09/2012.
//  Copyright (c) 2012 Gripenskolan. All rights reserved.
//

#import "NewGroupTypeViewController.h"
#import "RootViewController.h"

@interface NewGroupTypeViewController ()

@end

@implementation NewGroupTypeViewController

@synthesize groupTypeForAdding = __groupTypeForAdding;

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
    
    //self.groupTypeForAdding = [[GroupType alloc] init];
    
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
    
    //self.groupTypeForAdding.name = [textField text];
}

@end
