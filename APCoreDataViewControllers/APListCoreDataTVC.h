//
//  APListCoreDataTVC.h
//
//  Created by Flavio Torres on 13/08/13.
//  Copyright (c) 2013 Apetis. All rights reserved.
//

#import "APCoreDataTVC.h"


/**
 The objectives os this class are:
 1) Present two empty Labels (Header and Body) if the tableview is empty
 2) Show a loading HUD while core data is fetching objects in background
 3) Populate a tableview using the UITableViewCell existing styles
    In this case you can use this class withouth subclassing and set:
    - cellStyle (Default: UITableViewCellStyleDefault
    - cellTextLabelKey
    - cellDetailTextLabelKey (optional)
    - cellImageKey (optional)
 
 If you want to use a UITableViewCell subclass you need to subclass this class and implement
    -[UITableViewController tableView:cellForRowAtIndexPath:]
 */
@interface APListCoreDataTVC : APCoreDataTVC


#pragma mark - Empty List Text

/// Quando a tableview estiver vazia este será o Header apresentado
@property (nonatomic,strong) NSString* emptyListText;


#pragma mark - Loading HUD

/// Set to YES to present a loading HUD while Core Data is fetching the managed objects in background. Default is YES
//@property (nonatomic,assign) BOOL showLoadingHUD;

/// If showLoadingHUD is set to YES you may present a string along with it (i.e. "Loading")
@property (nonatomic,assign) NSString* loadingText;


#pragma mark - Default Cell

/**
 You may want to have a vanila tableview using the default provided tableview cells
 In this case you may use this class withouth subclassing. 
 This won't apply if you override tableView:cellForRowAtIndexPath:object:
 
 Default is UITableViewCellStyleDefault
 */
@property (assign, nonatomic) UITableViewCellStyle cellStyle;

@property (strong, nonatomic) NSString* cellTextLabelKey;
@property (strong, nonatomic) NSString* cellDetailTextLabelKey;
@property (strong, nonatomic) NSString* cellImageKey;


@end





