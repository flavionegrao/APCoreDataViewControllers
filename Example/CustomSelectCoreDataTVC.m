//
//  CustomSelectCoreDataTVC.m
//  APCoreDataViewControllersExample
//
//  Created by Flavio Negrão Torres on 5/22/14.
//  Copyright (c) 2014 Flavio Negrão Torres. All rights reserved.
//

#import "CustomSelectCoreDataTVC.h"
#import "ExampleEntity.h"

@interface CustomSelectCoreDataTVC ()

@end

@implementation CustomSelectCoreDataTVC


- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* cellID = @"customCellID";
    UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    ExampleEntity* entity = [self.frc objectAtIndexPath:indexPath];
    cell.textLabel.text = entity.mainAtribute;
   // cell.detailTextLabel.text = entity.detailAttribute;
    
    return cell;
}

@end
