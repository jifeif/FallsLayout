//
//  Student.m
//  FallsLayout
//
//  Created by jisa on 2021/5/17.
//

#import "Student.h"
#import "Kindergarden.h"
#import <objc/runtime.h>
@implementation Student

- (id)copyWithZone:(NSZone *)zone {
    return [self doCopyWithZone:zone];
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return [self doCopyWithZone:zone];
}

- (id)doCopyWithZone:(NSZone *)zone {
    Student *dent = [[Student allocWithZone:zone] init];
    
    unsigned int outCount;
    objc_property_t *propertyList = class_copyPropertyList([self class], &outCount);
    for (int i = 0; i < outCount; i++) {
        objc_property_t pro = propertyList[i];
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(pro) encoding:NSUTF8StringEncoding];
        id value = [self valueForKey:propertyName];
        [dent setValue:[value copy] forKey:propertyName];
    }
    free(propertyList);
    return dent;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"name = %@\n age = %@\n school = %@\n kindergarten = %@", self.name, @(self.age), self.school, self.garten];
}
@end
