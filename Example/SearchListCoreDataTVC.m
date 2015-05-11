//
//  SearchListCoreDataTVC.m
//  APCoreDataViewControllersExample
//
//  Created by Flavio Negrão Torres on 5/22/14.
//  Copyright (c) 2014 Flavio Negrão Torres. All rights reserved.
//

#import "SearchListCoreDataTVC.h"

static NSInteger const APSearchOptionText = 0;
static NSInteger const APSearchOptionNumber = 1;


@implementation SearchListCoreDataTVC


#pragma mark - APCoreDataViewControllersSearching Protocol

- (NSFetchedResultsController*) createSearchFRC {
    
    NSFetchedResultsController* searchBarFRC;
    
    if (self.frc) {
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"ExampleEntity"];
        NSString* typedString = self.searchDisplayController.searchBar.text;
        
        NSPredicate* mainAttrPredicate = [NSPredicate predicateWithFormat:@"mainAtribute beginswith [cd] %@",typedString];
        NSPredicate* detailAttrPredicate = [NSPredicate predicateWithFormat:@"detailAttribute beginswith [cd] %@",typedString];
        NSPredicate* searchFilterPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:@[mainAttrPredicate,detailAttrPredicate]];

        
        // Current FR + SearchBar FR
        if (self.frc.fetchRequest.predicate) {
            request.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[self.frc.fetchRequest.predicate,searchFilterPredicate]];
        } else {
            request.predicate = searchFilterPredicate;
        }
        request.sortDescriptors = self.frc.fetchRequest.sortDescriptors;
        
        // Set the batch size to a suitable number.
        [request setFetchBatchSize:20];
        
        searchBarFRC = [[NSFetchedResultsController alloc]initWithFetchRequest:request
                                                          managedObjectContext:self.frc.managedObjectContext
                                                            sectionNameKeyPath:self.frc.sectionNameKeyPath
                                                                     cacheName:nil];
    }
    return searchBarFRC;
}


- (UIKeyboardType) keyboardTypeForSearchFilterForScope: (NSInteger) selectedScopeButtonIndex {
    
    if (selectedScopeButtonIndex == APSearchOptionNumber) {
        return  UIKeyboardTypeNumberPad;
        
    } else if (selectedScopeButtonIndex == APSearchOptionText) {
        return  UIKeyboardTypeAlphabet;
        
    } else {
        // default
        return UIKeyboardTypeAlphabet;
    }
}


@end
