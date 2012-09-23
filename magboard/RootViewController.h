//
//  RootViewController.h
//  magboard
//
//  Created by Jocelyn Clifford-Frith on 23/09/2012.
//  Copyright (c) 2012 Gripenskolan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@end
