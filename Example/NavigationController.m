//
//  NavigationController.m
//  Example
//
//  Created by neutronstarer on 2021/10/28.
//


#import "NavigationController.h"
#import "ViewController.h"

@interface NavigationController ()


@end

@implementation NavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewControllers = @[[[ViewController alloc] initWithCollectionViewLayout:({
        UICollectionViewFlowLayout *v = [[UICollectionViewFlowLayout alloc] init];
        v.minimumLineSpacing = 0;
        v.minimumInteritemSpacing = 0;
        v.estimatedItemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 50);
        v;
    })]];
    // Do any additional setup after loading the view.
}


@end
