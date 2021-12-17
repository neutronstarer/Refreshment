//
//  HorizontalRefreshView.m
//  Example
//
//  Created by neutronstarer on 2021/10/28.
//

@import AudioToolbox;
@import Masonry;
@import ReactiveObjC;

#import "HorizontalRefreshView.h"

@interface HorizontalRefreshView()

@end

@implementation HorizontalRefreshView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    @weakify(self);
    self.backgroundColor = [UIColor redColor];
    UILabel *label = ({
        UILabel *v        = [[UILabel alloc] init];
        v.backgroundColor = [UIColor greenColor];
        v.textColor       = [UIColor whiteColor];
        v.font            = [UIFont systemFontOfSize:16];
        v.textAlignment   = NSTextAlignmentCenter;
        v.numberOfLines = 0;
        [[RACSignal combineLatest:@[RACObserve(self, state), RACObserve(self, visiblePercent)]] subscribeNext:^(RACTuple *x) {
            switch ([[x objectAtIndex:0] integerValue]) {
                case RefreshmentStatePending:
                    v.text = [NSString stringWithFormat:NSLocalizedString(@"Release to refresh: %.2f", nil), [[x objectAtIndex:1] doubleValue]];
                    break;
                case RefreshmentStateLoading:
                    v.text = NSLocalizedString(@"Refreshing", nil);
                    break;
                case RefreshmentStateIdle:
                    v.text = [NSString stringWithFormat:NSLocalizedString(@"Pull to refresh: %.2f", nil), [[x objectAtIndex:1] doubleValue]];
                    break;
                default:
                    break;
            }
        }];
        v;
    });
    UIView *navigationBarHiddenView = ({
        UIView *v = [[UIView alloc] init];
        UILabel *label = ({
            UILabel *v      = [[UILabel alloc] init];
            v.textColor     = [UIColor whiteColor];
            v.font          = [UIFont systemFontOfSize:12];
            v.textAlignment = NSTextAlignmentCenter;
            v.text          = NSLocalizedString(@"Nav hidden", nil);
            v;
        });
        UISwitch *swit = ({
            UISwitch *v = [[UISwitch alloc] init];
            v.on = NO;
            [RACObserve(self, navigationBarHidden) subscribeNext:^(id  _Nullable x) {
                BOOL navigationBarHidden = [x boolValue];
                if (v.on == navigationBarHidden){
                    return;
                }
                v.on = navigationBarHidden;
            }];
            [[v rac_newOnChannel] subscribeNext:^(NSNumber * _Nullable x) {
                @strongify(self);
                self.navigationBarHidden = [x boolValue];
            }];
            v;
        });
        [v addSubview:label];
        [v addSubview:swit];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(v).offset(8);
            make.leading.equalTo(v).offset(8);
            make.trailing.equalTo(v).offset(-8);
        }];
        [swit mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label.mas_bottom).offset(8);
            make.bottom.equalTo(v).offset(-8);
            make.leading.greaterThanOrEqualTo(v).offset(8);
            make.trailing.lessThanOrEqualTo(v).offset(-8);
            make.centerX.equalTo(v);
        }];
        v;
    });
    
    UIView *adjustableView = ({
        UIView *v = [[UIView alloc] init];
        UILabel *label = ({
            UILabel *v      = [[UILabel alloc] init];
            v.textColor     = [UIColor whiteColor];
            v.font          = [UIFont systemFontOfSize:12];
            v.textAlignment = NSTextAlignmentCenter;
            v.text          = NSLocalizedString(@"Adjustable", nil);
            v;
        });
        UISwitch *swit = ({
            UISwitch *v = [[UISwitch alloc] init];
            [RACObserve(self, adjustable) subscribeNext:^(id  _Nullable x) {
                BOOL adjustable = [x boolValue];
                if (v.on == adjustable){
                    return;
                }
                v.on = adjustable;
            }];
            [[v rac_newOnChannel] subscribeNext:^(NSNumber * _Nullable x) {
                @strongify(self);
                self.adjustable = [x boolValue];
            }];
            v;
        });
        [v addSubview:label];
        [v addSubview:swit];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(v).offset(8);
            make.leading.equalTo(v).offset(8);
            make.trailing.equalTo(v).offset(-8);
        }];
        [swit mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label.mas_bottom).offset(8);
            make.bottom.equalTo(v).offset(-8);
            make.leading.greaterThanOrEqualTo(v).offset(8);
            make.trailing.lessThanOrEqualTo(v).offset(-8);
            make.centerX.equalTo(v);
        }];
        v;
    });
    [self addSubview:label];
    [self addSubview:navigationBarHiddenView];
    [self addSubview:adjustableView];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.mas_equalTo(88);
        make.width.equalTo(self).offset(-8*2);
    }];
    [navigationBarHiddenView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(8);
        make.leading.greaterThanOrEqualTo(self).offset(8);
        make.trailing.lessThanOrEqualTo(self).offset(-8);
    }];
    [adjustableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(-8);
        make.leading.greaterThanOrEqualTo(self).offset(8);
        make.trailing.lessThanOrEqualTo(self).offset(-8);
    }];
    [RACObserve(self, state) subscribeNext:^(id  _Nullable x) {
        if ([x integerValue] == RefreshmentStatePending){
            AudioServicesPlaySystemSound(1519);
        }
    }];
    return self;
}

- (void)begin{
    [UIView animateWithDuration:UINavigationControllerHideShowBarDuration delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        [super begin];
    } completion:nil];
    
}

- (void)end{
    [UIView animateWithDuration:UINavigationControllerHideShowBarDuration delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        [super end];
    } completion:nil];
    
}

@end
