//
//  MGJMWPPetCmd.m
//  AwesomeCommand
//
//  Created by Derek Chen on 8/28/16.
//  Copyright © 2016 wentong. All rights reserved.
//

#import "MGJMWPPetCmd.h"
#import "MGJMWPPet.h"

@interface MGJMWPPetCmd ()

@property (nonatomic, strong) MGJMWPPet *pet;

@end

@implementation MGJMWPPetCmd

@synthesize pet = _pet;

- (void)dealloc {
    self.pet = nil;
}

- (instancetype)init {
    self = [super initWithMWPAPI:@"mwp.PetStore.helloWorld" version:@"2" andReturnClass:[MGJMWPPet class]];
    if (self) {
        ;
    }
    return self;
}

- (id<MGJAwesomeCancelable>)executeWithParams:(NSDictionary *)params {
    return [self executeWithParams:params andBlock:^(id<MGJAwesomeExecutable> cmd, MGJMWPPet *returnObj, NSString *status, NSString *msg, NSError *error, BOOL isCompleted) {
        if (returnObj) {
            self.pet = returnObj;
        }
    }];
}

@end
