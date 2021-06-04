//
//  FFWaterCollectionViewLayout.h
//  FallsLayout
//
//  Created by jisa on 2021/5/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class FFWaterCollectionViewLayout;
@protocol FFWaterCollectionViewDelegateLayout <NSObject>

@required
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(FFWaterCollectionViewLayout *)layout
 heightForItemAtIndexPath:(NSIndexPath *)indexPath;

@optional
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(FFWaterCollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section;
@end

@interface FFWaterCollectionViewLayout : UICollectionViewLayout
/// 列
@property (nonatomic) NSInteger column;
/// item宽度
@property (nonatomic) CGFloat   itemwidth;
/// item 最小列间隔
@property (nonatomic) CGFloat minimumLineSpacing;
/// item 最小行间隔
@property (nonatomic) CGFloat minimumInteritemSpacing;
/// 设定的间隔无效，各间隔平均分配，默认为NO;
@property (nonatomic) BOOL invalidItemSpacing;
/// section header 尺寸
@property (nonatomic) CGSize headerReferenceSize;
/// section footer 尺寸
@property (nonatomic) CGSize footerReferenceSize;
/// 设置section的缩进信息
@property (nonatomic) UIEdgeInsets sectionInset;
/// 代理
@property (nonatomic, weak) id<FFWaterCollectionViewDelegateLayout> delegate;
@end

NS_ASSUME_NONNULL_END
