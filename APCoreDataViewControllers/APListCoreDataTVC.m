//
//  APListCoreDataTVC.m
//
//  Created by Flavio Torres on 13/08/13.
//  Copyright (c) 2013 Apetis. All rights reserved.
//

#import "APListCoreDataTVC.h"

#import "APPlaceHolderDataSource.h"


@interface APListCoreDataTVC()

@property (strong, nonatomic) UILabel* emptyTableLabel;

@property (strong, nonatomic) APPlaceHolderDataSource* loadingDataSource;
@property (strong, nonatomic) APPlaceHolderDataSource* emptyDataSource;

@end


@implementation APListCoreDataTVC

#pragma mark - View Lifecycle

- (void) viewDidLoad {
    
    [super viewDidLoad];
    
    if (self.loadingText) {
        if (self.tableView.style == UITableViewStylePlain) {
            self.tableView.dataSource = self.loadingDataSource;
            [self.tableView reloadData];
        } else {
            self.tableView.backgroundView = [self loadingBackgroundView];
        }
    }
}


#pragma mark - Getter and Setters

- (APPlaceHolderDataSource*) loadingDataSource {
    
    if (!_loadingDataSource) {
        _loadingDataSource = [[APPlaceHolderDataSource alloc]initWithPlaceHolerText:self.loadingText];
        _loadingDataSource.showActivityIndicator = YES;
    }
    return _loadingDataSource;
}


- (APPlaceHolderDataSource*) emptyDataSource {
    
    if (!_emptyDataSource) {
        _emptyDataSource = [[APPlaceHolderDataSource alloc]initWithPlaceHolerText:self.emptyListText];
    }
    return _emptyDataSource;
}


- (void) setEmptyListText:(NSString *)emptyListText {
    _emptyListText = emptyListText;
    self.emptyDataSource.placeHolderText = emptyListText;
}


- (void) setIsLoading:(BOOL)isLoading {
    
    [super setIsLoading:isLoading];
    
    if (self.tableView.style == UITableViewStylePlain) {
        
        id<UITableViewDataSource> newDataSource = [self newDataSource];
        id<UITableViewDataSource> oldDataSource = self.tableView.dataSource;
        
        self.tableView.dataSource = newDataSource;
        if (oldDataSource != newDataSource) {
            [self.tableView reloadData];
        }
    
    } else {
        
        /* UITableViewStyleGrouped - the datasource will always be self */
        
        if (isLoading) {
            self.tableView.backgroundView = [self loadingBackgroundView];
            
        } else if ([self.frc.fetchedObjects count] > 0) {
            self.tableView.backgroundView = nil;
            
        } else {
            self.tableView.backgroundView = [self emptyTableBackgroundView];
        }
    }
}


- (id<UITableViewDataSource>)newDataSource {
    
    if (self.isLoading) {
        
        if ([self.frc.fetchedObjects count] > 0) {
            return self;
            
        } else if (self.loadingText) {
            return self.loadingDataSource;
            
        } else {
            return self;
        }
        
    } else {
        
        if ([self.frc.fetchedObjects count] > 0) {
            return self;
            
        } else {
            return self.emptyDataSource;
        }
    }
}

//- (BOOL) isTheRealDataSourceEmpty {
//    return ([self.frc.sections[0] numberOfObjects] > 0);
//}

- (UIView*) emptyTableBackgroundView {
    
    UILabel* view = [UILabel new];
    view.textAlignment = NSTextAlignmentCenter;
    view.textColor = self.tableView.separatorColor;
    view.font = [UIFont systemFontOfSize:20];
    view.text = self.emptyListText;
    
    return view;
}


- (UIView*) loadingBackgroundView {
    
    UIView* view = [UIView new];
    
    UILabel* label = [UILabel new];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = self.tableView.separatorColor;
    label.font = [UIFont systemFontOfSize:20];
    label.text = self.loadingText;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:label];
    
    UIActivityIndicatorView* activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [activityIndicator startAnimating];
    activityIndicator.hidesWhenStopped = YES;
    activityIndicator.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:activityIndicator];
    
    NSDictionary* views = @{@"label":label, @"activityIndicator":activityIndicator};
    
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[activityIndicator]-[label]"
                                                                 options:0 metrics:nil views:views]];
    
    [view addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:view
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1 constant:1]];
    
    [view addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:view
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1 constant:1]];
    
    [view addConstraint:[NSLayoutConstraint constraintWithItem:activityIndicator
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:view
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1 constant:1]];
    
    return view;
}


#pragma mark - TableView Datasource

- (BOOL) tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.dataSource == self) {
        return YES;
    } else {
        return NO;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"cellID";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellID] ?: [[UITableViewCell alloc]initWithStyle:self.cellStyle reuseIdentifier:cellID];
    
    NSManagedObject* object = [self.frc objectAtIndexPath:indexPath];
    
    if (self.cellTextLabelKey) {
        cell.textLabel.text = NSLocalizedString([object valueForKeyPath:self.cellTextLabelKey], nil);
    } else {
        NSLog(@"You don't override APListCoreDataTVC you need to set at least cellTextLabelKey");
    }
    
    if (self.cellDetailTextLabelKey) {
        cell.detailTextLabel.text = NSLocalizedString([object valueForKeyPath:self.cellDetailTextLabelKey],nil);
    }
    
    if (self.cellImageKey) {
        cell.imageView.image = [object valueForKeyPath:self.cellImageKey];
    }
    
    return cell;
}

@end

