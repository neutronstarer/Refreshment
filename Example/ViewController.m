//
//  ViewController.m
//  Example
//
//  Created by neutronstarer on 2021/10/28.
//

@import Masonry;
@import ReactiveObjC;

#import "Example-Swift.h"
#import "HorizontalObverseViewController.h"
#import "HorizontalReverseViewController.h"
#import "VerticalCollectionViewCell.h"
#import "VerticalObverseViewController.h"
#import "VerticalReverseViewController.h"
#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) NSArray *models;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    @weakify(self);
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:VerticalCollectionViewCell.class forCellWithReuseIdentifier:@"CollectionViewCell"];
    self.models = @[
        @{
            @"text": @"Vertical obverse",
            @"block":^{
                @strongify(self);
                [self.navigationController pushViewController:[[VerticalObverseViewController alloc] initWithCollectionViewLayout:({
                    UICollectionViewFlowLayout *v = [[UICollectionViewFlowLayout alloc] init];
                    v.minimumLineSpacing          = 0;
                    v.minimumInteritemSpacing     = 0;
                    v.sectionInset                = UIEdgeInsetsZero;
                    v.estimatedItemSize           = CGSizeMake([UIScreen mainScreen].bounds.size.width, 50);
                    v;
                })] animated:YES];
            },
        },
        @{
            @"text": @"Vertical reverse",
            @"block":^{
                @strongify(self);
                [self.navigationController pushViewController:[[VerticalReverseViewController alloc] initWithCollectionViewLayout:({
                    UICollectionViewFlowLayout *v = [[UICollectionViewFlowLayout alloc] init];
                    v.minimumLineSpacing          = 0;
                    v.minimumInteritemSpacing     = 0;
                    v.sectionInset                = UIEdgeInsetsZero;
                    v.estimatedItemSize           = CGSizeMake([UIScreen mainScreen].bounds.size.width, 50);
                    v;
                })] animated:YES];
            },
        },
        @{
            @"text": @"Horizontal obverse",
            @"block":^{
                @strongify(self);
                [self.navigationController pushViewController:[[HorizontalObverseViewController alloc] initWithCollectionViewLayout:({
                    UICollectionViewFlowLayout *v = [[UICollectionViewFlowLayout alloc] init];
                    v.scrollDirection             = UICollectionViewScrollDirectionHorizontal;
                    v.minimumLineSpacing          = 0;
                    v.minimumInteritemSpacing     = 0;
                    v.sectionInset                = UIEdgeInsetsZero;
                    v;
                })] animated:YES];
            },
        },
        @{
            @"text": @"Horizontal reverse",
            @"block":^{
                @strongify(self);
                [self.navigationController pushViewController:[[HorizontalReverseViewController alloc] initWithCollectionViewLayout:({
                    UICollectionViewFlowLayout *v = [[UICollectionViewFlowLayout alloc] init];
                    v.scrollDirection             = UICollectionViewScrollDirectionHorizontal;
                    v.minimumLineSpacing          = 0;
                    v.minimumInteritemSpacing     = 0;
                    v.sectionInset                = UIEdgeInsetsZero;
                    v;
                })] animated:YES];
            },
        },
        @{
            @"text": @"Vertical obverse tableView",
            @"block":^{
                @strongify(self);
                [self.navigationController pushViewController:[[ObverseTableViewController alloc] init] animated:YES];
            },
        },
        @{
            @"text": @"Vertical reverse tableView",
            @"block":^{
                @strongify(self);
                [self.navigationController pushViewController:[[ReverseTableViewController alloc] init] animated:YES];
            },
        },
    ];
    // Do any additional setup after loading the view.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.models.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    VerticalCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];
    cell.label.text = self.models[indexPath.item][@"text"];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    void(^block)(void) = self.models[indexPath.item][@"block"];
    block();
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
