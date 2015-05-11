//
//  AddToListCoreDataTVC.m
//  APCoreDataViewControllersExample
//
//  Created by Flavio Negrão Torres on 5/22/14.
//  Copyright (c) 2014 Flavio Negrão Torres. All rights reserved.
//

#import "AddToListCoreDataTVC.h"
#import "CoreDataController.h"
#import "ExampleEntity.h"

@interface AddToListCoreDataTVC ()

@end

@implementation AddToListCoreDataTVC

- (void) viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItems = @[self.navigationItem.rightBarButtonItem,self.editButtonItem];
}

- (IBAction)addButtonTouched:(UIBarButtonItem *)sender {
    
    ExampleEntity* entity = (ExampleEntity*)[NSEntityDescription insertNewObjectForEntityForName:@"ExampleEntity" inManagedObjectContext:self.frc.managedObjectContext];
    entity.mainAtribute = @"Something";
//    NSError* error = nil;
//    if (![self.frc.managedObjectContext save:&error]) {
//        NSLog(@"Error saving: %@",error.localizedDescription);
//    }
}

- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    ExampleEntity* entity = [self.frc objectAtIndexPath:indexPath];
    [self.frc.managedObjectContext deleteObject:entity];
}

@end
