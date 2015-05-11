//
//  ExampleEntity+Populate.m
//  APCoreDataViewControllersExample
//
//  Created by Flavio Negrão Torres on 5/21/14.
//  Copyright (c) 2014 Flavio Negrão Torres. All rights reserved.
//

#import "ExampleEntity+Populate.h"
#import "CoreDataController.h"

@implementation ExampleEntity (Populate)

+ (void) loadOnMillionEntities {
    
    NSManagedObjectContext* moc = [CoreDataController sharedInstance].mainContext;
    ExampleEntity* entity;
    for (NSInteger i = 0; i < 10000; i++) {
        entity = (ExampleEntity*) [NSEntityDescription insertNewObjectForEntityForName:@"ExampleEntity" inManagedObjectContext:moc];
        entity.mainAtribute = [NSString stringWithFormat:@"Main #%lu",(unsigned long) i];
        entity.detailAttribute = [NSString stringWithFormat:@"Detail string #%lu",(unsigned long) i];
        NSLog(@"#%lu",(unsigned long) i);
    }
    
    NSError* error;
    if (![moc save:&error]) {
        NSLog(@"Error saving core data: %@", error.localizedDescription);
    };
}

@end
