//
//  HorizontalCollectionViewCell.m
//  Example
//
//  Created by neutronstarer on 2021/10/28.
//

@import Masonry;

#import "HorizontalCollectionViewCell.h"

@interface HorizontalCollectionViewCell()

@property (nonatomic, strong) UILabel *label;

@end

@implementation HorizontalCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.contentView.layer.borderWidth = 1.0/UIScreen.mainScreen.scale;
    self.contentView.layer.borderColor = [UIColor colorWithWhite:191/255.0 alpha:1].CGColor;
    self.label = ({
        UILabel *v      = [[UILabel alloc] init];
        v.font          = [UIFont systemFontOfSize:18];
        v.textColor     = [UIColor blackColor];
        v.numberOfLines = 0;
        v.textAlignment = NSTextAlignmentCenter;
        v;
    });
    [self.contentView addSubview:self.label];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(14, 14, 14, 14));
    }];
    return self;
}

@end
