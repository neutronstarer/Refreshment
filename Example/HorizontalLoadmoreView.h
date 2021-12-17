//
//  HorizontalLoadmoreView.h
//  Example
//
//  Created by neutronstarer on 2021/10/28.
//

#import <Refreshment/Refreshment.h>

NS_ASSUME_NONNULL_BEGIN

@interface HorizontalLoadmoreView : RefreshmentView

- (void)end NS_UNAVAILABLE;
- (void)end:(BOOL)more;

@end

NS_ASSUME_NONNULL_END
