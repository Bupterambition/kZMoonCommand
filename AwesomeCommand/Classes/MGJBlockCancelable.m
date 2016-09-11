//
// Created by Senmiao on 16/5/31.
//

#import "MGJBlockCancelable.h"
#import "MGJAwesomeCommandPublicDefine.h"

@interface MGJBlockCancelable ()

@property (atomic, assign, getter = isCanceled) BOOL canceled;
@property(nonatomic, copy) MGJAwesomeCancelBlock cancelBlock;

@end

@implementation MGJBlockCancelable

@synthesize canceled = _canceled;

- (void)dealloc {
    self.cancelBlock = nil;
}

- (instancetype)initWithBlock:(MGJAwesomeCancelBlock)block {
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
            MGJSafeExecBlock(self.cancelBlock)();
            self.cancelBlock = nil;
            
            self.canceled = YES;
        }
    }
}

@end