//
//  FFTagCollectionViewFlowLayout.h
//  FallsLayout
//
//  Created by jisa on 2021/4/27.
//  标签类型流式布局, 只支持水平方向流式布局

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 定义方向（Tag布局对齐方向）枚举
typedef NS_ENUM(NSInteger, FFTagCollectionViewFlowLayoutDirectionType) {
    //左对齐
    FFTagCollectionViewFlowLayoutDirectionTypeLeft = 1,
    //居中对齐
    FFTagCollectionViewFlowLayoutDirectionTypeCenter,
    //右对齐
    FFTagCollectionViewFlowLayoutDirectionTypeRight
};

@interface FFTagCollectionViewFlowLayout : UICollectionViewFlowLayout
/// 布局对齐方向
@property(nonatomic, assign) FFTagCollectionViewFlowLayoutDirectionType directionType;
@end

NS_ASSUME_NONNULL_END
