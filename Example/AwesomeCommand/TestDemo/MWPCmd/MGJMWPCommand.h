//
//  MGJMWPCommand.h
//  AwesomeCommand
//
//  Created by Derek Chen on 8/19/16.
//  Copyright © 2016 wentong. All rights reserved.
//

#import <AwesomeCommand/MGJAwesomeCommandPublicHeader.h>

@class MGJMWPRequestInfo;
@class MGJMWPResult;

typedef void (^MGJMWPExcuteCallbaclBlock)(id<MGJAwesomeExecutable> cmd, id returnObj, NSString *status, NSString *msg, NSError *error, BOOL isCompleted);

@interface MGJMWPCommand : MGJAwesomeCommand

@property (nonatomic, strong, readonly) MGJMWPRequestInfo *reqInfo;
@property (nonatomic, strong, readonly) MGJMWPResult *result;  // observable

- (instancetype)initWithMWPRequestInfo:(MGJMWPRequestInfo *)reqInfo;
- (instancetype)initWithMWPAPI:(NSString *)api version:(NSString *)ver andReturnClass:(__unsafe_unretained Class)returnClass;

- (void)setParams:(NSDictionary *)params;

- (id<MGJAwesomeCancelable>)executeWithParams:(NSDictionary *)params;
- (id<MGJAwesomeCancelable>)executeWithParams:(NSDictionary *)params andBlock:(MGJMWPExcuteCallbaclBlock)callbackBlock;

@end
