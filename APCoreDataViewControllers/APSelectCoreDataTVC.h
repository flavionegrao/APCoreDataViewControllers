//
//  APSelectCoreDataTVC.h
//
//
//  Created by Flavio Torres on 14/02/12.
//  Copyright (c) 2013 Apetis All rights reserved.
//


#import "APListCoreDataTVC.h"

@interface APSelectCoreDataTVC : APListCoreDataTVC

#pragma mark - Multiple Selections

/**
 The managed objects that this view controller will mark as selected.
 The view controller will call the blocks assign with setViewDidSelectCallBack: and setViewDidDeselectCallBack: and will keep the current selection in this property as well.
 */
@property (nonatomic, strong) NSSet* selectedObjects;

/**
 If YES multiple objects can be selected
 default is NO.
 */
@property (nonatomic,assign) BOOL allowMultipleSelections;


/** 
 If YES the view controller will allow no object remain selected
 Default is NO
 */
@property (nonatomic,assign) BOOL allowSelectNone;


/** 
 Override this method to customize the subclass cell
 @param cell The cell to be configured
 @param object Object to be used to configure de cell
 @param indexPath An index path locating a row in tableView
 */
//- (void) configCell:(UITableViewCell *)cell withManagedObject:(NSManagedObject *)object forIndexPath:(NSIndexPath*) indexPath;


#pragma mark - CallBacks

/** 
 This is the method called whenever a cell is Selected.
 @param block the block to be called
 */
@property (nonatomic,copy) void (^viewDidSelectCallBack) (id object);


/**
 This is the method called whenever a cell is Deselected.
 @param block the block to be called
 */
@property (nonatomic,copy) void (^viewDidDeselectCallBack) (id object);


@end