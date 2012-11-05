//
//  AssignGroupsViewController.m
//  magboard
//
//  Created by Jocelyn Clifford-Frith on 02/11/2012.
//  Copyright (c) 2012 Gripenskolan. All rights reserved.
//

#import "AssignGroupsViewController.h"
#import "GroupTableCell.h"

@interface AssignGroupsViewController ()

@end

@implementation AssignGroupsViewController
@synthesize searchDisplayController;
@synthesize searchBar;
@synthesize taskProperties = __taskProperties;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [self setSearchDisplayController:nil];
    [self setSearchBar:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    // retrieve all groups from database
    NSAssert(self.database, @"AssignGroupsViewController hasn't been passed the database");
    allItems = [[self.database designDocumentWithName:@"tasks"] queryViewNamed:@"groupByGroupTypeID"];
    [allItems start];
    
    // retrieve groups currently assigned to task if it exists
    if (self.taskProperties) {
        selectedGroupIDs = [[NSMutableArray alloc] initWithArray:[[self.taskProperties objectForKey:@"groupIDs"] componentsSeparatedByString:@","]];
    }
    
    [super viewWillAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    
    if ([tableView
         isEqual:self.searchDisplayController.searchResultsTableView]){
        rows = [searchResults count];
    }
    else{
        rows = [allItems.rows count];
    }
    
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"GroupTableCell";
    
    GroupTableCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:CellIdentifier];
    
    CouchDocument *doc = [(CouchQueryRow *)[allItems.rows rowAtIndex:indexPath.row] document];
    
    /* Configure the cell. */
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]){
        cell.name.text =
        [doc propertyForKey:@"name"];
    }
    else{
        cell.name.text =
        [doc propertyForKey:@"name"];
        
        // If task exists and the group is assigned to it display checkmark
        if (self.taskProperties) {
            // check ID exists in in selected groups
            NSString *groupID = [doc documentID];
            BOOL containsID = NO;
            for (NSString *ID in selectedGroupIDs) {
                if ([ID isEqualToString:groupID]) {
                    containsID = YES;
                    break;
                }
            }
            if (containsID) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
    }
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // If task being assigned to exists, toggle assignment of selected group
    if (self.taskProperties) {
        
        // fetch ID for selected group
        NSString *groupID = [[allItems.rows rowAtIndex:indexPath.row] documentID];
        
        // check ID exists in in selected groups
        BOOL containsID = NO;
        NSString *IDToRemove = nil;
        for (NSString *ID in selectedGroupIDs) {
            if ([ID isEqualToString:groupID]) {
                containsID = YES;
                IDToRemove = ID;
                break;
            }
        }
        // Toggle existence of ID
        if (containsID) {
            [selectedGroupIDs removeObject:IDToRemove];
        } else {
            [selectedGroupIDs addObject:groupID];
        }
        
        // Update task properties
        [self.taskProperties setValue:[selectedGroupIDs componentsJoinedByString:@","] forKey:@"groupIDs"];
        
        // Update table view
        [tableView beginUpdates];
        [tableView reloadRowsAtIndexPaths:@[ indexPath ] withRowAnimation:NO];
        [tableView endUpdates];
    }
}

@end
