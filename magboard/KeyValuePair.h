//
//  KeyValuePair.h
//  magboard
//
//  Created by Jocelyn Clifford-Frith on 23/09/2012.
//  Copyright (c) 2012 Gripenskolan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyValuePair : NSObject {
    id  key;
    id  value;
}

@property (nonatomic, retain)   id  key;
@property (nonatomic, retain)   id  value;

- (id)initWithKey:(id)aKey andValue:(id)aValue;

@end
