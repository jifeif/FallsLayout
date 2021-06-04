//
//  FFWaterCollectionViewLayout.m
//  FallsLayout
//
//  Created by jisa on 2021/5/24.
//

#import "FFWaterCollectionViewLayout.h"

@interface FFWaterCollectionViewLayout ()
@property (nonatomic, strong) NSMutableArray *heightArr;
@property (nonatomic, strong) NSMutableArray *attributesArr;
@end

@implementation FFWaterCollectionViewLayout
- (instancetype)init {
    if (self = [super init]) {
        self.sectionInset = UIEdgeInsetsZero;
        self.minimumLineSpacing = 0;
        self.invalidItemSpacing = NO;
        self.minimumInteritemSpacing = 0;
        self.headerReferenceSize = CGSizeZero;
        self.footerReferenceSize = CGSizeZero;
        self.heightArr = [@[] mutableCopy];
        self.attributesArr = [@[] mutableCopy];
    }
    return self;
}


- (void)prepareLayout {
    [super prepareLayout];
    NSInteger sections = [self.collectionView numberOfSections];
    NSAssert(sections > 0, @"without numberOfSections");
    for (int i = 0; i < _column; i++) {
        [self.heightArr addObject:@(0)];
    }
    
    for (int i = 0; i < sections; i++) {
        
        // section header
        [self resetHeaderLayoutWithSection:i];
        
        // 添加顶部缩进
        [self addHeight:self.sectionInset.top index:-1];
                
        [self resetItemLayoutWithSection:i];
        
        // 底部缩进
        [self addHeight:self.sectionInset.bottom index:-1];
        
        // section footer
        [self resetFooterLayoutWithSection:i];
                
        // 高度同步
        [self updateRecordArrayHorizontal];
    }
    
}

#pragma mark -- 更新section 中的 header 布局
/// 设置header的样式
/// @param section 部分
- (void)resetHeaderLayoutWithSection:(NSInteger)section {
    CGFloat headerHeight = [self acquireHeaderSizeWithSection:section].height;
    if (headerHeight > 0) {
        UICollectionViewLayoutAttributes *headerAttri = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:[NSIndexPath indexPathWithIndex:section]];
        headerAttri.frame = CGRectMake(0,  [self.heightArr[0] floatValue], self.collectionView.bounds.size.width, headerHeight);
        [self.attributesArr addObject:headerAttri];
        [self addHeight:headerHeight index:-1];
    }
}

#pragma mark -- 更新section 中的 item 布局
/// 更新section 中的 item 布局
/// @param section 部分
- (void)resetItemLayoutWithSection:(NSInteger)section{
    
    NSInteger itemsCount = [self.collectionView numberOfItemsInSection:section];
    for (int j = 0; j < itemsCount; j++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:section];
        CGFloat itemHeight = [self acquireHeightWithIndexPath:indexPath];
        NSInteger minColumn = [self findMinColumn];
        CGFloat offsetY = [self.heightArr[minColumn] floatValue];
        
        // 校验最小间隔是否合适
        CGFloat dreamSpacing = (self.collectionView.bounds.size.width - _itemwidth * _column - _sectionInset.left - _sectionInset.right) / 2;
        if (!self.invalidItemSpacing) {
            // 如果约定的最小间隔，大于可用的,强制更改
            dreamSpacing = dreamSpacing > self.minimumInteritemSpacing ? self.minimumLineSpacing : dreamSpacing;
        }
        
        CGFloat offsetX = self.sectionInset.left + (_itemwidth + floorf(dreamSpacing)) * (j % _column);
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        attributes.frame = CGRectMake(offsetX, offsetY, _itemwidth, itemHeight);
        [self.attributesArr addObject:attributes];
        // 判断是不是最后一行
        if (j + _column > itemsCount - 1) {
            [self addHeight:itemHeight index:minColumn];
        } else {
            [self addHeight:itemHeight + self.minimumLineSpacing index:minColumn];
        }
    }
}

#pragma mark -- 更新section 中的 footer 布局
/// 设置footer的样式
/// @param section 部分
- (void)resetFooterLayoutWithSection:(NSInteger)section {
    CGFloat footerHeight = [self acquireFooterSizeWithSection:section].height;
    if (footerHeight > 0) {
        UICollectionViewLayoutAttributes *footerAttri = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:[NSIndexPath indexPathWithIndex:section]];
        NSInteger maxColumn = [self findMaxColumn];
        footerAttri.frame = CGRectMake(0,  [self.heightArr[maxColumn] floatValue], self.collectionView.bounds.size.width, footerHeight);
        [self.attributesArr addObject:footerAttri];
        [self addHeight:footerHeight index:-1];
    }
}

#pragma mark -- 获取 Section header 的大小
/// 获取 Section header 的大小
- (CGSize)acquireHeaderSizeWithSection:(NSInteger)section {
    if (_headerReferenceSize.height > 0) {
        return _headerReferenceSize;
    } else if ([self.delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForHeaderInSection:)]) {
        return [self.delegate collectionView:self.collectionView layout:self referenceSizeForHeaderInSection:section];
    } else {
        return CGSizeZero;
    }
}

#pragma mark -- 获取 Section footer 的大小
/// 获取 Section footer 的大小
- (CGSize)acquireFooterSizeWithSection:(NSInteger)section {
    if (_footerReferenceSize.height > 0) {
        return _footerReferenceSize;
    } else if ([self.delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForFooterInSection:)]) {
        return [self.delegate collectionView:self.collectionView layout:self referenceSizeForFooterInSection:section];
    } else {
        return CGSizeZero;
    }
}

#pragma mark -- 同步记录高度，即对齐为最大高度
/// 同步记录高度，即对齐为最大高度
- (void)updateRecordArrayHorizontal {
    NSInteger maxColumn = [self findMaxColumn];
    NSValue  *maxValue = self.heightArr[maxColumn];
    for (int i = 0; i < _column; i++) {
        [self.heightArr replaceObjectAtIndex:i withObject:maxValue];
    }
}

- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return [self.attributesArr filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UICollectionViewLayoutAttributes *evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return CGRectIntersectsRect(rect, evaluatedObject.frame);
    }]];
}

- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger total = 0;
    if (indexPath.section == 0) {
        total += indexPath.row;
    } else {
        for (int i = 0; i < indexPath.section; i++) {
            total += [self.collectionView numberOfItemsInSection:i];
        }
        total += indexPath.row;
    }
    return self.attributesArr[total];
}

- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    return [super layoutAttributesForSupplementaryViewOfKind:elementKind atIndexPath:indexPath];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return NO;
}

- (CGSize)collectionViewContentSize {
    NSInteger max = [self findMaxColumn];
    return CGSizeMake(self.collectionView.frame.size.width, ceil([self.heightArr[max] floatValue]));
}

#pragma mark -- 获取对应item的高度
- (CGFloat)acquireHeightWithIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:heightForItemAtIndexPath:)]) {
        return [self.delegate collectionView:self.collectionView layout:self heightForItemAtIndexPath:indexPath];
    }
    NSAssert(NO, @"没有实现高度代理方法");
    return 0;
}

#pragma mark -- 添加高度，在对应的列
- (void)addHeight:(CGFloat)height index:(NSInteger)index {
    if (index == -1) {
        for (int i = 0; i < _column; i++) {
            CGFloat oldHeight = [self.heightArr[i] floatValue];
            oldHeight += height;
            [self.heightArr replaceObjectAtIndex:i withObject:@(oldHeight)];
        }
    } else {
        CGFloat oldHeight = [self.heightArr[index] floatValue];
        oldHeight += height;
        [self.heightArr replaceObjectAtIndex:index withObject:@(oldHeight)];
    }
}

#pragma mark -- 高度最小列
- (NSInteger)findMinColumn {
    __block NSInteger minColumn = 0;
    __block CGFloat minValue= MAXFLOAT;
    [self.heightArr enumerateObjectsUsingBlock:^(NSNumber *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj floatValue] < minValue) {
            minValue = [obj floatValue];
            minColumn = idx;
        }
    }];
    return minColumn;
}

#pragma mark -- 高度最大列
- (NSInteger)findMaxColumn {
    __block NSInteger maxColumn = 0;
    __block CGFloat maxValue= 0;
    [self.heightArr enumerateObjectsUsingBlock:^(NSNumber *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj floatValue] > maxValue) {
            maxValue = [obj floatValue];
            maxColumn = idx;
        }
    }];
    return maxColumn;
}
@end
