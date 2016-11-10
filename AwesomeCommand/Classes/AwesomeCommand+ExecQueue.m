//
//  AwesomeCommand+ExecQueue.m
//  Pods
//
//  Created by    on 8/30/16.
//
//

#import "AwesomeCommand+ExecQueue.h"

@implementation AwesomeCommand (ExecQueue)

- (void)setExecQueue:(dispatch_queue_t)queue {
    [self setValue:queue forKey:@"excuteQueue"];
    [self setValue:queue forKey:@"userDefineExecQueue"];
}

@end
