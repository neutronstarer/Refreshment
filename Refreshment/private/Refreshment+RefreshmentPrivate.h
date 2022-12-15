//
//  Refreshment+RefreshmentPrivate.h
//  Refreshment
//
//  Created by neutronstarer on 2021/11/2.
//

@import UIKit;

#import "Refreshment+Refreshment.h"

NS_ASSUME_NONNULL_BEGIN

@interface Refreshment (RefreshmentPrivate)

- (instancetype)initWithScrollView:(UIScrollView*)scrollView;

- (void)contentInsetDidChangeTo:(UIEdgeInsets)contentInset;

- (void)adjustedContentInsetDidChange API_AVAILABLE(ios(11.0));

- (void)removeObservers;

@end

NS_ASSUME_NONNULL_END
