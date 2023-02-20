//
//  RefreshmentView+RefreshmentPrivate.h
//  Refreshment
//
//  Created by neutronstarer on 2021/10/28.
//

#import "RefreshmentView.h"

NS_ASSUME_NONNULL_BEGIN

@interface RefreshmentView(RefreshmentPrivate)

@property (nonatomic, assign) CGFloat            visiblePercent;
@property (nonatomic, weak  ) NSLayoutConstraint *_bottom2Top;
@property (nonatomic, weak  ) NSLayoutConstraint *_trailing2Leading;
@property (nonatomic, weak  ) NSLayoutConstraint *_leading2Leading;
@property (nonatomic, weak  ) NSLayoutConstraint *_top2Top;
@property (nonatomic, weak  ) NSLayoutConstraint *_width2Width;
@property (nonatomic, weak  ) NSLayoutConstraint *_height2Height;
@property (nonatomic, copy  ) void(^onDisplay)(BOOL);

@end

NS_ASSUME_NONNULL_END
