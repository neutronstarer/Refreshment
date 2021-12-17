//
//  HorizontalObverseViewController.m
//  Example
//
//  Created by neutronstarer on 2021/10/28.
//

@import Masonry;
@import ReactiveObjC;

#import "HorizontalCollectionViewCell.h"
#import "HorizontalLoadmoreView.h"
#import "HorizontalObverseViewController.h"
#import "HorizontalRefreshView.h"
#import "NSString+Category.h"

@interface HorizontalObverseViewController ()

@property (nonatomic, strong) NSMutableArray *models;

@end

@implementation HorizontalObverseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    @weakify(self);
    self.collectionView.alwaysBounceHorizontal = YES;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:HorizontalCollectionViewCell.class forCellWithReuseIdentifier:@"CollectionViewCell"];
    self.collectionView.rf.left = ({
        HorizontalRefreshView *v = [[HorizontalRefreshView alloc] init];
        v.trigger = ^(HorizontalRefreshView * _Nonnull view) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                @strongify(self);
                UICollectionView *scrollView = (UICollectionView*)view.superview;
                [self.models removeAllObjects];
                for (int i=0; i<20; i++){
                    [self.models addObject:[NSString randomString]];
                }
                [scrollView reloadData];
                /// fix crash below iOS 11
                [scrollView.collectionViewLayout invalidateLayout];
                [view end];
                [(HorizontalLoadmoreView*)scrollView.rf.right end:YES];
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
    self.collectionView.rf.right = ({
        HorizontalLoadmoreView *v = [[HorizontalLoadmoreView alloc] init];
        v.trigger = ^(HorizontalLoadmoreView * _Nonnull view) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                @strongify(self);
                UICollectionView *scrollView = (UICollectionView*)view.superview;
                NSMutableArray *indexPaths = [NSMutableArray array];
                NSInteger count = self.models.count;
                for (int i=0; i<20; i++){
                    [self.models addObject:[NSString randomString]];
                    [indexPaths addObject:[NSIndexPath indexPathForItem:count+i inSection:0]];
                }
                [scrollView performBatchUpdates:^{
                    [scrollView insertItemsAtIndexPaths:indexPaths];
                } completion:^(BOOL finished) {
                    [view end:YES];
                }];
            });
        };
        v;
    });
    [self.collectionView.rf.left begin];
    // Do any additional setup after loading the view.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.models.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HorizontalCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];
    cell.label.text = self.models[indexPath.item];
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (@available(iOS 11.0, *)) {
        return CGSizeMake(200, collectionView.bounds.size.height-collectionView.adjustedContentInset.top-collectionView.adjustedContentInset.bottom);
    } else {
        return CGSizeMake(200, collectionView.bounds.size.height-collectionView.contentInset.top-collectionView.contentInset.bottom);
    }
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
