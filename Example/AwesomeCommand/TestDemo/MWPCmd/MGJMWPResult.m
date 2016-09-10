//
//  MGJMWPResult.m
//  AwesomeCommand
//
//  Created by Derek Chen on 8/28/16.
//  Copyright © 2016 wentong. All rights reserved.
//

#import "MGJMWPResult.h"
#import <MGJMacros/MGJMacros.h>

@interface MGJMWPResult ()

@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *msg;
@property (nonatomic, strong) NSError *error;
@property (nonatomic, strong) id returnObj;
@property (nonatomic, assign) BOOL isCompleted;

@end

@implementation MGJMWPResult

- (MGJMWPResult *(^)(NSString *))setStatus {
    return ^MGJMWPResult *(NSString *value) {
        self.status = value;
        return self;
    };
}

- (MGJMWPResult *(^)(NSString *))setMessage {
    return ^MGJMWPResult *(NSString *value) {
        self.msg = value;
        return self;
    };
}

- (MGJMWPResult *(^)(NSError *))setError {
    return ^MGJMWPResult *(NSError *value) {
        self.error = value;
        return self;
    };
}

- (MGJMWPResult *(^)(id))setReturnObj {
    return ^MGJMWPResult *(id value) {
        self.returnObj = value;
        return self;
    };
}

- (MGJMWPResult *(^)(BOOL))setIsCompleted {
    return ^MGJMWPResult *(BOOL value) {
        self.isCompleted = value;
        return self;
    };
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@-%p:\n<Status>:%@\n<Message>:%@\n<IsCompleted>:%d\n<Error>:%@\n<ReturnObj>:%@", [self class], self, self.status, self.msg, self.isCompleted, [self.error description], [self.returnObj description]];
}

@end
