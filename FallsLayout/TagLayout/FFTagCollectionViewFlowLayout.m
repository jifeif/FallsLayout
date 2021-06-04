//
//  FFTagCollectionViewFlowLayout.m
//  FallsLayout
//
//  Created by jisa on 2021/4/27.
//

#import "FFTagCollectionViewFlowLayout.h"

@implementation FFTagCollectionViewFlowLayout

- (void)prepareLayout {
    [super prepareLayout];
    self.directionType = FFTagCollectionViewFlowLayoutDirectionTypeRight;
}

- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSArray *dataArr = [super layoutAttributesForElementsInRect:rect];
    
    for (UICollectionViewLayoutAttributes *attributes in dataArr) {
        if (attributes.representedElementKind == nil) {
            // 代表是UICollectionViewCell
            [self updateLayoutAttributesWith:dataArr];
            return dataArr;
        } else {
            // 代表是SupplementaryView(Header/Footer)或者DecorationView（装饰器View）
            // 不做特殊处理
        }
    }
    return dataArr;
}

- (void)updateLayoutAttributesWith:(NSArray<UICollectionViewLayoutAttributes *> *)arr {
    // 在更新属性时，由于换行的都是一行展示不下，故不需要考虑换行的情况
    CGFloat initOrginY = -1;
    CGFloat itemSpace = self.minimumInteritemSpacing;
    UIEdgeInsets edgeInsets = self.sectionInset;
    
    /// 分行
    NSMutableArray *horizontalArray = [@[] mutableCopy];
    // 声明同行的可变数组用于保存
    NSMutableArray *marr;
    for (UICollectionViewLayoutAttributes *attributes in arr) {
        // 获取当前行的OriginY
        if (initOrginY < attributes.frame.origin.y) {
            initOrginY = attributes.frame.origin.y;
            marr = [@[] mutableCopy];
            [horizontalArray addObject:marr];
        }
        
        if (attributes.frame.origin.y == initOrginY) {
            
            [marr addObject:attributes];
        }
    }
    
    /// 每行item和
    NSMutableArray *totalArray = [@[] mutableCopy];
    for (NSArray<UICollectionViewLayoutAttributes *> *arr in horizontalArray) {
        CGFloat total = 0;
        for (UICollectionViewLayoutAttributes *attributes in arr) {
            total += attributes.size.width;
        }
        [totalArray addObject:@(total)];
    }
    
    /// 更新数据
    int horizontal = 0;
    for (NSArray<UICollectionViewLayoutAttributes *> *arr in horizontalArray) {
        if (self.directionType == FFTagCollectionViewFlowLayoutDirectionTypeLeft) {
            CGFloat widthSum = 0;
            for (int i = 0; i < arr.count; i++) {
                UICollectionViewLayoutAttributes *attributes = arr[i];
                CGFloat originX = edgeInsets.left + itemSpace * i + widthSum;
                attributes.frame = CGRectMake(originX, attributes.frame.origin.y, attributes.size.width, attributes.size.height);
                widthSum += attributes.size.width;
            }
        }
        if (self.directionType == FFTagCollectionViewFlowLayoutDirectionTypeCenter) {
            // 居中对齐时，如果是不规则的宽度，会默认居中，如果是规则宽度，默认左对齐
            // 首先获取左侧偏移
            CGFloat totalWidth = [totalArray[horizontal] floatValue];
            CGFloat leftSpace = (self.collectionViewContentSize.width - totalWidth - itemSpace * (arr.count - 1) - edgeInsets.left - edgeInsets.right) / 2.0;
            CGFloat widthSum = 0;
            for (int i = 0; i < arr.count; i++) {
                UICollectionViewLayoutAttributes *attributes = arr[i];
                CGFloat originX = edgeInsets.left + leftSpace + itemSpace * i + widthSum;
                attributes.frame = CGRectMake(originX, attributes.frame.origin.y, attributes.size.width, attributes.size.height);
                widthSum += attributes.size.width;
            }
            horizontal++;
        }
        if (self.directionType == FFTagCollectionViewFlowLayoutDirectionTypeRight) {
            NSInteger total = arr.count - 1;
            CGFloat widthSum = 0;
            for (int i = (int)total; i >= 0; i--) {
                UICollectionViewLayoutAttributes *attributes = arr[i];
                widthSum += attributes.size.width;
                CGFloat originX = self.collectionViewContentSize.width - edgeInsets.right - widthSum;
                attributes.frame = CGRectMake(originX, attributes.frame.origin.y, attributes.size.width, attributes.size.height);
                // 由于倒叙会丢失一个item的间隔故补上
                widthSum += itemSpace;
            }
        }
    }
}

@end
