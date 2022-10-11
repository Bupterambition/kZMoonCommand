//
//  ViewController.m
//  kZMoonCommand
//
//  Created by BupterAmbition on 05/31/2016.
//  Copyright (c) 2016 . All rights reserved.
//

#if __has_include(<ReactiveObjC/ReactiveObjC.h>)
#import <ReactiveObjC/ReactiveObjC.h>
#elif __has_include(<ReactiveCocoa/ReactiveCocoa.h>)
#import <ReactiveCocoa/ReactiveCocoa.h>
#endif
#import "ViewController.h"
#import "kZMoonCallbackObject.h"
#import <kZMoonCommand/kZMoonCommandPublicHeader.h>
#import <pthread/pthread.h>
#import "RequestCommand.h"
#import "FirstCommand.h"
#import "SecondCommand.h"
#import "ThirdCommand.h"
#import "FourthCommand.h"
#import "FifthCommand.h"
#import "MultibleCommandForTest.h"


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-variable"
#pragma clang diagnostic ignored "-Wshadow-ivar"

@interface ViewController ()
@property (nonatomic, strong) FirstCommand *firstCMD;

@end

@implementation ViewController {
    RequestCommand *requestCMD;
    SecondCommand *secondCMD;
    ThirdCommand *thirdCMD;
    FourthCommand *fourthCMD;
    FifthCommand *fifthCMD;
    id<kZMoonCallback> callback;
    MultibleCommandForTest *multiCMD;
    id <kZMoonCommand> bindCmd;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self testForCombine];//测试复杂绑定
//    [self testRequestCMD];  //测试excute执行
//    [self testRequestCMDwithSignal];//测试signal执行
//    [self testMutilThread];//测试多线程安全
//    [self bindOperation];//Command串联操作

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - TestRequestCMD

- (void)testRequestCMD {
    requestCMD = [[RequestCommand alloc] init];
    
    id<kZMoonCallback> callback = [[kZMoonCallbackObject alloc] init];
    RACSignal *signal = [requestCMD createSignal];
    RACSubject *subject = [RACSubject subject];
    [requestCMD subject:subject];
    //第一种方式通过callback回调获得回调值
    id<kZMoonCancelable> cancelObject_one = [requestCMD executeWithCallback:callback];
    
//    第二种方式通过subject回调获得回调值
    [subject subscribeNext:^(id x) {
        
    } error:^(NSError *error) {
        
    } completed:^{
        
    }];
    
    //第三种方式通过block回调获得回调值
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        id<kZMoonCancelable> cancelObject_two = [requestCMD executeWithBlock:^(id<kZMoonExecutable> cmd, id data, NSError *error, BOOL isCompleted) {
            
        }];
    });
    
    
//    [cancelObject_one cancel];
}

#pragma mark - TestRequestCMDwithSignal

- (void)testRequestCMDwithSignal {
    requestCMD = [[RequestCommand alloc] init];
    [requestCMD setValue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) forKey:@"excuteQueue"];
    
    RACSignal __block *signal ;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        signal = [requestCMD createSignal];
    });
    for (NSInteger index=999999; index>0; index--) {
        ;
    }
    RACDisposable *disposable = [signal subscribeNext:^(id x) {
        
    } completed:^{
        
    }];
//    [disposable dispose];
}

#pragma mark - TestMutilThread
NSUInteger count = 100;
- (void)testMutilThread {
    
    multiCMD = [[MultibleCommandForTest alloc] init];
    dispatch_queue_t runQueue = dispatch_queue_create("runQueue", DISPATCH_QUEUE_CONCURRENT);
    [multiCMD setValue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) forKey:@"excuteQueue"];
    NSUInteger __block index;
    RACSignal *signal_1 = [multiCMD createSignal];
    multiCMD.excuteBlock = (id) ^(id<kZMoonResult> result) {
        ticketSellor(index);
        return [NSOperation new];
    };
    for (index = 0; index<5; index ++) {
        sleep(2);
        dispatch_queue_t queue = dispatch_queue_create([[NSString stringWithFormat:@"queue_%ld",index] UTF8String], DISPATCH_QUEUE_CONCURRENT);
        dispatch_async(queue, ^{
            [signal_1 subscribeNext:^(id x) {
                
            }];
        });
    }
}

void ticketSellor(NSUInteger sellorIndex){
    
    while(YES) {
        sleep(rand()%6+1);// 等待购票人来购票
        NSLog(@"售票员 %ld等待 临界资源 ...",sellorIndex);
        //**************************************  <临界区>
        if (count>0) {
            NSLog(@"售票员 %ld正在 出售第  %ld 张票 ...",sellorIndex,count);
            
            count --;
        }else{
            NSLog(@"售票员 %ld发现票已经售完，等待...",sellorIndex);
        }
        //**************************************  <临界区/>
    }
    
    
}

#pragma mark - TestForCombine

- (void)testForCombine {
  requestCMD = [[RequestCommand alloc] init];

  RACSignal *signal = [requestCMD createSignal];

  self.firstCMD = [[FirstCommand alloc] init];
  @weakify(self);
  self.firstCMD.excuteBlock = (id) ^ (id<kZMoonResult> result) {
    // Example
    @strongify(self);
    NSLog(@"开始执行 Command 1");
    [result onNext:@401];
    [result onComplete];
    return [NSOperation new];
  };

  RACSignal *signal_1 = [self.firstCMD createSignal];

  secondCMD = [[SecondCommand alloc] init];

  RACSignal *signal_2 = [secondCMD createSignal];

  thirdCMD = [[ThirdCommand alloc] init];

  RACSignal *signal_3 = [thirdCMD createSignal];

  fourthCMD = [[FourthCommand alloc] init];

  RACSignal *signal_4 = [fourthCMD createSignal];

  fifthCMD = [[FifthCommand alloc] init];

  RACSignal *signal_5 = [fifthCMD createSignal];

  RACSignal *combine1_2 = [signal_1 combineLatestWith:signal_2];
  RACSignal *then12_3 = [combine1_2 then:^RACSignal * {
    return signal_3;
  }];
  RACSignal *combine3_R = [then12_3 combineLatestWith:signal];
  RACSignal *then3R_4 = [combine3_R then:^RACSignal * {
    return signal_4;
  }];
//  [then3R_4 subscribeNext:^(id x) {
//    NSLog(@"回调 Command 4");
//  }];

  [[RACSignal combineLatest:@[ then3R_4, signal_5 ]
                     reduce:^id(NSNumber *num1, NSNumber *num2) {
                       return @(num1.integerValue + num2.integerValue);
                     }] subscribeNext:^(id x) {
    NSLog(@"final value is:______%ld______", [x integerValue]);
  }];
}

#pragma mark - Bind Operation

- (void)bindOperation {
    requestCMD = [[RequestCommand alloc] init];
    //warning:需要返回值需要被持有
    bindCmd = [requestCMD bind:^kZMoonCommand * _Nullable(NSUInteger index, id<kZMoonCommand>  _Nonnull cmd, id  _Nonnull data, NSError * _Nonnull error, BOOL isCompleted) {
        fifthCMD = [[FifthCommand alloc] init];
        return fifthCMD;
    }];
    [bindCmd executeWithBlock:^(id<kZMoonExecutable> cmd, id data, NSError *error, BOOL isCompleted) {
        
    }];
}

@end
#pragma clang diagnostic pop
