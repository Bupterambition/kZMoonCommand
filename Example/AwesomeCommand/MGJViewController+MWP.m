//
//  MGJViewController+MWP.m
//  AwesomeCommand
//
//  Created by Derek Chen on 8/28/16.
//  Copyright © 2016 wentong. All rights reserved.
//

#import "MGJViewController+MWP.h"

@implementation MGJViewController (MWP)

- (void)test4MWP {
    [self setupMWP];
//    [self test4MWPPet0];
    NSLog(@"****** ****** ****** ****** ****** ****** ****** ****** ****** ****** ****** ****** ");
    [self test4MWPPet1];
}

- (void)setupMWP {
    [MGJApp registerApp:@"mgj"
                   type:@"iphone"
                channel:@"NIMAppStore"
                appleId:@"452176796"
              appSecret:@"765c928c861362ece640cf0c6c84c41a"];
    
    [MGJAnalytics startWithAppName:MGJAnalyticsAppNameMoGuJie channel:@"NIMAppStore"];
    
    [[MWPRemote defaultRemote] buildConfig:@{@"appKey" : @"100002",
                                             @"env" : @"release",
//                                             @"mw-debug":@"1",
//                                             @"mw-trace":@"1",
//                                             @"log_on" : @"1"
                                             }];
    
    [[MWPRemote defaultRemote] setUserId:@"11mlc1a" sessionID:@"AKHLLB4grOqukSbQGtJScmZ70IkS7khFsXflaYcJu+pEeZM7xIMGxeglhlyriyttalJot9jk5irEY7NaI8M6Yw=="];
    
    // session过期
    [MWPRemote defaultRemote].refreshBlock = ^() {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[MWPRemote defaultRemote] updateUserInfo:@{@"status" : @"success"}];
        });
    };
    
    //    id<RemoteBizConfig> bizConfig = [MWPRemote defaultRemote].bizConfig;
    //    [bizConfig setBizHead:@{@"trade_k1" : @"v1", @"trade_k2" : @"v2"} nameSpace:@"TRADE"];
    
}

- (void)test4MWPPet0 {
    MGJMWPPet *pet0 = [[MGJMWPPet alloc] init];
    pet0.name = @"HelloWorld";
    pet0.age = 99;
    
    MGJMWPRequestInfo *reqInfo = [[MGJMWPRequestInfo alloc] init].setMethod(R_METHOD_POST).setAPI(@"mwp.PetStore.helloWorld").setVersion(@"2").setParams(@{@"pet": pet0}).setReturnClass([MGJMWPPet class]);
    NSLog(@"%@", reqInfo);
    //    [[[[[reqInfo method:R_METHOD_POST] api:@"mwp.PetStore.helloWorld"] version:@"2"] params:@{@"pet": pet0}] returnClass:[MGJMWPPet class]];
    
    //    self.mwpCmd0 = [[MGJMWPCommand alloc] initWithMWPRequestInfo:reqInfo];
    self.mwpCmd0 = [[MGJMWPCommand alloc] initWithMWPAPI:@"mwp.PetStore.helloWorld" version:@"2" andReturnClass:[MGJMWPPet class]];
    //    [self.mwpCmd0 executeWithBlock:^(id<MGJAwesomeExecutable> cmd, id data, NSError *error, BOOL isCompleted) {
    //        if (error) {
    //            NSLog(@"%@", [error description]);
    //        } else if (isCompleted) {
    //        } else if (data) {
    //            id<RemoteResponse> response = data;
    //            if ([[[response playLoad] data] isKindOfClass:[MGJMWPPet class]]) {
    //                MGJMWPPet *pet1 = (MGJMWPPet *)[[response playLoad] data];
    //                NSLog(@"%@", [pet1 description]);
    //            }
    //        }
    //    }];
    
    dispatch_queue_t queue = dispatch_queue_create("HelloGCD", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(queue, ^{
        [self.mwpCmd0 executeWithParams:@{@"Pet": pet0} andBlock:^(id<MGJAwesomeExecutable> cmd, id returnObj, NSString *status, NSString *msg, NSError *error, BOOL isCompleted) {
            if (error) {
                NSLog(@"%@", [error description]);
            } else if (returnObj) {
                NSLog(@"%@", [returnObj description]);
            } else if (isCompleted) {
                NSLog(@"!!!self.mwpCmd0 completed!!!");
            }
        }];
    });
}

- (void)test4MWPPet1 {
    MGJMWPPet *pet0 = [[MGJMWPPet alloc] init];
    pet0.name = @"HelloWorld";
    pet0.age = 99;
    
    self.petCmd0 = [[MGJMWPPetCmd alloc] init];
    self.petCmd1 = [[MGJMWPPetCmd alloc] init];
    self.queue = dispatch_queue_create("HelloPet", DISPATCH_QUEUE_CONCURRENT);
    [self.petCmd1 setExecQueue:self.queue];
    
//    [self mgj_observe:self.petCmd0 keyPath:@"result" block:^(id obj) {
//        NSLog(@"%@", obj);
//    }];
//
//    dispatch_async(self.queue, ^{
//        [self.petCmd0 executeWithParams:@{@"Pet": pet0}];
//    });
    
    
    @weakify(self);
    self.callback = ^(id<MGJAwesomeExecutable> cmd, MGJMWPPet *returnObj, NSString *status, NSString *msg, NSError *error, BOOL isCompleted) {
        @strongify(self);
        if (error) {
            NSLog(@"%@", [error description]);
        } else if (returnObj) {
            NSLog(@"%@", [returnObj description]);
        } else if (isCompleted) {
            NSLog(@"!!!self.petCmd1 completed!!!");
            [self.petCmd1 executeWithParams:@{@"Pet": pet0} andBlock:self.callback];
        }
    };
    
    [self.petCmd1 executeWithParams:@{@"Pet": pet0} andBlock:self.callback];
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [self.petCmd1 executeWithParams:@{@"Pet": pet0} andBlock:self.callback];
//        
//        sleep(5);
//        self.petCmd1 = nil;
//    });
}

@end
