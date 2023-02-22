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
 
/// Current state.
@property (nonatomic, assign          ) RefreshmentState state;
/// Trigger automatically when `visiblePercent` equal to `triggerPercent` without user interaction.
@property (nonatomic, assign          ) BOOL             automatic;
/// Adjust view postion when scroll view content is adjusted by safe area.
@property (nonatomic, assign          ) BOOL             adjustable;
/// Trigger percent. default 1.0, means trigger if view displayed fully (`visiblePercent` = 1).
@property (nonatomic, assign          ) CGFloat          triggerPercent;
/// Visible percent of view, state may be changed to `RefreshmentStatePending` when visiblePercent >=triggerPercent, or `RefreshmentStateLoading` when automatic is true.
@property (nonatomic, assign, readonly) CGFloat          visiblePercent;
/// Trigger block.
@property (nonatomic, copy, nullable  ) void(^trigger)(__kindof RefreshmentView *view);

/// Begin refreshing. State should be change to `RefreshmentStateLoading`, and trigger works.
- (void)begin;

/// End refreshing. State should be change to `RefreshmentStateIdle`.
- (void)end;

/// scroll to display.
- (void)display:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
