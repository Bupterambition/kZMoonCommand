# kZMoonCommand




[![CI Status](http://img.shields.io/travis/wentong/AwesomeCommand.svg?style=flat)](https://travis-ci.org/wentong/AwesomeCommand)
[![Version](https://img.shields.io/cocoapods/v/AwesomeCommand.svg?style=flat)](http://cocoapods.org/pods/AwesomeCommand)
[![License](https://img.shields.io/cocoapods/l/AwesomeCommand.svg?style=flat)](http://cocoapods.org/pods/AwesomeCommand)
[![Platform](https://img.shields.io/cocoapods/p/AwesomeCommand.svg?style=flat)](http://cocoapods.org/pods/AwesomeCommand)


* [中文版本](#中文版)

## based on 

<div align=center>
<img src="https://github.com/ReactiveCocoa/ReactiveCocoa/blob/master/Logo/header.png"  />
</div>


## （1）Introduction

kZMoonCommand is inspired **ReactiveCocoa** . As your App grows, your code will lead to an **accumulation** of business logic .After over time, a lot of overlap with the business logic result in confusing code. Based on this requirement, we write a new  command in order to **ignore the confuse thread progress only consider the final result**, so each business logic component can be written as a Signal chain, only need to manage the chain afterwards. At the same time, we do a lot kZMoonCommand **thread optimized** so that execution thread and callback thread completely separated, while ensuring the security thread, so external callers only need to be concerned about the relationship between the business logic does not require threading issues.
##	 （2）Install
	pod 'kZMoonCommand'
	
## （3）Core Class

[AwesomeCommand](https://github.com/Bupterambition/AwesomeCommand/blob/master/AwesomeCommand/Classes/AwesomeCommand.m)

Base Class of kZMoonCommand.It offers a variety of ways to call without the knowledge of ReactiveCocoa.


## （4）Usage

kZMoonCommand is an atomic base class offerring a lots of method .

#### 1. Base Usage－Inherit kZMoonCommand,Overwrite run method


```objc
// RequestCommand.h
#import <kZMoonCommand/AwesomeCommand.h>

@interface RequestCommand : AwesomeCommand
@property (nonatomic, copy) NSDictionary *param;
@end
```

```objc
// RequestCommand.m

#import "RequestCommand.h"
#import <kZMoonCommand/AwesomeCommandPublicHeader.h>

@implementation RequestCommand

@synthesize excuteQueue = _excuteQueue;

- (instancetype)init {
    self = [super init];
    if (self) {
    	// assign the excuting queue inside of class
        _excuteQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    }
    return self;
}
- (id<AwesomeCancelable>)run:(id<AwesomeResult>)result {
    // Logic 
    NSLog(@"Command Request");
    NSLog(@"current thread:__%@__",[NSThread currentThread]);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [result onNext:self.param];  // send the result of Network to caller
        [result onComplete];  // should write after sending result .It marked the end of this command 
    });
    NSOperation *disposeOperation = [NSOperation new];
    return [DefaultAwesomeCancelable cancelableWithCancelBlock:^{
        // something to compose
        // Example
        [disposeOperation cancel];
    }];
}
@end
```
```objc
// the way of Block，kZMoonCommand will retain block，so you should manage the life of var in block。
requestCMD = [[RequestCommand alloc] init];
requestCMD.param = @{"bankName":@"CCB"};
id<AwesomeCancelable> cancelObject_two = [requestCMD executeWithBlock:^(id<AwesomeExecutable> cmd, id data, NSError *error, BOOL isCompleted) {
        // call back here
        // the current thread is the thread of call executeWithBlock：
    }];

```
```objc
//the way of Callback object，awesomecommand won't retain callback object，so the callback object should be managed by caller.
@Interface AwesomeCallbackViewModel()<AwesomeCallback>
@property (nonatomic, strong) RequestCommand *requestCMD;
@end

@implementation AwesomeCallbackViewModel

- (void)onNext:(kZMoonCommand *)command AndData:(id)data{

}
- (void)onComplete:(kZMoonCommand *)command {

}
- (void)onError:(kZMoonCommand *)command AndError:(NSError *)error {

}
- (void)executeRequestCMD {
   self.requestCMD.param = @{@"argu":@"Awesome"};
   [self.requestCMD executeWithCallback:self];
}
```
#### 2. The way of Exec block

`you need not to overwrite run: method `

```objc
//RequestCommand.h
#import <kZMoonCommand/AwesomeCommand.h>

@interface RequestCommand : AwesomeCommand

@end
```

```objc
//RequestCommand.m

#import "RequestCommand.h"
#import <kZMoonCommand/AwesomeCommandPublicHeader.h>

@implementation RequestCommand

@synthesize excuteQueue = _excuteQueue;

- (instancetype)init {
    self = [super init];
    if (self) {
    	// assign the excuting queue inside of class
        _excuteQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    }
    return self;
}

@end
```
```objc
//main.m

requestCMD = [[RequestCommand alloc] init];
requestCMD.excuteBlock = ^(id<AwesomeResult> result){
        NSLog(@" Command Request");
        NSLog(@"current thread:__%@__",[NSThread currentThread]);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [result onNext:@"requestCMD"];
            [result onComplete];
        });
        NSOperation *disposeOperation = [NSOperation new];
        return [DefaultAwesomeCancelable cancelableWithCancelBlock:^{
            //something to compose
            //Example
            [disposeOperation cancel];
        }];
    };
id<AwesomeCancelable> cancelObject_two = [requestCMD executeWithBlock:^(id<AwesomeExecutable> cmd, id data, NSError *error, BOOL isCompleted) {
        // call back here
        // the current thread is the thread of call executeWithBlock：
    }];

```
#### 3. The way of RAC
Assuming a situation shown below
<div align=center>
<img src="https://github.com/Bupterambition/AwesomeCommand/blob/master/AwesomeCommand/Assets/Demo.gif" width = "400" height = "300" alt="" />
</div>

Assuming that we have six diffent tasks to Operate,but there is quite a bit of inter-dependence among these tasks.For instance,`3` depends on the completion of `1 and 2`.`0`depends on the completion of`3 and  4`,final output depends on the completion of `0 and 5`.Such a complicated diagram with a traditional logic code to write will certainly be very confusing ,even considering the diffence between each callback thread and excuting thread , the program  will be more complex.

if you use kZMoonCommand,it should like this:

```objc
  RACSignal *signal_0 = [requestCMD createSignal];

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
  RACSignal *combine3_4 = [then12_3 combineLatestWith:signal_4];
  RACSignal *then34_0 = [combine3_4 then:^RACSignal * {
    return signal_0;
  }];
  [[RACSignal combineLatest:@[ then34_0, signal_5 ]
                     reduce:^id(NSNumber *num1, NSNumber *num2) {
                       return @(num1.integerValue + num2.integerValue);
                     }] subscribeNext:^(id x) {
    NSLog(@"final value is:______%ld______", [x integerValue]);
  }];

```

#### 4. More instance

Clone the repo 



## （5）Cancel

As atomic based class, kZMoonCommand should be inherited of subclass,so the subclass is the context by itself.

##### Manual cancel

```objc
id<AwesomeCancelable> cancelObject_two = [requestCMD executeWithBlock:^(id<AwesomeExecutable> cmd, id data, NSError *error, BOOL isCompleted) {
        
}];
    
[cancelObject_one cancel];

```

##### Auto cancel

```objc
//kZMoonCommand.m

- (void)dealloc {
    [self cancel];
}

```
## Tips
You can run a script to install kZMoonCommand Template


![](https://github.com/Bupterambition/Kiwi-Template/blob/master/template.jpeg?raw=true)


```
sudo chmod 755 install-templates.sh

sudo sh install-templates.sh 
```
## Author
senmiao, bupterambition@gmail.com
## Issue

If you have any issue of this component,please contact me

## License

kZMoonCommand is available under the MIT license. See the LICENSE file for more info.


## <a id="中文版"></a>中文版


## （一）组件介绍
随着业务的发展，越来越多的业务逻辑堆积到一块，日积月累后，很多业务逻辑会交叠在一起，导致后续整理的时候`十分混乱`，基于这个需求，我们重构command组件，整体是基于`ReactiveCocoa`，这样的话不需要考虑调用顺序，只需要知道考虑结果，这样每个业务逻辑可以写成一条Signal链，后续只需要对`链`进行管理就可以。同时，我们对kZMoonCommand的`线程`做了很大优化，使得`执行线程`和`回调线程`完全分离，同时保证了`线程安全`，这样外部调用者就只需要关系业务逻辑`不需要关心线程`问题。
##	 （二）安装
	pod 'kZMoonCommand'
	
## （三）Core Class

[AwesomeCommand](https://github.com/Bupterambition/AwesomeCommand/blob/master/AwesomeCommand/Classes/AwesomeCommand.m)

组件的基础类，提供了多种调用方式，方便对RAC不熟悉的同学，也可以玩转RAC



## （四）使用姿势
kZMoonCommand作为一个原子的基类，提供了多种使用方法

#### 1. 基本姿势－继承kZMoonCommand,将逻辑写在run方法中


```objc
// RequestCommand.h
#import <kZMoonCommand/AwesomeCommand.h>

@interface RequestCommand : AwesomeCommand
@property (nonatomic, copy) NSDictionary *param;//执行command需要的参数
@end
```

```objc
// RequestCommand.m

#import "RequestCommand.h"
#import <kZMoonCommand/AwesomeCommandPublicHeader.h>

@implementation RequestCommand

@synthesize excuteQueue = _excuteQueue;

- (instancetype)init {
    self = [super init];
    if (self) {
    	// 内部指定command的执行线程
        _excuteQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    }
    return self;
}
- (id<AwesomeCancelable>)run:(id<AwesomeResult>)result {
    // 逻辑需要写在这里
    NSLog(@"开始执行 Command Request");
    NSLog(@"current thread:__%@__",[NSThread currentThread]);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [result onNext:self.param];  // 网络返回结果
        [result onComplete];  // 必须执行，标示Command执行完毕
    });
    NSOperation *disposeOperation = [NSOperation new];
    return [DefaultAwesomeCancelable cancelableWithCancelBlock:^{
        // something to compose
        // Example
        [disposeOperation cancel];
    }];
}
@end
```
```objc
// Block回调形式，Cmd会retain block，在block里请自行管理好持有对象的生命周期。
requestCMD = [[RequestCommand alloc] init];
requestCMD.param = @{"bankName":@"CCB"};
id<AwesomeCancelable> cancelObject_two = [requestCMD executeWithBlock:^(id<AwesomeExecutable> cmd, id data, NSError *error, BOOL isCompleted) {
        // 获取回调
        // 这里回调的线程是在执行executeWithBlock：方法的线程中
    }];

```
```objc
// Callback object回调形式，Cmd不会retain callback object，这个对象的生命周期需要外部自己管理。
@Interface AwesomeCallbackViewModel()<AwesomeCallback>
@property (nonatomic, strong) RequestCommand *requestCMD;
@end

@implementation AwesomeCallbackViewModel

- (void)onNext:(kZMoonCommand *)command AndData:(id)data{

}
- (void)onComplete:(kZMoonCommand *)command {

}
- (void)onError:(kZMoonCommand *)command AndError:(NSError *)error {

}
- (void)executeRequestCMD {
   self.requestCMD.param = @{@"argu":@"Awesome"};
   [self.requestCMD executeWithCallback:self];
}
```
#### 2. Exec block使用姿势(如果您能管理好)

`不需要重写run方法（不推荐）`

```objc
//RequestCommand.h
#import <kZMoonCommand/AwesomeCommand.h>

@interface RequestCommand : AwesomeCommand

@end
```

```objc
//RequestCommand.m

#import "RequestCommand.h"
#import <kZMoonCommand/AwesomeCommandPublicHeader.h>

@implementation RequestCommand

@synthesize excuteQueue = _excuteQueue;

- (instancetype)init {
    self = [super init];
    if (self) {
    	//内部指定command的执行线程
        _excuteQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    }
    return self;
}

@end
```
```objc
//main.m

requestCMD = [[RequestCommand alloc] init];
requestCMD.excuteBlock = ^(id<AwesomeResult> result){
        NSLog(@"开始执行 Command Request");
        NSLog(@"current thread:__%@__",[NSThread currentThread]);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [result onNext:@"requestCMD"];
            [result onComplete];
        });
        NSOperation *disposeOperation = [NSOperation new];
        return [DefaultAwesomeCancelable cancelableWithCancelBlock:^{
            //something to compose
            //Example
            [disposeOperation cancel];
        }];
    };
id<AwesomeCancelable> cancelObject_two = [requestCMD executeWithBlock:^(id<AwesomeExecutable> cmd, id data, NSError *error, BOOL isCompleted) {
        //获取回调
        //这里回调的线程是在执行executeWithBlock：方法的线程中
    }];

```
#### 3. RAC用法
假设我们有一个这样的场景
<div align=center>
<img src="https://github.com/Bupterambition/AwesomeCommand/blob/master/AwesomeCommand/Assets/Untitled.gif" width = "400" height = "300" alt="" />
</div>


有6个操作，但是它们之间的执行顺序是有`依赖`的，比如`3`的执行需要依赖` 1 2完成`后才执行，`0`的执行需要依赖`3 4执行完`，最后的`输出`需要`0和5都执行完毕`，这样一个略显复杂的图如果用传统的逻辑来写的话肯定会组织的非常混乱，如果考虑到每个操作的执行和回调线程可能都是不同的话，那更将加大了复杂度。

但是如果使用kZMoonCommand来写的话，是下面这样子的

```objc
  RACSignal *signal_0 = [requestCMD createSignal];

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
  RACSignal *combine3_4 = [then12_3 combineLatestWith:signal_4];
  RACSignal *then34_0 = [combine3_4 then:^RACSignal * {
    return signal_0;
  }];
  [[RACSignal combineLatest:@[ then34_0, signal_5 ]
                     reduce:^id(NSNumber *num1, NSNumber *num2) {
                       return @(num1.integerValue + num2.integerValue);
                     }] subscribeNext:^(id x) {
    NSLog(@"final value is:______%ld______", [x integerValue]);
  }];

```

#### 4. 更多案例

请查看工程中案例

## （五）上下文环境与Cancel

kZMoonCommand作为一个原子基类，在使用时需要将它子类化，所需的Context即是子类的属性，因此子类本身就是一个Context。如果调用方需要检测command的执行情况的话，只需要KVO下executing这个属性。

kZMoonCommand提供了手动Cancel与自动Cancel功能.
##### 手动cancel

```objc
id<AwesomeCancelable> cancelObject_two = [requestCMD executeWithBlock:^(id<AwesomeExecutable> cmd, id data, NSError *error, BOOL isCompleted) {
        
}];
    
[cancelObject_one cancel];

```

##### 自动cancel
自动cancel功能，我们是在kZMoonCommand的dealloc中进行cancel

```objc
//AwesomeCommand.m

- (void)dealloc {
    [self cancel];
}

```


## （六）若干问题

### 1线程问题
#### 执行线程与回调线程
kZMoonCommand设计的初衷是让使用者`不用去关心线程`问题，并且保证不会出错，在设计时我们将执行线程和回调线程进行分离，具体的做法的作用是通过下面两个函数实现

```objc
- (RACSignal *)deliverOn:(RACScheduler *)scheduler;//将订阅和副作用转移到目标线程
- (RACSignal *)subscribeOn:(RACScheduler *)scheduler;//只将订阅转移到目标线程

```

使用时我们只需要在初始化的时候指定一下需要进行逻辑执行的线程即可

```objc
@implementation RequestCommand
@synthesize excuteQueue = _excuteQueue;
- (instancetype)init {
    self = [super init];
    if (self) {
        _excuteQueue = dispatch_get_global_queue(0, 0);
    }
    return self;
}

```
对于回调线程，调用方不需要关心，因为kZMoonCommand会捕获当前执行下面语句时的线程并在有回调时进行返回

```objc
- (id<AwesomeCancelable>)executeWithCallback:(id<AwesomeCallback>)callback;

- (id<AwesomeCancelable>)executeWithBlock:	(AwesomeExcuteCallbaclBlock)callbackBlock;

- (RACSignal *)createSignal;


```
比如说你想写一个在子线程中跑逻辑在主线程中取回调的逻辑

```objc
#import <kZMoonCommand/AwesomeCommand.h>

@interface FirstCommand : AwesomeCommand

@end

_________________________________________________________________

#import "FirstCommand.h"
#import <kZMoonCommand/AwesomeCommandPublicHeader.h>
@implementation FirstCommand

@synthesize excuteQueue = _excuteQueue;

- (instancetype)init {
    self = [super init];
    if (self) {
        _excuteQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    }
    return self;
}

- (id<AwesomeCancelable>)run:(id<AwesomeResult>)result {
    NSLog(@"开始执行 Command 1,线程:%@",[NSThread currentThread]);
    [result onNext:@"1"];
    [result onComplete];
    NSOperation *disposeOperation = [NSOperation new];
    return [DefaultAwesomeCancelable cancelableWithCancelBlock:^{
        //something to compose
        //Example
        [disposeOperation cancel];
    }];
}

@end
_________________________________________________________________

@interface ViewController ()
@property (nonatomic, strong) FirstCommand *firstCMD;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.firstCMD = [[FirstCommand alloc] init];
  id<AwesomeCancelable> cancelObject_two = [firstCMD executeWithBlock:^(id<AwesomeExecutable> cmd, id data, NSError *error, BOOL isCompleted) {
        //逻辑在子线程，回调在主线程
    }];
```
#### 线程安全问题
##### 资源竞争

kZMoonCommand的驱动是依靠RACSignal的，因此我在创建这个驱动Signal的`didSubscribe`中加入`pthread_mutex_t`，在副作用执行时会进行加锁。具体代码如下

```objc

@implementation SignalUtil

+ (RACSignal *)createSignal:(nonnull kZMoonCommand *)command {
    pthread_mutex_t _mutex;
    const int result = pthread_mutex_init(&_mutex, NULL);
    NSCAssert(0 == result, @"Failed to initialize mutex with error %d.", result);
    
    @weakify(command);
    RACSignal *racSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(command);
        if (command && [command respondsToSelector:@selector(run:)]) {
            pthread_mutex_lock(&_mutex);
            
            id<AwesomeResult> result = [AwesomeResultImpl resultWithSubscriber:subscriber];

            [command setValue:@(YES) forKey:@"Executing"];
            id<AwesomeCancelable> cancelable = [command run:result];
            
            pthread_mutex_unlock(&_mutex);
            if (cancelable) {
                return [RACDisposable disposableWithBlock:^{
                    [cancelable cancel];
                }];
            } else {
                return nil;
            }
            
        }
        return nil;
    }];

    return racSignal;

}

```
##### 优先级反转
在我们的实际代码中，可能不会像火星探测器那样，越到优先级反转时，不断的重启。

解决这个问题的方法，通常就是`不要使用不同的优先级`－－将高优先级的代码和低优先级的代码修改为相同优先级。当使用GCD时，总是使用默认的优先级队列。如果使用不同的优先级，就可能会引发事故。

虽然有些文章上说，在不同的队列中使用不同的优先级，但是这会增加并发编程的复杂度和不可预见性。

那么如果你非要在回调时使用不同优先级的话，也是没有问题的，因为kZMoonCommand里面是设置的`callback Queue`，里面`不会`有大量的读取任务占据着资源，只是起到一个`回调通道`的作用，所以也不存在卡住问题。

### 2.RAC使用成本

kZMoonCommand的驱动是依靠`RACSignal`，但是除了复杂的场景外——比如像是多个操作有依赖关系，在使用kZMoonCommand时，RAC相关的都被`封装`起来了，使用方只需要关注业务逻辑就可以。

但是如果你是RAC的深度用户或是对RAC比较感兴趣的话，将会更加灵活的去使用kZMoonCommand。

因此kZMoonCommand对于`熟悉或是不熟悉RAC`的同学都可以无差别使用。

### 3.RAC学习资源

如果你也对RAC感兴趣的话，大量相关资料请戳下面


 ####入门


[ReactiveCocoa 和 MVVM 入门](http://yulingtianxia.com/blog/2015/05/21/ReactiveCocoa-and-MVVM-an-Introduction/)

[ReactiveCocoa入门教程：第一部分](http://southpeak.github.io/blog/2014/08/02/reactivecocoazhi-nan-%5B%3F%5D-:xin-hao/)

[ReactiveCocoa入门教程：第二部分](http://southpeak.github.io/blog/2014/08/02/reactivecocoazhi-nan-er-:twittersou-suo-shi-li/)

[说说ReactiveCocoa 2](http://www.cocoachina.com/ios/20140115/7702.html)

[iOS 7最佳实践：一个天气App案例](http://www.cocoachina.com/ios/20140224/7868.html)

[Reactive Cocoa Tutorial [0] = Overview](http://blog.sunnyxx.com/2014/03/06/rac_0_overview/)

[Reactive Cocoa Tutorial [1] = 神奇的Macros](http://blog.sunnyxx.com/2014/03/06/rac_1_macros/)

[Reactive Cocoa Tutorial [2] = 百变RACStream](http://blog.sunnyxx.com/2014/03/06/rac_2_racstream/)

[Reactive Cocoa Tutorial [3] = RACSignal的巧克力工厂](http://blog.sunnyxx.com/2014/03/06/rac_3_racsignal/)

[Reactive Cocoa Tutorial [4] = 只取所需的Filters](http://blog.sunnyxx.com/2014/04/19/rac_4_filters/)

[ReactiveCocoa2 源码浅析](http://nathanli.cn/2015/08/27/reactivecocoa2-源码浅析/)

[最快让你上手ReactiveCocoa之基础篇](http://www.jianshu.com/p/87ef6720a096)

[最快让你上手ReactiveCocoa之进阶篇](http://www.jianshu.com/p/e10e5ca413b7)

[ReactiveCocoa框架菜鸟入门（五）——信号的FlattenMap与Map](http://demo.netfoucs.com/abc649395594/article/details/46552865)

[iOS开发之ReactiveCocoa下的MVVM](http://www.tuicool.com/articles/J7j6bmR)

[ReactiveCocoa与Functional Reactive Programming](http://www.cnblogs.com/linyawen/p/3522023.html)


####进阶


[ReactiveCocoa 用 RACSignal 替代 Delegate](http://www.cocoachina.com/ios/20141229/10789.html)

[ReactiveCocoa2实战](http://www.cocoachina.com/ios/20140609/8737.html)

[基于AFNetworking2.0和ReactiveCocoa2.1的iOS REST Client](http://www.cocoachina.com/ios/20140126/7759.html)

[ReactiveCocoa基本组件：理解和使用RACCommand](http://blog.csdn.net/womendeaiwoming/article/details/37597779)

[ReactiveCocoa2 源码浅析](http://blog.csdn.net/womendeaiwoming/article/details/48036725)


####资料


| 资料名称   |  资料描述 |
|:-------:|:-------:|
|[Learn ReactiveCocoa Source](https://github.com/mailworks/LearnReactivecocoaSource)|学习ReactiveCocoa(主要针对2.x Objective-C 版本)过程中整理的一些资料。|


####开源项目


| 项目名称                                                                      |                                        项目描述                      |
|:----------------------------------------------------------------------------:|:------------------------------------------------------------------:|
|[ddaajing/ReactiveCocoaDemo](https://github.com/ddaajing/ReactiveCocoaDemo)   | 该Demo主要用来测验MVVM模式的分层，使APP更方便维护，测试 以及练习ReactiveCocoa相关API  |
| [ashfurrow/C-41](https://github.com/ashfurrow/C-41)                          |[介绍博客](http://blog.csdn.net/zzdjk6/article/details/46996571)     |    
| [arbullzhang/KoalaFRP](https://github.com/arbullzhang/KoalaFRP)              |  说明:FunctionalReactivePixels 做了修改，因为编译不过。                 |
| [leichunfeng/MVVMReactiveCocoa](https://github.com/leichunfeng/MVVMReactiveCocoa)| **推荐！一个完整的使用MVVM和RAC的Github客户端，leichunfeng大师作品。**|
|[ashfurrow / FunctionalReactivePixels](https://github.com/ashfurrow/FunctionalReactivePixels)|演示使用500px的API来使用FRP与ReactiveCocoa在iOS的环境。|


## Tips
为了方便构建kZMoonCommand的子类，你可以通过使用下面的脚本建立一个AwesomeComand的模版

![](https://github.com/Bupterambition/Kiwi-Template/blob/master/template.jpeg?raw=true)

```
sudo chmod 755 install-templates.sh

sudo sh install-templates.sh 
```

## Author
senmiao, senmiao@meili-inc.com,
## Issue

最后如果你有疑问，请Issue

## License

kZMoonCommand is available under the MIT license. See the LICENSE file for more info.

