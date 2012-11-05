//
//  AssignGroupsViewController.h
//  magboard
//
//  Created by Jocelyn Clifford-Frith on 02/11/2012.
//  Copyright (c) 2012 Gripenskolan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CouchCocoa/CouchCocoa.h>

@interface AssignGroupsViewController : UITableViewController {
    CouchQuery *allItems;
    NSArray *searchResults;
}
@property CouchDatabase *database;
@property (strong, nonatomic) IBOutlet UISearchDisplayController *searchDisplayController;
@property (strong, nonatomic) IBOutlet UITableView *searchBar;

@end
