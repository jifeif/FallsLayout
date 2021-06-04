//
//  Student.h
//  FallsLayout
//
//  Created by jisa on 2021/5/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class Kindergarden;
@interface Student : NSObject<NSCopying>
@property (nonatomic, strong) NSString *name;
@property (nonatomic, copy) NSString *school;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, strong) Kindergarden *garten;
@end

NS_ASSUME_NONNULL_END
