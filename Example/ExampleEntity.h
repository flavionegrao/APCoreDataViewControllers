//
//  ExampleEntity.h
//  APCoreDataViewControllersExample
//
//  Created by Flavio Negrão Torres on 5/21/14.
//  Copyright (c) 2014 Flavio Negrão Torres. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ExampleEntity : NSManagedObject

@property (nonatomic, retain) NSString * mainAtribute;
@property (nonatomic, retain) NSString * detailAttribute;

@end
