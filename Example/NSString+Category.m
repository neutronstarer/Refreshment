//
//  NSString+Category.m
//  Example
//
//  Created by neutronstarer on 2021/10/28.
//

#import "NSString+Category.h"

@implementation NSString (Category)

+ (instancetype)randomString{
    static NSString *text = @"Invalid update: invalid number of items in section 0. The number of items contained in an existing section after the update (7) must be equal to the number of items contained in that section before the update (100), plus or minus the number of items inserted or deleted from that section (0 inserted, 0 deleted) and plus or minus the number of items moved into or out of that section (0 moved in, 0 moved out).The right way to handle this is to calculate the insertions, deletions, and moves whenever the data source changes and to use performBatchUpdates around them when it does. For example, if two items are added to the end of an array which is the data source, this would be the code:";
    NSString * s = [text substringFromIndex:arc4random()%text.length];
    s = [s substringToIndex:arc4random()%s.length];
    return s;
}
@end
