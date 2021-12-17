//
//  VerticalCollectionViewCell.m
//  Example
//
//  Created by neutronstarer on 2021/10/28.
//

@import Masonry;

#import "VerticalCollectionViewCell.h"

@interface VerticalCollectionViewCell()

@property (nonatomic, strong) UILabel *label;

@end

@implementation VerticalCollectionViewCell

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
        make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width-28);
        make.center.equalTo(self.contentView);
        make.height.equalTo(self.contentView).offset(-28);
        make.width.equalTo(self.contentView).offset(-27).priorityLow();
    }];
    return self;
}

@end
