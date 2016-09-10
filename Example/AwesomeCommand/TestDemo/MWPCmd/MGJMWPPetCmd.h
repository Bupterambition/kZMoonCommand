//
//  MGJMWPPetCmd.h
//  AwesomeCommand
//
//  Created by Derek Chen on 8/28/16.
//  Copyright © 2016 wentong. All rights reserved.
//

#import "MGJMWPCommand.h"

@class MGJMWPPet;

@interface MGJMWPPetCmd : MGJMWPCommand

@property (nonatomic, strong, readonly) MGJMWPPet *pet;

@end
