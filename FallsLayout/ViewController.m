//
//  ViewController.m
//  FallsLayout
//
//  Created by jisa on 2021/4/27.
//

#import "ViewController.h"
#import "FFTagCollectionViewFlowLayout.h"
#import "FFSectionImageFlowLayout.h"
#import "FFWaterCollectionViewLayout.h"
#import "Student.h"
#import "Kindergarden.h"
// 随机色
#define RandomColor [UIColor colorWithRed:((arc4random() % 255) >> 16) / 255.0 green:((arc4random() % 255) >> 8) / 255.0 blue:(arc4random() % 255) / 255.0 alpha:1.0]

@interface ViewController ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, FFWaterCollectionViewDelegateLayout>
@property (nonatomic, strong) UICollectionView *aCollectionView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.aCollectionView];
    
//    NSMutableDictionary *marr = [@{} mutableCopy];
//    marr[@"name"] = nil;
//    marr[@"school"] = @"";
//    marr[@"grade"] = @"--";
//    NSLog(@"%@", marr);
//    Student *stu = [[Student alloc] init];
//    stu.name = @"123";
//    stu.age = 123;
//    stu.school = @"学军";
//    Kindergarden *kinder = [[Kindergarden alloc] init];
//    kinder.grade = @"大班";
//    stu.garten = kinder;
//    Student *stu2 = [stu copy];
//    stu2.name = @"789";
//    stu2.age = 789;
//    stu2.school = @"浙大附中";
//    stu2.garten.grade = @"小班";
//    NSLog(@"%@\n, %@", stu, stu2);
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.aCollectionView.frame = CGRectMake(0, 100, self.view.bounds.size.width, 200);
}


#pragma mark -- lazy
- (UICollectionViewLayout *)getDefaultFlowLayout {
//    UICollectionViewFlowLayout *flowLayout = [FFVerticalCollectionViewFlowLayout new];
//    // 上下间距
//    flowLayout.minimumLineSpacing = 10;
//    // 左右间距
//    flowLayout.minimumInteritemSpacing = 10;
//    //
//    flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
//    //
//    flowLayout.itemSize = CGSizeMake(80, 40);
//
//    return flowLayout;
    FFWaterCollectionViewLayout *layout = [[FFWaterCollectionViewLayout alloc] init];
    layout.minimumLineSpacing = 10;
    layout.delegate = self;
    layout.minimumInteritemSpacing = 10;
    layout.itemwidth = 100;
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.column = 3;
    layout.invalidItemSpacing = YES;
    return layout;
}

- (UICollectionView *)aCollectionView {
    if (!_aCollectionView) {
        _aCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[self getDefaultFlowLayout]];
        _aCollectionView.backgroundColor = [UIColor whiteColor];
        [_aCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"reuse"];
        [_aCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
        [_aCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];

        _aCollectionView.layer.borderColor = [UIColor redColor].CGColor;
        _aCollectionView.layer.borderWidth = 1;
        _aCollectionView.layer.cornerRadius = 10;
        _aCollectionView.layer.masksToBounds = YES;
        _aCollectionView.dataSource = self;
        _aCollectionView.delegate = self;
    }
    return _aCollectionView;
}

#pragma mark -- dataSource
- (UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"reuse" forIndexPath:indexPath];
    if (!cell) {
        cell = [[UICollectionViewCell alloc] init];
    }
    cell.backgroundColor = RandomColor;
    return cell;
}


- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 20;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    int temp = 150 + indexPath.row * 5;
//    return CGSizeMake(100, temp);
//}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(FFWaterCollectionViewLayout *)layout
 heightForItemAtIndexPath:(NSIndexPath *)indexPath {
    int temp = 150 + indexPath.row * 5;
    return temp;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(FFWaterCollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(375, 40);
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
//    return CGSizeMake(375, 0);
//}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *vi = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
        if (!vi) {
             vi = [[UICollectionReusableView alloc] initWithFrame:CGRectMake(0, 0, 375, 40)];
        }
        vi.backgroundColor = [UIColor magentaColor];
        return vi;
    } else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
//        UICollectionReusableView *vi = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"footer" forIndexPath:indexPath];
//        if (!vi) {
//            vi = [[UICollectionReusableView alloc] initWithFrame:CGRectMake(0, 0, 375, 40)];
//        }
//        vi.backgroundColor = [UIColor cyanColor];
//        return vi;
        return nil;
    } else {
        return nil;
    }
}

@end
/*
 问题
 Collection, itemSize是固定大小时，布局从左侧开始。itemSize的宽度不一致时，布局会居中展示。
 
 
 */
