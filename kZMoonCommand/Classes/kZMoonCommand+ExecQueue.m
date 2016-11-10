//
//  kZMoonCommand+ExecQueue.m
//  Pods
//
//  Created by BupterAmbition   on 8/30/16.
//
//

#import "kZMoonCommand+ExecQueue.h"

@implementation kZMoonCommand (ExecQueue)

- (void)setExecQueue:(dispatch_queue_t)queue {
    [self setValue:queue forKey:@"excuteQueue"];
    [self setValue:queue forKey:@"userDefineExecQueue"];
}

@end
