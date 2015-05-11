//
//  CustomListCoreDataTVC.m
//  APCoreDataViewControllersExample
//
//  Created by Flavio Negrão Torres on 5/21/14.
//  Copyright (c) 2014 Flavio Negrão Torres. All rights reserved.
//

#import "CustomListCoreDataTVC.h"
#import "CustomTableViewCell.h"
#import "ExampleEntity.h"

@interface CustomListCoreDataTVC ()

@end

@implementation CustomListCoreDataTVC

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* cellID = @"cellID";
    CustomTableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    ExampleEntity* managedObject = [self.frc objectAtIndexPath:indexPath];
    cell.mainLabel.text = managedObject.mainAtribute;
    cell.detailLabel.text = managedObject.detailAttribute;
    
    return cell;
}

@end
