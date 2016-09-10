//
//  MGJMWPPet.m
//  AwesomeCommand
//
//  Created by Derek Chen on 8/26/16.
//  Copyright © 2016 wentong. All rights reserved.
//

#import "MGJMWPPet.h"

@implementation MGJMWPPet

- (NSString *)description {
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"self.name=%@", self.name];
    [description appendFormat:@", self.age=%ld", (long)self.age];
    [description appendFormat:@", self.weight=%ld", (long)self.weight];
    [description appendFormat:@", self.height=%ld", (long)self.height];
    [description appendFormat:@", self.desc=%@", self.desc];
    [description appendFormat:@", self.pt=%d", self.pt];
    [description appendString:@">"];
    return description;
}

@end
