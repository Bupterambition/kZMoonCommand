//
// Created by BupterAmbition on 16/5/31.
//

#import "BlockCancelable.h"
#import "kZMoonCommandPublicDefine.h"

@interface BlockCancelable ()

@property (atomic, assign, getter = isCanceled) BOOL canceled;
@property(nonatomic, copy) kZMoonCancelBlock cancelBlock;

@end

@implementation BlockCancelable

@synthesize canceled = _canceled;

- (void)dealloc {
    self.cancelBlock = nil;
}

- (instancetype)initWithBlock:(kZMoonCancelBlock)block {
    self = [super init];
    if (self) {
        @synchronized (self) {
            self.cancelBlock = block;
        }
    }

    return self;
}

- (void)cancel {
    if (!self.isCanceled) {
        @synchronized (self) {
            SafeExecBlock(self.cancelBlock)();
            self.cancelBlock = nil;
            
            self.canceled = YES;
        }
    }
}

@end
