//
//  RefreshmentView+RefreshmentPrivate.m
//  Refreshment
//
//  Created by neutronstarer on 2021/11/2.
//

#import "Refreshment+Refreshment.h"
#import "RefreshmentView+RefreshmentPrivate.h"

@interface RefreshmentView()

@property (nonatomic, assign) CGFloat            visiblePercent;
@property (nonatomic, weak  ) NSLayoutConstraint *_bottom2Top;
@property (nonatomic, weak  ) NSLayoutConstraint *_trailing2Leading;
@property (nonatomic, weak  ) NSLayoutConstraint *_leading2Leading;
@property (nonatomic, weak  ) NSLayoutConstraint *_top2Top;
@property (nonatomic, weak  ) NSLayoutConstraint *_width2Width;
@property (nonatomic, weak  ) NSLayoutConstraint *_height2Height;

@end

@implementation RefreshmentView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.triggerPercent = 1.0;
    return self;
}

- (NSLayoutConstraint *)_bottom2Top{
    if (!__bottom2Top || __bottom2Top.secondItem != self.superview){
        NSLayoutConstraint *v = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeTop multiplier:1 constant:0];
        [self.superview addConstraint:v];
        __bottom2Top = v;
    }
    return __bottom2Top;
}

- (NSLayoutConstraint *)_trailing2Leading{
    if (!__trailing2Leading || __trailing2Leading.secondItem != self.superview){
        NSLayoutConstraint *v = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
        [self.superview addConstraint:v];
        __trailing2Leading = v;
    }
    return __trailing2Leading;
}

- (NSLayoutConstraint *)_leading2Leading{
    if (!__leading2Leading || __leading2Leading.secondItem != self.superview){
        NSLayoutConstraint *v = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
        [self.superview addConstraint:v];
        __leading2Leading = v;
    }
    return __leading2Leading;
}

- (NSLayoutConstraint *)_top2Top{
    if (!__top2Top || __top2Top.secondItem != self.superview){
        NSLayoutConstraint *v = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeTop multiplier:1 constant:0];
        [self.superview addConstraint:v];
        __top2Top = v;
    }
    return __top2Top;
}

- (NSLayoutConstraint *)_width2Width{
    if (!__width2Width || __width2Width.secondItem != self.superview){
        NSLayoutConstraint *v = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
        [self.superview addConstraint:v];
        __width2Width = v;
    }
    return __width2Width;
}

- (NSLayoutConstraint *)_height2Height{
    if (!__height2Height || __height2Height.secondItem != self.superview){
        NSLayoutConstraint *v = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeHeight multiplier:1 constant:0];
        [self.superview addConstraint:v];
        __height2Height = v;
    }
    return __height2Height;
}

- (void)begin{
    self.state = RefreshmentStateLoading;
    if(!self.trigger) {
        return;
    }
    self.trigger(self);
}

- (void)end{
    self.state = RefreshmentStateIdle;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
