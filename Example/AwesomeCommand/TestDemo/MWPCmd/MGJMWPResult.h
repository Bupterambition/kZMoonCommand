//
//  MGJMWPResult.h
//  AwesomeCommand
//
//  Created by Derek Chen on 8/28/16.
//  Copyright © 2016 wentong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGJMWPResult : NSObject

@property (nonatomic, strong, readonly) NSString *status;
@property (nonatomic, strong, readonly) NSString *msg;
@property (nonatomic, strong, readonly) NSError *error;
@property (nonatomic, strong, readonly) id returnObj;
@property (nonatomic, assign, readonly) BOOL isCompleted;

- (MGJMWPResult *(^)(NSString *))setStatus;
- (MGJMWPResult *(^)(NSString *))setMessage;
- (MGJMWPResult *(^)(NSError *))setError;
- (MGJMWPResult *(^)(id))setReturnObj;
- (MGJMWPResult *(^)(BOOL))setIsCompleted;

@end
