
#import "CoreDataController.h"

static NSString* const kLocalCacheFileName = @"APCoreDataStore.sqlite";


@interface CoreDataController ()

@property (nonatomic, strong) NSPersistentStoreCoordinator *psc;
@property (nonatomic, strong) NSManagedObjectContext *mainContext;

@end


@implementation CoreDataController

+ (instancetype)sharedInstance {
    
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc]init];
    });
    return sharedInstance;
}



#pragma mark - Gettters and Setters


- (NSManagedObjectContext*) mainContext {
    
    if (!_mainContext) {
        
        _mainContext = [[NSManagedObjectContext alloc]initWithConcurrencyType:NSMainQueueConcurrencyType];
        _mainContext.persistentStoreCoordinator = self.psc;
    }
    return _mainContext;
}


- (NSPersistentStoreCoordinator*) psc {
    
    if (!_psc) {
    
        NSManagedObjectModel* model = [NSManagedObjectModel mergedModelFromBundles:nil];
        NSURL *storeURL = [NSURL fileURLWithPath:[self pathToLocalStore]];
        
        _psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
        
        NSError* error;
        [_psc addPersistentStoreWithType:NSSQLiteStoreType
                               configuration:nil
                                         URL:storeURL
                                     options:@{NSMigratePersistentStoresAutomaticallyOption:@YES,
                                               NSInferMappingModelAutomaticallyOption:@YES}
                                               /*NSSQLitePragmasOption:@{@"journal_mode":@"DELETE"}} // DEBUG ONLY: Disable WAL mode to be able to visualize the content of the sqlite file.*/
                                       error:&error];
        if (error) {
            [NSException raise:@"APCoreDataViewControllersExampleException" format:@"Error creating sqlite persistent store: %@", error];
        }
    }
    
    return _psc;
}


#pragma mark - Utils

- (NSString *)documentsDirectory {
    
    NSString *documentsDirectory = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDirectory = paths[0];
    return documentsDirectory;
}


- (NSString *)pathToLocalStore {
    
    return [[self documentsDirectory] stringByAppendingPathComponent:@"Example.sqlite"];
}


@end
