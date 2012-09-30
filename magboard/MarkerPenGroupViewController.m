//
//  MarkerPenGroupViewController.m
//  magboard
//
//  Created by Jocelyn Clifford-Frith on 25/09/2012.
//  Copyright (c) 2012 Gripenskolan. All rights reserved.
//

#import "MarkerPenGroupViewController.h"

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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    NSDictionary *group = [self.database groupForID:self.groupID];
    [nameLabel setText:[group objectForKey:@"name"]];
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
    
}

@end
