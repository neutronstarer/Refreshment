//
//  UIScrollView+RefreshmentPublic.m
//  Refreshment
//
//  Created by neutronstarer on 2021/10/28.
//

#import <objc/runtime.h>

#import "Refreshment+RefreshmentPublic.h"
#import "Refreshment+RefreshmentPrivate.h"
#import "UIScrollView+RefreshmentPrivate.h"

@implementation UIScrollView (RefreshmentPublic)

- (Refreshment *)rf{
    Refreshment *v = objc_getAssociatedObject(self, @selector(rf));
    if (v){
        return v;
    }
    v = [[Refreshment alloc] initWithScrollView:self];
    objc_setAssociatedObject(self, @selector(rf), v, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return v;
}

- (void)refreshment_setContentInset:(UIEdgeInsets)contentInset{
    [self.rf contentInsetDidChangeTo:contentInset];
    [self refreshment_setContentInset:contentInset];
}

- (void)refreshment_adjustedContentInsetDidChange API_AVAILABLE(ios(11.0)){
    [self.rf adjustedContentInsetDidChange];
    [self refreshment_adjustedContentInsetDidChange];
}

/// fix observer bug below iOS 11.0.
- (void)refreshment_dealloc{
    [self.rf removeObservers];
    [self refreshment_dealloc];
}

+ (void)load{
    [self refreshment_swizzleOriginalSelector:@selector(setContentInset:) alteredSelector:@selector(refreshment_setContentInset:)];
    [self refreshment_swizzleOriginalSelector:NSSelectorFromString([NSString stringWithFormat:@"%@%@",@"dea", @"lloc"]) alteredSelector:@selector(refreshment_dealloc)];
    if (@available(iOS 11.0, *)) {
        [self refreshment_swizzleOriginalSelector:@selector(adjustedContentInsetDidChange) alteredSelector:@selector(refreshment_adjustedContentInsetDidChange)];
    }
}

+ (void)refreshment_swizzleOriginalSelector:(SEL)originalSelector alteredSelector:(SEL)alteredSelector{
    Method originalMethod = class_getInstanceMethod(self, originalSelector);
    Method alteredMethod = class_getInstanceMethod(self, alteredSelector);
    class_addMethod(self, originalSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    class_addMethod(self, alteredSelector, method_getImplementation(alteredMethod), method_getTypeEncoding(alteredMethod));
    method_exchangeImplementations(originalMethod, alteredMethod);
}

@end
