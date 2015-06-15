//
//  CoreDataTVC.m
//

#import "APCoreDataTVC.h"

NSString* const APCoreDataTVCNotificationRefresh = @"com.apetis.apChatControllers.coredatatvc.refresh";


@interface APCoreDataTVC()

/// Reservar selection depois que a tableview sofrer update
@property (nonatomic,strong) NSIndexPath* currentSelectionIndexPath;

@end


@implementation APCoreDataTVC


#pragma mark - View LifeCycle

- (void) viewDidLoad {

    [super viewDidLoad];
    
    if (self.frc /*&& self.isLoading == NO*/) {
        if (!self.frc.fetchedObjects) {
            [self fetch];
        }
    }
}


#pragma mark - Getters and Setters

- (void) setFrc:(NSFetchedResultsController *)newFrc {

    if (_frc == newFrc) {
        [self.tableView reloadData];
        
    } else if (newFrc) {
        _frc.delegate = nil;
        newFrc.delegate = self;
        
        _frc = newFrc;
        if (self.isViewLoaded) {
            [self fetch];
        }
        
    } else {
        _frc = nil;
        [self.tableView reloadData];
    }
}


#pragma mark - Fetching

- (void) fetch {
    
    if (self.frc) {
        //self.isLoading = YES;
        self.suspendAutomaticTrackingOfChangesInManagedObjectContext = YES;
        
        //[self.frc.managedObjectContext performBlock:^{
            NSError *error;
            
            if (![self.frc performFetch:&error]) {
                NSLog(@"NSFetchedResultsController error: %@", error);
            
            } else {
                //[[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    self.suspendAutomaticTrackingOfChangesInManagedObjectContext = NO;
                    [self.tableView reloadData];
                   // self.isLoading = NO;
                //}];
            }
        //}];
    }
}


#pragma mark - UITableViewDataSource

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"%@ must override %@ in a subclass",
                                           NSStringFromClass([self class]),
                                           NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.frc sections] count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger numberOfRows = 0;
    
    NSArray *sections = self.frc.sections;
    
    if (sections.count > section) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:section];
        numberOfRows = [sectionInfo numberOfObjects];
    }
    return numberOfRows;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
    if ([[self.frc sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.frc sections] objectAtIndex:section];
        return NSLocalizedString([sectionInfo name],nil);
    } else {
        return nil;
    }
}


#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    
     //self.isLoading = YES;
    
    if (!self.suspendAutomaticTrackingOfChangesInManagedObjectContext) {

        if (self.tableView.dataSource == self) {
        
            if (!self.suspendAutomaticTrackingOfChangesInManagedObjectContext) {
                [self.tableView beginUpdates];
            }
            self.currentSelectionIndexPath = [self.tableView indexPathForSelectedRow];
        }
    }
}


- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type {
    
    
    if (!self.suspendAutomaticTrackingOfChangesInManagedObjectContext) {
        if (self.tableView.dataSource == self) {
            switch(type) {
                case NSFetchedResultsChangeInsert:
                    [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
                    break;
                    
                case NSFetchedResultsChangeDelete:
                    [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
                    break;
                    
                case NSFetchedResultsChangeMove:
                case NSFetchedResultsChangeUpdate:
                    break;
            }
        }
    }
}


- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    if (!self.suspendAutomaticTrackingOfChangesInManagedObjectContext) {
        
        if (self.tableView.dataSource == self) {
            
            switch(type) {
                    
                case NSFetchedResultsChangeInsert:
                    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                    break;
                    
                case NSFetchedResultsChangeDelete:
                    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    break;
                    
                case NSFetchedResultsChangeUpdate:
                    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    break;
                    
                case NSFetchedResultsChangeMove:
                    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                    break;
            }
        }
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    
    if (self.tableView.dataSource == self) {
        if (!self.suspendAutomaticTrackingOfChangesInManagedObjectContext) {
            [self.tableView endUpdates];
            [self.tableView selectRowAtIndexPath:self.currentSelectionIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
    }
    
    //
    //self.isLoading = NO;
}

@end

