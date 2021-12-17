//
//  ReverseViewController.m
//  Example
//
//  Created by neutronstarer on 2021/10/28.
//

@import Masonry;
@import ReactiveObjC;

#import "NSString+Category.h"
#import "VerticalCollectionViewCell.h"
#import "VerticalLoadmoreView.h"
#import "VerticalRefreshView.h"
#import "VerticalReverseViewController.h"

@interface VerticalReverseViewController ()

@property (nonatomic, strong) NSMutableArray *models;

@end

@implementation VerticalReverseViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    @weakify(self);
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:VerticalCollectionViewCell.class forCellWithReuseIdentifier:@"CollectionViewCell"];
    self.collectionView.rf.top = ({
        VerticalRefreshView *v = [[VerticalRefreshView alloc] init];
        v.automatic = YES;
        v.trigger = ^(VerticalRefreshView * _Nonnull view) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                @strongify(self);
                UICollectionView *scrollView = (UICollectionView*)view.superview;
                NSMutableArray *indexPaths = [NSMutableArray array];
                for (int i=0; i<20; i++){
                    [self.models insertObject:[NSString randomString] atIndex:0];
                    [indexPaths addObject:[NSIndexPath indexPathForItem:i inSection:0]];
                }
                CGFloat bottomOffset = scrollView.contentSize.height - scrollView.contentOffset.y;
                if (@available(iOS 11.0, *)) {
                    bottomOffset = fmax(scrollView.bounds.size.height-scrollView.adjustedContentInset.bottom, bottomOffset);
                } else {
                    bottomOffset = fmax(scrollView.bounds.size.height-scrollView.contentInset.bottom, bottomOffset);
                }
                [CATransaction begin];
                [CATransaction setDisableActions:YES];
                [scrollView performBatchUpdates:^{
                    [scrollView insertItemsAtIndexPaths:indexPaths];
                } completion:^(BOOL finished) {
                    scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, scrollView.contentSize.height - bottomOffset);
                    [CATransaction commit];
                }];
                [view end];
            });
        };
        [RACObserve(self.navigationController.navigationBar, hidden) subscribeNext:^(id  _Nullable x) {
            BOOL hidden = [x boolValue];
            if (v.navigationBarHidden == hidden){
                return;
            }
            v.navigationBarHidden = hidden;
        }];
        [RACObserve(v, navigationBarHidden) subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            [self.navigationController setNavigationBarHidden:[x boolValue] animated:YES];
        }];
        v;
    });
    [self.collectionView.rf.top begin];
    // Do any additional setup after loading the view.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.models.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    VerticalCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];
    cell.label.text = self.models[indexPath.item];
    return cell;
}

- (NSMutableArray*)models{
    if (_models) return _models;
    _models = [NSMutableArray array];
    return _models;
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
