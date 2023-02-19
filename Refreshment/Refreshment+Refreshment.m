//
//  Refreshment+Refreshment.m
//  Refreshment
//
//  Created by neutronstarer on 2021/11/2.
//

#import "Refreshment+RefreshmentPrivate.h"
#import "RefreshmentView+RefreshmentPrivate.h"
#import "UIScrollView+RefreshmentPrivate.h"

static void *panStateKey               = &panStateKey;
static void *contentSizeKey            = &contentSizeKey;
static void *contentOffsetKey          = &contentOffsetKey;
static void *boundsKey                 = &boundsKey;
static void *contentInsetKey           = &contentInsetKey;
static void *additionalContentInsetKey = &additionalContentInsetKey;
static void *attributesKey             = &attributesKey;

static inline UIEdgeInsets ceilEdgeInsets(UIEdgeInsets edgeInsets){
    return UIEdgeInsetsMake(ceil(edgeInsets.top), ceil(edgeInsets.left), ceil(edgeInsets.bottom), ceil(edgeInsets.right));
}

typedef NS_ENUM(NSInteger, RefreshmentAdditionalContentInsetAdjustmentReason) {
    RefreshmentAdditionalContentInsetAdjustmentReasonAutomaticallyAdjustsScrollViewInsets = 0b111111111100,
    RefreshmentAdditionalContentInsetAdjustmentReasonAnimation = 0b11111111100,
    RefreshmentAdditionalContentInsetAdjustmentReasonNavigationBarHidden = 0b1111111100,
};

@interface Refreshment()

/// why not weak? fix observer bug below iOS 11.
@property (nonatomic, assign) UIScrollView *scrollView;
@property (nonatomic, assign) UIEdgeInsets contentInset;
@property (nonatomic, assign) UIEdgeInsets additionalContentInset;
@property (nonatomic, assign) BOOL         observed;
@end

@implementation Refreshment

- (instancetype)initWithScrollView:(UIScrollView *)scrollView{
    self = [self init];
    self.scrollView = scrollView;
    return self;
}

- (void)addObservers{
    if (self.observed){
        return;
    }
    [self addObserver:self forKeyPath:@"scrollView.panGestureRecognizer.state" options:NSKeyValueObservingOptionNew context:panStateKey];
    [self addObserver:self forKeyPath:@"scrollView.bounds" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:boundsKey];
    [self addObserver:self forKeyPath:@"scrollView.contentSize" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:contentSizeKey];
    [self addObserver:self forKeyPath:@"scrollView.contentOffset" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:contentOffsetKey];
    [self addObserver:self forKeyPath:@"contentInset" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:contentInsetKey];
    [self addObserver:self forKeyPath:@"additionalContentInset" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:additionalContentInsetKey];
    NSArray *views      = @[@"top", @"left", @"bottom", @"right"];
    NSArray *attributes = @[@"state", @"bounds", @"automatic", @"hidden", @"adjustable"];
    [views enumerateObjectsUsingBlock:^(id  _Nonnull obj0, NSUInteger idx, BOOL * _Nonnull stop) {
        [attributes enumerateObjectsUsingBlock:^(id  _Nonnull obj1, NSUInteger idx, BOOL * _Nonnull stop) {
            [self addObserver:self forKeyPath:[NSString stringWithFormat:@"%@.%@", obj0, obj1] options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:attributesKey];
        }];
    }];
    self.observed = YES;
}

- (void)removeObservers{
    if (!self.observed){
        return;
    }
    if (self.top || self.left || self.bottom || self.right){
        return;
    }
    [self removeObserver:self forKeyPath:@"scrollView.panGestureRecognizer.state" context:panStateKey];
    [self removeObserver:self forKeyPath:@"scrollView.bounds" context:boundsKey];
    [self removeObserver:self forKeyPath:@"scrollView.contentSize" context:contentSizeKey];
    [self removeObserver:self forKeyPath:@"scrollView.contentOffset" context:contentOffsetKey];
    [self removeObserver:self forKeyPath:@"contentInset" context:contentInsetKey];
    [self removeObserver:self forKeyPath:@"additionalContentInset" context:additionalContentInsetKey];
    NSArray *views      = @[@"top", @"left", @"bottom", @"right"];
    NSArray *attributes = @[@"state", @"bounds", @"automatic", @"hidden", @"adjustable"];
    [views enumerateObjectsUsingBlock:^(id  _Nonnull obj0, NSUInteger idx, BOOL * _Nonnull stop) {
        [attributes enumerateObjectsUsingBlock:^(id  _Nonnull obj1, NSUInteger idx, BOOL * _Nonnull stop) {
            [self removeObserver:self forKeyPath:[NSString stringWithFormat:@"%@.%@", obj0, obj1] context:attributesKey];
        }];
    }];
    self.observed = NO;
}

- (void)contentInsetDidChangeTo:(UIEdgeInsets)contentInset{
    if (@available(iOS 11.0, *)) {
        if (!UIEdgeInsetsEqualToEdgeInsets(self.contentInset, contentInset)){
            self.contentInset = contentInset;
        }
        return;
    }
    /// compatible code
    NSArray *callStackSymbols = [NSThread callStackSymbols];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^\\d+\\s+UIKit\\s+.*" options:0 error:nil];
    int flag = 0;
    for (int i = 0, c = MIN((int)callStackSymbols.count, 12); i<c; i++){
        NSString *symbol = callStackSymbols[i];
        flag |= ([regex firstMatchInString:symbol options:0 range:NSMakeRange(0, symbol.length)]?1:0)<<i;
    }
    if (flag == RefreshmentAdditionalContentInsetAdjustmentReasonAutomaticallyAdjustsScrollViewInsets){
        UIEdgeInsets inset                  = self.contentInset;
        UIEdgeInsets additionalContentInset = ceilEdgeInsets(UIEdgeInsetsMake(contentInset.top-inset.top, contentInset.left-inset.left, contentInset.bottom-inset.bottom, contentInset.right-inset.right));
        if (!UIEdgeInsetsEqualToEdgeInsets(self.additionalContentInset, additionalContentInset)){
            self.additionalContentInset = additionalContentInset;
        }
        return;
    }
    if (flag == RefreshmentAdditionalContentInsetAdjustmentReasonAnimation){
        return;
    }
    if (flag == RefreshmentAdditionalContentInsetAdjustmentReasonNavigationBarHidden){
        UIEdgeInsets inset      = self.scrollView.contentInset;
        UIEdgeInsets difference = UIEdgeInsetsMake(contentInset.top-inset.top, contentInset.left-inset.left, contentInset.bottom-inset.bottom, contentInset.right-inset.right);
        if (!UIEdgeInsetsEqualToEdgeInsets(difference, UIEdgeInsetsZero)){
            UIEdgeInsets original               = self.additionalContentInset;
            UIEdgeInsets additionalContentInset = ceilEdgeInsets(UIEdgeInsetsMake(difference.top+original.top, difference.left+original.left, difference.bottom+original.bottom, difference.right+original.right));
            self.additionalContentInset = additionalContentInset;
        }
        return;
    }
    if (!UIEdgeInsetsEqualToEdgeInsets(self.contentInset, contentInset)){
        self.contentInset = contentInset;
    }
}

- (void)adjustedContentInsetDidChange{
    UIScrollView *scrollView = self.scrollView;
    UIEdgeInsets contentInset = scrollView.contentInset;
    UIEdgeInsets adjustedContentInset = scrollView.adjustedContentInset;
    UIEdgeInsets additionalContentInset = ceilEdgeInsets(UIEdgeInsetsMake(adjustedContentInset.top-contentInset.top, adjustedContentInset.left-contentInset.left, adjustedContentInset.bottom-contentInset.bottom, adjustedContentInset.right-contentInset.right));
    if (!UIEdgeInsetsEqualToEdgeInsets(self.additionalContentInset, additionalContentInset)){
        self.additionalContentInset = additionalContentInset;
    }
}

- (void)setTop:(RefreshmentView *)view{
    if (_top == view){
        return;
    }
    UIScrollView *scrollView = self.scrollView;
    if (_top.superview == scrollView){
        [_top removeFromSuperview];
    }
    if (!view){
        [self removeObservers];
        _top = nil;
        return;
    }
    [scrollView addSubview:view];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    _top = view;
    [self addObservers];
}

- (void)setLeft:(RefreshmentView *)view{
    if (_left == view){
        return;
    }
    UIScrollView *scrollView = self.scrollView;
    if (_left.superview == scrollView){
        [_left removeFromSuperview];
    }
    if (!view){
        [self removeObservers];
        _left = nil;
        return;
    }
    [scrollView addSubview:view];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    _left = view;
    [self addObservers];
}

- (void)setBottom:(RefreshmentView *)view{
    if (_bottom == view){
        return;
    }
    UIScrollView *scrollView = self.scrollView;
    if (_bottom.superview == scrollView){
        [_bottom removeFromSuperview];
    }
    if (!view){
        [self removeObservers];
        _bottom = nil;
        return;
    }
    [scrollView addSubview:view];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    _bottom = view;
    [self addObservers];
}

- (void)setRight:(RefreshmentView *)view{
    if (_right == view){
        return;
    }
    UIScrollView *scrollView = self.scrollView;
    if (_right.superview == scrollView){
        [_right removeFromSuperview];
    }
    if (!view){
        [self removeObservers];
        _right = nil;
        return;
    }
    [scrollView addSubview:view];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    _right = view;
    [self addObservers];
}

- (void)relayoutWithContentInset:(UIEdgeInsets)contentInset additionalContentInset:(UIEdgeInsets)additionalContentInset bounds:(CGRect)bounds contentSize:(CGSize)contentSize{
    UIScrollView *scrollView = self.scrollView;
    RefreshmentView *view    = self.top;
    BOOL adjustable          = view.adjustable;
    if (view){
        [view _leading2Leading];
        view._bottom2Top.constant  = -contentInset.top-(adjustable?additionalContentInset.top:0);
        view._width2Width.constant = -contentInset.left-contentInset.right-additionalContentInset.left-additionalContentInset.right;
        [scrollView sendSubviewToBack:view];
    }
    view       = self.left;
    adjustable = view.adjustable;
    if (view){
        [view _top2Top];
        view._trailing2Leading.constant = -contentInset.left -(adjustable?additionalContentInset.left:0);
        view._height2Height.constant    = -contentInset.top-contentInset.bottom-additionalContentInset.top-additionalContentInset.bottom;
        [scrollView sendSubviewToBack:view];
    }
    view       = self.bottom;
    adjustable = view.adjustable;
    if (view){
        [view _leading2Leading];
        view._top2Top.constant     = fmax(contentSize.height, bounds.size.height)+contentInset.bottom+(adjustable?additionalContentInset.bottom:0);
        view._width2Width.constant = -contentInset.left-contentInset.right-additionalContentInset.left-additionalContentInset.right;
        [scrollView sendSubviewToBack:view];
    }
    view       = self.right;
    adjustable = view.adjustable;
    if (view){
        [view _top2Top];
        view._leading2Leading.constant = fmax(contentSize.width, bounds.size.width)+contentInset.right+(adjustable?additionalContentInset.right:0);
        view._height2Height.constant   = -contentInset.top-contentInset.bottom-additionalContentInset.top-additionalContentInset.bottom;
        [scrollView sendSubviewToBack:view];
    }
}

- (void)adjustContentInsetWithContentInset:(UIEdgeInsets)contentInset additionalContentInset:(UIEdgeInsets)additionalContentInset bounds:(CGRect)bounds contentSize:(CGSize)contentSize{
    UIScrollView *scrollView = self.scrollView;
    RefreshmentView *view    = self.top;
    BOOL adjustable          = NO;
    if (view){
        adjustable = view.adjustable;
        view._bottom2Top.constant = -contentInset.top-(adjustable?additionalContentInset.top:0);
        if (!view.hidden && (view.automatic || view.state==RefreshmentStateLoading)){
            contentInset.top += view.bounds.size.height+(adjustable?additionalContentInset.top:0);
        }
    }
    view = self.left;
    if (view){
        adjustable = view.adjustable;
        view._trailing2Leading.constant = -contentInset.left-(adjustable?additionalContentInset.left:0);
        if (!view.hidden && (view.automatic || view.state == RefreshmentStateLoading)){
            contentInset.left += view.bounds.size.width+(adjustable?additionalContentInset.left:0);
        }
    }
    view = self.bottom;
    if (view){
        adjustable = view.adjustable;
        view._top2Top.constant = fmax(contentSize.height, bounds.size.height)+contentInset.bottom +(adjustable?additionalContentInset.bottom:0);
        if (!view.hidden && (view.automatic || view.state == RefreshmentStateLoading)){
            contentInset.bottom += view.bounds.size.height+(adjustable?additionalContentInset.bottom:0);
        }
    }
    view = self.right;
    if (view){
        adjustable = view.adjustable;
        view._leading2Leading.constant = fmax(contentSize.width, bounds.size.width)+contentInset.right+(adjustable?additionalContentInset.right:0);
        if (!view.hidden && (view.automatic || view.state == RefreshmentStateLoading)){
            contentInset.right += view.bounds.size.width+(adjustable?additionalContentInset.right: 0);
        }
    }
    if (@available(iOS 11.0, *)) {
        if (!UIEdgeInsetsEqualToEdgeInsets(scrollView.contentInset, contentInset)){
            [scrollView refreshment_setContentInset:contentInset];
        }
        return;
    }
    contentInset = UIEdgeInsetsMake(contentInset.top+additionalContentInset.top, contentInset.left+additionalContentInset.left, contentInset.bottom+additionalContentInset.bottom, contentInset.right+additionalContentInset.right);
    if (!UIEdgeInsetsEqualToEdgeInsets(scrollView.contentInset, contentInset)){
        [scrollView refreshment_setContentInset:contentInset];
    }
}

- (void)contentOffsetDidChangeTo:(CGPoint)contentOffset{
    UIScrollView *scrollView = self.scrollView;
    void(^tryTrigger)(UIScrollView *scrollView, RefreshmentView *view) = ^( UIScrollView *scrollView, RefreshmentView *view){
        if (view.automatic){
            if (view.visiblePercent >= view.triggerPercent){
                if (view.state == RefreshmentStateIdle){
                    [view begin];
                }
            }
            return;
        }
        if (scrollView.dragging){
            if (view.visiblePercent >= view.triggerPercent){
                if (view.state == RefreshmentStateIdle){
                    view.state = RefreshmentStatePending;
                }
            }else{
                if (view.state == RefreshmentStatePending){
                    view.state = RefreshmentStateIdle;
                }
            }
        }
    };
    UIEdgeInsets contentInset = self.contentInset;
    UIEdgeInsets additionalContentInset = self.additionalContentInset;
    RefreshmentView *view = self.top;
    if (view && !view.hidden){
        CGFloat offset = -(contentOffset.y+contentInset.top+additionalContentInset.top+(view.adjustable?additionalContentInset.top:0));
        view.visiblePercent = offset/view.bounds.size.height;
        tryTrigger(scrollView, view);
    }
    view = self.left;
    if (view && !view.hidden){
        CGFloat offset = -(contentOffset.x+contentInset.left+additionalContentInset.left+(view.adjustable?additionalContentInset.left:0));
        view.visiblePercent = offset/view.bounds.size.width;
        tryTrigger(scrollView, view);
    }
    view = self.bottom;
    if (view && !view.hidden){
        CGFloat offset = contentOffset.y-((fmax(scrollView.contentSize.height, scrollView.bounds.size.height))-scrollView.bounds.size.height)-contentInset.bottom-additionalContentInset.bottom-(view.adjustable?additionalContentInset.bottom:0);
        view.visiblePercent = offset/view.frame.size.height;
        tryTrigger(scrollView, view);
    }
    view = self.right;
    if (view && !view.hidden){
        CGFloat offset = contentOffset.x-((fmax(scrollView.contentSize.width, scrollView.bounds.size.width))-scrollView.bounds.size.width)-contentInset.right-additionalContentInset.right-(view.adjustable?additionalContentInset.right:0);
        view.visiblePercent = offset/view.frame.size.width;
        tryTrigger(scrollView, view);
    }
}

- (void)gestureRecongnizerDidComplete{
    RefreshmentView *view = self.top;
    if (view.state == RefreshmentStatePending){
        [view begin];
    }
    view = self.left;
    if (view.state == RefreshmentStatePending){
        [view begin];
    }
    view = self.bottom;
    if (view.state == RefreshmentStatePending){
        [view begin];
    }
    view = self.right;
    if (view.state == RefreshmentStatePending){
        [view begin];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if (context == panStateKey) {
        switch ([change[NSKeyValueChangeNewKey] integerValue]) {
            case UIGestureRecognizerStateEnded:
            case UIGestureRecognizerStateCancelled:
            case UIGestureRecognizerStateFailed:{
                [self gestureRecongnizerDidComplete];
            } break;
            default: break;
        }
        return;
    }
    id newValue = change[NSKeyValueChangeNewKey];
    if ([change[NSKeyValueChangeOldKey] isEqual:newValue]){
        return;
    }
    if (context == contentOffsetKey){
        [self contentOffsetDidChangeTo:newValue == NSNull.null?CGPointMake(0, 0):[newValue CGPointValue]];
        return;
    }
    if (context == contentSizeKey){
        [self relayoutWithContentInset:self.contentInset additionalContentInset:self.additionalContentInset bounds:self.scrollView.bounds contentSize: newValue == NSNull.null?CGSizeMake(0, 0):[newValue CGSizeValue]];
        return;
    }
    if (context == contentInsetKey){
        UIScrollView *scrollView            = self.scrollView;
        UIEdgeInsets contentInset           = newValue == NSNull.null?UIEdgeInsetsZero:[newValue UIEdgeInsetsValue];
        UIEdgeInsets additionalContentInset = self.additionalContentInset;
        CGRect bounds                       = scrollView.bounds;
        CGSize contentSize                  = scrollView.contentSize;
        [self relayoutWithContentInset:contentInset additionalContentInset:additionalContentInset bounds:bounds contentSize:contentSize];
        [self adjustContentInsetWithContentInset:contentInset additionalContentInset:additionalContentInset bounds:bounds contentSize:contentSize];
        return;
    }
    if (context == additionalContentInsetKey){
        UIScrollView *scrollView            = self.scrollView;
        UIEdgeInsets contentInset           = self.contentInset;
        UIEdgeInsets additionalContentInset = newValue == NSNull.null?UIEdgeInsetsZero:[newValue UIEdgeInsetsValue];
        CGRect bounds                       = scrollView.bounds;
        CGSize contentSize                  = scrollView.contentSize;
        [self relayoutWithContentInset:contentInset additionalContentInset:additionalContentInset bounds:bounds contentSize:contentSize];
        [self adjustContentInsetWithContentInset:contentInset additionalContentInset:additionalContentInset bounds:bounds contentSize:contentSize];
        return;
    }
    if (context == boundsKey){
        [self relayoutWithContentInset:self.contentInset additionalContentInset:self.additionalContentInset bounds:newValue == NSNull.null?CGRectZero:[newValue CGRectValue] contentSize:self.scrollView.contentSize];
        return;
    }
    if (context == attributesKey){
        UIScrollView *scrollView            = self.scrollView;
        UIEdgeInsets contentInset           = self.contentInset;
        UIEdgeInsets additionalContentInset = self.additionalContentInset;
        CGRect bounds                       = scrollView.bounds;
        CGSize contentSize                  = scrollView.contentSize;
        [self relayoutWithContentInset:contentInset additionalContentInset:additionalContentInset bounds:bounds contentSize:contentSize];
        [self adjustContentInsetWithContentInset:contentInset additionalContentInset:additionalContentInset bounds:bounds contentSize:contentSize];
        return;
    }
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

@end

