//
//  MGJAwesomeCommand+ExecQueue.m
//  Pods
//
//  Created by Derek Chen on 8/30/16.
//
//

#import "MGJAwesomeCommand+ExecQueue.h"

@implementation MGJAwesomeCommand (ExecQueue)

- (void)setExecQueue:(dispatch_queue_t)queue {
    [self setValue:queue forKey:@"excuteQueue"];
    [self setValue:queue forKey:@"userDefineExecQueue"];
}

@end
