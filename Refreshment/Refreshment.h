//
//  Refreshment.h
//  Refreshment
//
//  Created by neutronstarer on 2021/10/28.
//

@import UIKit;

//! Project version number for Refreshment.
FOUNDATION_EXPORT double RefreshmentVersionNumber;

//! Project version string for Refreshment.
FOUNDATION_EXPORT const unsigned char RefreshmentVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <Refreshment/PublicHeader.h>
#import <Refreshment/RefreshmentView.h>
#import <Refreshment/UIScrollView+Refreshment.h>

NS_ASSUME_NONNULL_BEGIN

@interface Refreshment: NSObject

@property (nonatomic, strong, nullable) RefreshmentView *top;
@property (nonatomic, strong, nullable) RefreshmentView *left;
@property (nonatomic, strong, nullable) RefreshmentView *bottom;
@property (nonatomic, strong, nullable) RefreshmentView *right;

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END


