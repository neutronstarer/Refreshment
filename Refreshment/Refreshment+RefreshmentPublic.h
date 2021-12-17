//
//  Refreshment+RefreshmentPublic.h
//  Refreshment
//
//  Created by neutronstarer on 2021/12/18.
//

#import "RefreshmentView.h"

NS_ASSUME_NONNULL_BEGIN

@interface Refreshment: NSObject

@property (nonatomic, strong, nullable) RefreshmentView *top;
@property (nonatomic, strong, nullable) RefreshmentView *left;
@property (nonatomic, strong, nullable) RefreshmentView *bottom;
@property (nonatomic, strong, nullable) RefreshmentView *right;

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
