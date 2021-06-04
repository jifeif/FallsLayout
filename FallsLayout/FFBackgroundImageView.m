//
//  FFBackgroundImageView.m
//  FallsLayout
//
//  Created by jisa on 2021/5/7.
//

#import "FFBackgroundImageView.h"

@implementation FFBackgroundImageView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIImage *image = [UIImage imageNamed:@"1"];
        self.backgroundColor = [UIColor colorWithPatternImage:image];
    }
    return self;
}

@end
