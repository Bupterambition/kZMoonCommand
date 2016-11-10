//
//  kZMoonCommand+ExecQueue.h
//  Pods
//
//  Created by BupterAmbition on 8/30/16.
//
//

#import "kZMoonCommand.h"

@interface kZMoonCommand (ExecQueue)

- (void)setExecQueue:(dispatch_queue_t)queue;

@end
