//
//  MainTVC.m
//  APCoreDataViewControllersExample
//
//  Created by Flavio Negrão Torres on 5/21/14.
//  Copyright (c) 2014 Flavio Negrão Torres. All rights reserved.
//

#import "MainTVC.h"

#import "APCoreDataViewControllers/APListCoreDataTVC.h"
#import "APCoreDataViewControllers/APSelectCoreDataTVC.h"
#import "CoreDataController.h"

#import "CustomListCoreDataTVC.h"
#import "SearchListCoreDataTVC.h"
#import "AddToListCoreDataTVC.h"
#import "CustomSelectCoreDataTVC.h"

#import "ExampleEntity+Populate.h"

static NSInteger const kTableViewRowListObjects = 0;
static NSInteger const kTableViewRowListObjectsEmptyList = 1;
static NSInteger const kTableViewRowListObjectsEmptyListAdd = 2;
static NSInteger const kTableViewRowListObjectsSubclass = 3;
static NSInteger const kTableViewRowListObjectsSubclassSearch = 4;
static NSInteger const kTableViewRowSelectSingleObject = 5;
static NSInteger const kTableViewRowSelectMultipleObjects = 6;
static NSInteger const kTableViewRowSelectObjectsSubClass = 7;


@interface MainTVC ()

//Select single
@property (weak, nonatomic) IBOutlet UILabel *selectSingleObjectLabel;
@property (strong, nonatomic) ExampleEntity* selectedEntity;

//Select Multiple
@property (weak, nonatomic) IBOutlet UILabel *selectMultiplesObjectsLabel;
@property (strong, nonatomic) NSMutableSet* selectedObjects;

//Select Multiple Subclass
@property (weak, nonatomic) IBOutlet UILabel *selectMultiplesObjectsSubclassLabel;
@property (strong, nonatomic) NSMutableSet* selectedObjectsSubclass;

@end

@implementation MainTVC

- (void) viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    //[ExampleEntity loadOnMillionEntities];
}


- (NSMutableSet*) selectedObjects {
    
    if (!_selectedObjects) {
        _selectedObjects = [NSMutableSet set];
    }
    return _selectedObjects;
}

- (NSMutableSet*) selectedObjectsSubclass {
    
    if (!_selectedObjectsSubclass) {
        _selectedObjectsSubclass = [NSMutableSet set];
    }
    return _selectedObjectsSubclass;
}


#pragma mark - Navigation

// No storyboard segue
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.item == kTableViewRowListObjects) {
        [self.navigationController pushViewController:[self vcForListObjects] animated:YES];
        
    } else if (indexPath.item == kTableViewRowListObjectsEmptyList) {
         [self.navigationController pushViewController:[self vcForEmptyListObjects] animated:YES];
        
    } else if (indexPath.item == kTableViewRowSelectSingleObject) {
        [self.navigationController pushViewController:[self vcForSelectSingleObject] animated:YES];
        
    } else if (indexPath.item == kTableViewRowSelectMultipleObjects) {
        [self.navigationController pushViewController:[self vcForSelectMultiple] animated:YES];
    }
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    UITableViewCell* selectedCell = (UITableViewCell*) sender;
    NSIndexPath* selectedIndexPath = [self.tableView indexPathForCell:selectedCell];
    
    if (selectedIndexPath.item == kTableViewRowListObjectsSubclass) {
        CustomListCoreDataTVC* tvc = (CustomListCoreDataTVC*) segue.destinationViewController;
        tvc.frc = [self allObjectsFRC];
        tvc.title = @"List Objects Subclass";
        tvc.loadingText = @"Loading...";
        
    }else if (selectedIndexPath.item == kTableViewRowListObjectsEmptyListAdd) {
        AddToListCoreDataTVC* tvc = (AddToListCoreDataTVC*) segue.destinationViewController;
        tvc.frc = [self zeroObjectsChildMOCFRC];
        tvc.title = @"Search Objects Subclass";
        tvc.loadingText = @"Loading...";
        tvc.cellTextLabelKey = @"mainAtribute";
        tvc.cellDetailTextLabelKey = @"detailAttribute";
        
        tvc.emptyListText = @"Empty List";
        
    } else if (selectedIndexPath.item == kTableViewRowListObjectsSubclassSearch) {
        SearchListCoreDataTVC* tvc = (SearchListCoreDataTVC*) segue.destinationViewController;
        tvc.frc = [self allObjectsFRC];
        tvc.title = @"Search Objects Subclass";
        tvc.loadingText = @"Loading...";
        tvc.cellTextLabelKey = @"mainAtribute";
        tvc.cellDetailTextLabelKey = @"detailAttribute";
        
    } else if (selectedIndexPath.item == kTableViewRowSelectObjectsSubClass) {
        CustomSelectCoreDataTVC* tvc = (CustomSelectCoreDataTVC*) segue.destinationViewController;
        tvc.frc = [self oneHundredObjectsFRC];
        tvc.title = @"Select Objects Subclass";
        tvc.loadingText = @"Loading...";
        tvc.allowSelectNone = NO;
        tvc.allowMultipleSelections = YES;
        tvc.selectedObjects = self.selectedObjectsSubclass;
        
        [tvc setViewDidSelectCallBack:^(id object) {
            [self.selectedObjectsSubclass addObject:object];
            [self adjustSelectedObjectsSubclassLabel];
        }];
        
        [tvc setViewDidDeselectCallBack:^(id object) {
            [self.selectedObjectsSubclass removeObject:object];
            [self adjustSelectedObjectsSubclassLabel];
        }];
    }
}


#pragma mark - View Controllers to be Pushed

- (UIViewController*) vcForListObjects {
    
    APListCoreDataTVC* tvc = [[APListCoreDataTVC alloc]initWithStyle:UITableViewStylePlain];
    
    tvc.title = @"List Objects";
    tvc.cellStyle = UITableViewCellStyleValue1;
    tvc.cellTextLabelKey = @"mainAtribute";
    tvc.cellDetailTextLabelKey = @"detailAttribute";
    tvc.loadingText = @"Loading...";
    
    tvc.frc = [self allObjectsFRC];
    
    return tvc;
}


- (UIViewController*) vcForEmptyListObjects {
    
    APListCoreDataTVC* tvc = [[APListCoreDataTVC alloc]initWithStyle:UITableViewStyleGrouped];
    tvc.frc = [self zeroObjectsFRC];
    
    tvc.title = @"List Objects";
    tvc.cellStyle = UITableViewCellStyleValue1;
    tvc.cellTextLabelKey = @"mainAtribute";
    tvc.cellDetailTextLabelKey = @"detailAttribute";
    tvc.loadingText = @"Loading...";
    
    tvc.emptyListText = @"Empty List";
    
    return tvc;
}


- (UIViewController*) vcForSelectSingleObject {
    
    APSelectCoreDataTVC* tvc = [[APSelectCoreDataTVC alloc]initWithStyle:UITableViewStyleGrouped];
    tvc.frc = [self oneHundredObjectsFRC];
    
    tvc.title = @"Select Single Onblect";
    tvc.cellStyle = UITableViewCellStyleValue1;
    tvc.cellTextLabelKey = @"mainAtribute";
    //tvc.cellDetailTextLabelKey = @"detailAttribute";
    tvc.loadingText = @"Loading...";
    
    tvc.emptyListText = @"Empty List";
    tvc.selectedObjects = (self.selectedEntity) ? [NSSet setWithObject:self.selectedEntity] : nil;
    
    tvc.allowMultipleSelections = NO;
    tvc.allowSelectNone = NO;
    
    [tvc setViewDidSelectCallBack:^(id object) {
        self.selectedEntity = (ExampleEntity*) object;
        self.selectSingleObjectLabel.text = self.selectedEntity.mainAtribute;
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    return tvc;
}


- (UIViewController*) vcForSelectMultiple {
    
    APSelectCoreDataTVC* tvc = [[APSelectCoreDataTVC alloc]initWithStyle:UITableViewStyleGrouped];
    tvc.frc = [self oneHundredObjectsFRC];
    
    tvc.title = @"Select Single Onblect";
    tvc.cellStyle = UITableViewCellStyleValue1;
    tvc.cellTextLabelKey = @"mainAtribute";
    //tvc.cellDetailTextLabelKey = @"detailAttribute";
    tvc.loadingText = @"Loading...";
    
    tvc.emptyListText = @"Empty List";
    
    tvc.allowMultipleSelections = YES;
    tvc.allowSelectNone = YES;
    
    tvc.selectedObjects = self.selectedObjects;
    
    [tvc setViewDidSelectCallBack:^(id object) {
        [self.selectedObjects addObject:object];
        [self adjustSelectedObjectsLabel];
    }];
    
    [tvc setViewDidDeselectCallBack:^(id object) {
        [self.selectedObjects removeObject:object];
        [self adjustSelectedObjectsLabel];
    }];
    
    return tvc;
}


- (void) adjustSelectedObjectsLabel {
    
    if ([self.selectedObjects count] == 0) {
        self.selectMultiplesObjectsLabel.text = @"No Object selected";
        return;
    }
    
    NSMutableString* selectedObjectsString = [NSMutableString string];
    
    [self.selectedObjects enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        ExampleEntity* entity = (ExampleEntity*) obj;
        
        if ([selectedObjectsString length] == 0) {
            [selectedObjectsString appendString:entity.mainAtribute];
        } else {
            [selectedObjectsString appendFormat:@" | %@",entity.mainAtribute];
        }
    }];
    self.selectMultiplesObjectsLabel.text = selectedObjectsString;
}


- (void) adjustSelectedObjectsSubclassLabel {
    
    if ([self.selectedObjectsSubclass count] == 0) {
        self.selectMultiplesObjectsSubclassLabel.text = @"No Object selected";
        return;
    }
    
    NSMutableString* selectedObjectsString = [NSMutableString string];
    
    [self.selectedObjectsSubclass enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        ExampleEntity* entity = (ExampleEntity*) obj;
        
        if ([selectedObjectsString length] == 0) {
            [selectedObjectsString appendString:entity.mainAtribute];
        } else {
            [selectedObjectsString appendFormat:@" | %@",entity.mainAtribute];
        }
    }];
    self.selectMultiplesObjectsSubclassLabel.text = selectedObjectsString;
}


#pragma mark - Fetched Results Controllers

- (NSFetchedResultsController*) allObjectsFRC {
    
    NSFetchRequest* fr = [NSFetchRequest fetchRequestWithEntityName:@"ExampleEntity"];
    fr.fetchBatchSize = 100;
    fr.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"mainAtribute" ascending:YES]];
    NSManagedObjectContext* context = [CoreDataController sharedInstance].mainContext;
    return [[NSFetchedResultsController alloc]initWithFetchRequest:fr
                                              managedObjectContext:context
                                                sectionNameKeyPath:nil
                                                         cacheName:NSStringFromSelector(@selector(allObjectsFRC))];
    
}

- (NSFetchedResultsController*) oneHundredObjectsFRC {
    
    NSFetchRequest* fr = [NSFetchRequest fetchRequestWithEntityName:@"ExampleEntity"];
    fr.fetchBatchSize = 100;
    fr.fetchLimit = 100000;
    fr.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"mainAtribute" ascending:YES],
                           [NSSortDescriptor sortDescriptorWithKey:@"detailAttribute" ascending:YES]];
    NSManagedObjectContext* context = [CoreDataController sharedInstance].mainContext;
    return [[NSFetchedResultsController alloc]initWithFetchRequest:fr managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    
}


- (NSFetchedResultsController*) zeroObjectsFRC {
    
    NSFetchRequest* fr = [NSFetchRequest fetchRequestWithEntityName:@"ExampleEntity"];
    fr.predicate = [NSPredicate predicateWithFormat:@"mainAtribute == %@",@"Something"];
    fr.fetchBatchSize = 100;
    fr.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"mainAtribute" ascending:YES],
                           [NSSortDescriptor sortDescriptorWithKey:@"detailAttribute" ascending:YES]];
    NSManagedObjectContext* context = [CoreDataController sharedInstance].mainContext;
    return [[NSFetchedResultsController alloc]initWithFetchRequest:fr managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    
}

- (NSFetchedResultsController*) zeroObjectsChildMOCFRC {
    
    NSFetchRequest* fr = [NSFetchRequest fetchRequestWithEntityName:@"ExampleEntity"];
    fr.predicate = [NSPredicate predicateWithFormat:@"mainAtribute == %@",@"Something"];
    fr.fetchBatchSize = 100;
    fr.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"mainAtribute" ascending:YES],
                           [NSSortDescriptor sortDescriptorWithKey:@"detailAttribute" ascending:YES]];
    
    NSManagedObjectContext* childMOC = [[NSManagedObjectContext alloc]initWithConcurrencyType:NSMainQueueConcurrencyType];
    childMOC.parentContext = [CoreDataController sharedInstance].mainContext;
    return [[NSFetchedResultsController alloc]initWithFetchRequest:fr managedObjectContext:childMOC sectionNameKeyPath:nil cacheName:nil];
    
}

@end
