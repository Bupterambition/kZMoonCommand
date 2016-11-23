//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//___COPYRIGHT___
//

#import "___FILEBASENAME___.h"

@implementation ___FILEBASENAMEASIDENTIFIER___

- (instancetype)init {
    self = [super init];
    if (self) {
        // Setting the excuting queue your code run and do any additional setup
        [self setExecQueue:<#(dispatch_queue_t)#>];
    }
    return self;
}

- (id<kZMoonCancelable>)run:(id<kZMoonResult>)result {
    //Do your main code here,then call [result next:respose] to transfer the reponse , finally you should call [result onComplete]
    
}

@end
