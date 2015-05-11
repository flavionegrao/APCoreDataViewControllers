//
//  APSelectCoreDataTVC.m
//
//
//  Created by Flavio Torres on 14/02/12.
//  Copyright (c) 2013 Apetis. All rights reserved.
//

#import "APSelectCoreDataTVC.h"


@interface APSelectCoreDataTVC ()

@property (nonatomic,copy) void (^viewDidSelectCallBack) (id object);
@property (nonatomic,copy) void (^viewDidDeselectCallBack) (id object);

@property (nonatomic,strong) NSMutableSet* mutableSelectedObjects;

@end


@implementation APSelectCoreDataTVC

// Loaded via storyboard segue
- (instancetype)initWithCoder:(NSCoder *)coder {
    
    self = [super initWithCoder:coder];
    if (self) {
        [self loadDefaults];
    }
    return self;
}


- (instancetype) initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        [self loadDefaults];
    }
    return self;
}


- (void) loadDefaults {
    _allowMultipleSelections = NO;
    _allowSelectNone = NO;
}


- (void) setAllowMultipleSelections:(BOOL)allowMultipleSelections {
    _allowMultipleSelections = allowMultipleSelections;
    self.tableView.allowsMultipleSelection = allowMultipleSelections;
    //self.searchDisplayController.searchResultsTableView.allowsMultipleSelection = allowMultipleSelections;
}

#pragma mark - Getter and Setters

- (void) setSelectedObjects:(NSSet *)selectedObjects {
    _mutableSelectedObjects = [selectedObjects mutableCopy];
    [self.tableView reloadData];
}

- (NSMutableSet*) mutableSelectedObjects {
    if (_mutableSelectedObjects == nil) {
        _mutableSelectedObjects = [NSMutableSet set];
    }
    return _mutableSelectedObjects;
}

- (NSSet*) selectedObjects {
    return [_mutableSelectedObjects copy];
}

- (void) setViewDidSelectCallBack: (void (^) (id object)) block  {
    _viewDidSelectCallBack = block;
}

- (void) setViewDidDeselectCallBack: (void (^) (id object)) block  {
    _viewDidDeselectCallBack = block;
}

- (void) setIsLoading:(BOOL)isLoading {
    [super setIsLoading:isLoading];
    
    if (isLoading == NO && [[self.frc fetchedObjects] count] > 0) {
        
        if ([self.selectedObjects count] == 1) {
            id object = [self.selectedObjects anyObject];
            NSIndexPath* indexPathForFirstSelectedObject = [self.frc indexPathForObject:object];
            [self.tableView scrollToRowAtIndexPath:indexPathForFirstSelectedObject atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
        }
    }
}


#pragma mark - Tableview Datasource

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.tableView.dataSource == self) {
        NSManagedObject* object = [self.frc objectAtIndexPath:indexPath];
        
        if ([self.selectedObjects containsObject:object]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
}

//- (void) configCell:(UITableViewCell *)cell withManagedObject:(NSManagedObject *)object forIndexPath:(NSIndexPath*) indexPath {}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    NSFetchedResultsController* frc = [self frcForTableView:tableView];
    NSManagedObject* selectedObject = [self.frc objectAtIndexPath:indexPath];
    
    if (![self.mutableSelectedObjects containsObject:selectedObject]) {
        
        if (self.allowSelectNone || self.allowMultipleSelections) {
            [self.mutableSelectedObjects addObject:selectedObject];
            
        } else {
            [self.mutableSelectedObjects removeAllObjects];
            [self.mutableSelectedObjects addObject:selectedObject];
        }
        
        if (self.viewDidSelectCallBack) self.viewDidSelectCallBack(selectedObject);
        
    } else {
        
        if (self.allowMultipleSelections) {
            
            if (self.allowSelectNone) {
                [self.mutableSelectedObjects removeObject:selectedObject];
                
            } else if ([self.mutableSelectedObjects count] > 0) {
                [self.mutableSelectedObjects removeObject:selectedObject];
            }
            
        } else if (self.allowSelectNone) {
            
            [self.mutableSelectedObjects removeAllObjects];
        }
        
        if (self.viewDidDeselectCallBack) self.viewDidDeselectCallBack(selectedObject);
    }
    
//    if (self.searchDisplayController.isActive) {
//        [self.searchDisplayController.searchResultsTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//        NSIndexPath* mainTableIndexPath = [self.frc indexPathForObject:selectedObject];
//        [self.tableView reloadRowsAtIndexPaths:@[mainTableIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//        
//    } else {
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
 //   }
}


@end
