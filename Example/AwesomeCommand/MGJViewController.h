//
//  MGJViewController.h
//  AwesomeCommand
//
//  Created by wentong on 05/31/2016.
//  Copyright (c) 2016 wentong. All rights reserved.
//

@import UIKit;
#import <MGJ-Categories/NSObject+MGJKit.h>
#import "MGJMWPCommand.h"

@class MGJMWPCommand;
@class MGJMWPPetCmd;

@interface MGJViewController : UIViewController

@property (nonatomic, strong) MGJMWPCommand *mwpCmd0;
@property (nonatomic, strong) MGJMWPPetCmd *petCmd0;
@property (nonatomic, strong) MGJMWPPetCmd *petCmd1;
@property (nonatomic, copy) MGJMWPExcuteCallbaclBlock callback;
@property (nonatomic, strong) dispatch_queue_t queue;

@end
