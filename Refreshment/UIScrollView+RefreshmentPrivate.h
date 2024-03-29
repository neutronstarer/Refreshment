//
//  UIScrollView+RefreshmentPrivate.h
//  Refreshment
//
//  Created by neutronstarer on 2021/10/28.
//

@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (RefreshmentPrivate)

- (void)refreshment_setContentInset:(UIEdgeInsets)contentInset;
- (void)refreshment_setContentSize:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
