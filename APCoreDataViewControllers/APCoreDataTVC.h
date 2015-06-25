//
//  APCoreDataTVC.h
//

@import CoreData;
@import UIKit;


/// Post a NSNotification with this NSString will cause a refetch
extern NSString* const APCoreDataTVCNotificationRefresh;


/**
 Just subclass this and set the frc.
 The only UITableViewDataSource method you'll HAVE to implement is tableView:cellForRowAtIndexPath:.
 And you can use the NSFetchedResultsController method objectAtIndexPath: to do it.
 
 If you want to have a searchDisplayController presented, the subclass needs to implement the protocol APCoreDataViewControllersSearching
 
 Remember that once you create an NSFetchedResultsController, you CANNOT modify its @properties
 If you want new fetch parameters (predicate, sorting, etc.),
 create a NEW NSFetchedResultsController and set this class's fetchedResultsController @property again.
 */
@interface APCoreDataTVC : UITableViewController <NSFetchedResultsControllerDelegate/*,UISearchDisplayDelegate*/>

/**
 Turn this on before making any changes in the managed object context that
 are a one-for-one result of the user manipulating rows directly in the table view.
 Such changes cause the context to report them (after a brief delay),
 and normally our fetchedResultsController would then try to update the table,
 but that is unnecessary because the changes were made in the table already (by the user)
 so the fetchedResultsController has nothing to do and needs to ignore those reports.
 Turn this back off after the usuario has finished the change.
 Note that the effect of setting this to NO actually gets delayed slightly
 so as to ignore previously-posted, but not-yet-processed context-changed notifications,
 therefore it is fine to set this to YES at the beginning of, e.g., tableView:moveRowAtIndexPath:toIndexPath:,
 and then set it back to NO at the end of your implementation of that method.
 It is not necessary (in fact, not desirable) to set this during row deletion or insertion
 (but definitely for row moves).
 */
@property (nonatomic) BOOL suspendAutomaticTrackingOfChangesInManagedObjectContext;

/**
 The controller (this class fetches nothing if this is not set).
 When this property is set, this class will set its delegate to itself and
 performfetch on it on viewDidAppear:
 */
@property (strong, nonatomic) NSFetchedResultsController *frc;

/**
 Whether the table is actively loading new data from Core Data
 */
@property (assign,nonatomic) BOOL isLoading;

- (void) fetch;


@end
