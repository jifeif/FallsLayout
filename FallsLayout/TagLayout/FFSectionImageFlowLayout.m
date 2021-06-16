//
//  FFSectionImageFlowLayout.m
//  FallsLayout
//
//  Created by jisa on 2021/5/7.
//

#import "FFSectionImageFlowLayout.h"
//#import "FFBackgroundImageView.h"
@implementation FFSectionImageFlowLayout

- (void)prepareLayout {
    [super prepareLayout];
//    [self registerClass:[FFBackgroundImageView class] forDecorationViewOfKind:@"background"];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attri = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:elementKind withIndexPath:indexPath];
    attri.frame = CGRectMake(0, 0, self.collectionViewContentSize.width, self.collectionViewContentSize.height);
    attri.zIndex = -1;
    return attri;
}

- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *layoutAttributesArr = [super layoutAttributesForElementsInRect:rect];
    NSMutableArray *marr = [layoutAttributesArr mutableCopy];
    
    
    [marr addObject:[self layoutAttributesForDecorationViewOfKind:@"background" atIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]]];
    return marr;
}
@end
