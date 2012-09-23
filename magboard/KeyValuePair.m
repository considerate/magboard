//
//  KeyValuePair.m
//  magboard
//
//  Created by Jocelyn Clifford-Frith on 23/09/2012.
//  Copyright (c) 2012 Gripenskolan. All rights reserved.
//

#import "KeyValuePair.h"

@implementation KeyValuePair

@synthesize key, value;

- (id)initWithKey:(id)aKey andValue:(id)aValue {
    if (self = [super init]) {
        self.key = aKey;
        self.value = aValue;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    KeyValuePair *copy = [[KeyValuePair allocWithZone:zone] init];
    
    [copy setKey:self.key];
    [copy setValue:self.value];
    
    return copy;
}

- (BOOL)isEqual:(id)anObject {
    if (self == anObject) {
        return YES;
    }
    
    if (![anObject isKindOfClass:[KeyValuePair class]]) {
        return NO;
    }
    
    return [key isEqual:((KeyValuePair *)anObject).key]
    && [value isEqual:((KeyValuePair *)anObject).value];
}

@end
