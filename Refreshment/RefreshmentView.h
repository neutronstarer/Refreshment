//
//  RefreshmentView.h
//  Refreshment
//
//  Created by neutronstarer on 2021/10/28.
//

@import UIKit;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, RefreshmentState) {
    RefreshmentStateIdle,
    RefreshmentStatePending,
    RefreshmentStateLoading,
};

@interface RefreshmentView : UIView

/// state
@property (nonatomic, assign          ) RefreshmentState state;
/// Trigger automatically without user interaction
@property (nonatomic, assign          ) BOOL             automatic;
/// Adjust view postion when scroll view be adjusted by safe area.
@property (nonatomic, assign          ) BOOL             adjustable;
/// Trigger percent. default 1, means trigger when view displayed fully (visibleAreaPercent=1).
@property (nonatomic, assign          ) CGFloat          triggerPercent;
/// visible percent of view, when visiblePercent >=triggerPercent, state may be changed to RefreshmentStatePending or RefreshmentStateLoading when automatic is true.
@property (nonatomic, assign, readonly) CGFloat          visiblePercent;
/// trigger block
@property (nonatomic, copy, nullable  ) void(^trigger)(__kindof RefreshmentView *view);

/// begin
- (void)begin;

/// end
- (void)end;

@end

NS_ASSUME_NONNULL_END
