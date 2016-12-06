//
//  UIButton+Touch.m
//  Operator
//
//  Created by hai on 16/10/26.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "UIButton+Touch.h"

#import <objc/runtime.h>
static NSTimeInterval defaultInterval = 0.5;
@interface UIButton()
@property (nonatomic, assign) BOOL isIgnoreEvent;
@end
@implementation UIButton (touch)
+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL selA = @selector(sendAction:to:forEvent:);
        SEL selB = @selector(mySendAction:to:forEvent:);
        Method methodA =   class_getInstanceMethod(self,selA);
        Method methodB = class_getInstanceMethod(self, selB);
        BOOL isAdd = class_addMethod(self, selA, method_getImplementation(methodB), method_getTypeEncoding(methodB));
        if (isAdd) {
            class_replaceMethod(self, selB, method_getImplementation(methodA), method_getTypeEncoding(methodA));
        }else{
            method_exchangeImplementations(methodA, methodB);
        }
    });
}
- (NSTimeInterval)timeInterval
{
    return [objc_getAssociatedObject(self, _cmd) doubleValue];
}
- (void)setTimeInterval:(NSTimeInterval)timeInterval
{
    objc_setAssociatedObject(self, @selector(timeInterval), @(timeInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}
- (void)mySendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event
{
    if ([NSStringFromClass(self.class) isEqualToString:@"UIButton"]) {
        self.timeInterval =self.timeInterval ==0 ?defaultInterval:self.timeInterval;
        if (self.isIgnoreEvent){
            return;
        }else if (self.timeInterval > 0){
            [self performSelector:@selector(resetState) withObject:nil afterDelay:self.timeInterval];
        }
    }
    self.isIgnoreEvent = YES;
    [self mySendAction:action to:target forEvent:event];
}
- (void)setIsIgnoreEvent:(BOOL)isIgnoreEvent
{
    
    objc_setAssociatedObject(self, @selector(isIgnoreEvent), @(isIgnoreEvent), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)isIgnoreEvent
{
    
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}
- (void)resetState
{
    [self setIsIgnoreEvent:NO];
}
@end
