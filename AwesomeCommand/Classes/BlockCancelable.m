//
// Created by  on 16/5/31.
//

#import "BlockCancelable.h"
#import "AwesomeCommandPublicDefine.h"

@interface BlockCancelable ()

@property (atomic, assign, getter = isCanceled) BOOL canceled;
@property(nonatomic, copy) AwesomeCancelBlock cancelBlock;

@end

@implementation BlockCancelable

@synthesize canceled = _canceled;

- (void)dealloc {
    self.cancelBlock = nil;
}

- (instancetype)initWithBlock:(AwesomeCancelBlock)block {
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
