//
//  Kindergarden.m
//  FallsLayout
//
//  Created by jisa on 2021/5/17.
//

#import "Kindergarden.h"
#import <objc/runtime.h>
@implementation Kindergarden
- (id)copyWithZone:(NSZone *)zone {
    return [self doCopyWithZone:zone];
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return [self doCopyWithZone:zone];
}

- (id)doCopyWithZone:(NSZone *)zone {
    Kindergarden *garten = [[Kindergarden allocWithZone:zone] init];
    unsigned int outCount;
    objc_property_t *propertyList = class_copyPropertyList([self class], &outCount);
    for (int i = 0; i < outCount; i++) {
        objc_property_t pro = propertyList[i];
        NSString *proName = [[NSString alloc] initWithCString:property_getName(pro) encoding:NSUTF8StringEncoding];
        [garten setValue:[self valueForKey:proName] forKey:proName];
    }
    return garten;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"grade = %@\n", self.grade];
}
@end
