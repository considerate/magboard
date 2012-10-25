//
//  MarkerPenGroupViewController.h
//  magboard
//
//  Created by Jocelyn Clifford-Frith on 25/09/2012.
//  Copyright (c) 2012 Gripenskolan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CouchCocoa/CouchCocoa.h>

@interface MarkerPenGroupViewController : UIViewController {
    IBOutlet UILabel *nameLabel;
}

@property (nonatomic, retain) NSString *groupID;
@property (nonatomic, retain) CouchDatabase *database;

- (void)makeViewForTask: (NSUInteger)taskID atIndex: (NSUInteger)index;

@end
