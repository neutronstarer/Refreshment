//
//  VerticalLoadmoreView.m
//  Example
//
//  Created by neutronstarer on 2021/10/28.
//

@import Masonry;
@import ReactiveObjC;

#import "VerticalLoadmoreView.h"

@interface VerticalLoadmoreView()

@property (nonatomic, assign) BOOL more;

@end

@implementation VerticalLoadmoreView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    @weakify(self);
    self.backgroundColor = [UIColor redColor];
    self.automatic = YES;
    self.hidden = YES;
    UILabel *label = ({
        UILabel *v                = [[UILabel alloc] init];
        v.backgroundColor         = [UIColor greenColor];
        v.textColor               = [UIColor whiteColor];
        v.font                    = [UIFont systemFontOfSize:16];
        v.textAlignment           = NSTextAlignmentCenter;
        v.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width-28;
        v.numberOfLines = 0;
        [[RACSignal combineLatest:@[RACObserve(self, state), RACObserve(self, visiblePercent)]] subscribeNext:^(RACTuple *x) {
            switch ([[x objectAtIndex:0] integerValue]) {
                case RefreshmentStatePending:
                    v.text = [NSString stringWithFormat:NSLocalizedString(@"Release to load more: %.2f", nil), [[x objectAtIndex:1] doubleValue]];
                    break;
                case RefreshmentStateLoading:
                    v.text = NSLocalizedString(@"Refreshing", nil);
                    break;
                case RefreshmentStateIdle:
                    v.text = [NSString stringWithFormat:NSLocalizedString(@"Pull to load more: %.2f", nil), [[x objectAtIndex:1] doubleValue]];
                    break;
                default:
                    break;
            }
        }];
        v;
    });
    UIView *automaticView = ({
        UIView *v = [[UIView alloc] init];
        UILabel *label = ({
            UILabel *v      = [[UILabel alloc] init];
            v.textColor     = [UIColor whiteColor];
            v.font          = [UIFont systemFontOfSize:12];
            v.textAlignment = NSTextAlignmentCenter;
            v.text          = NSLocalizedString(@"Automatic", nil);
            v;
        });
        UISwitch *swit = ({
            UISwitch *v = [[UISwitch alloc] init];
            v.on = NO;
            [RACObserve(self, automatic) subscribeNext:^(id  _Nullable x) {
                BOOL automatic = [x boolValue];
                if (v.on == automatic){
                    return;
                }
                v.on = automatic;
            }];
            [[v rac_newOnChannel] subscribeNext:^(NSNumber * _Nullable x) {
                @strongify(self);
                self.automatic = [x boolValue];
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
    [self addSubview:automaticView];
    [self addSubview:adjustableView];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.lessThanOrEqualTo(self).sizeOffset(CGSizeMake(-8, -8));
    }];
    [automaticView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(8);
        make.bottom.equalTo(self).offset(-8);
        make.leading.equalTo(self).offset(8);
    }];
    [adjustableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(8);
        make.bottom.equalTo(self).offset(-8);
        make.trailing.equalTo(self).offset(-8);
    }];
    return self;
}

- (void)begin{
    if (!self.more){
        return;
    }
    [UIView animateWithDuration:UINavigationControllerHideShowBarDuration delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        [super begin];
    } completion:nil];

}

- (void)end:(BOOL)more{
    self.hidden = false;
    self.more = more;
//    [UIView animateWithDuration:UINavigationControllerHideShowBarDuration delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        [super end];
//    } completion:nil];

}

@end
