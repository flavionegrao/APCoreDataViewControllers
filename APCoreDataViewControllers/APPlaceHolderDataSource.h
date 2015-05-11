//
//  APEmptyDataSource.h
//  Pods
//
//  Created by Flavio Negrão Torres on 15/09/14.
//
//

@import UIKit;

@interface APPlaceHolderDataSource : NSObject <UITableViewDataSource>

- (instancetype) initWithPlaceHolerText:(NSString*) text;

@property (nonatomic, copy) NSString* placeHolderText;
@property (nonatomic, assign) BOOL showActivityIndicator;

@end
