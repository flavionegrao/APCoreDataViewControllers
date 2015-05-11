//
//  APEmptyDataSource.m
//  Pods
//
//  Created by Flavio Negrão Torres on 15/09/14.
//
//

#import "APPlaceHolderDataSource.h"

#import "APPlaceHolderCell.h"

@interface APPlaceHolderDataSource()


@end


@implementation APPlaceHolderDataSource

- (instancetype)initWithPlaceHolerText:(NSString *)text {
    self = [super init];
    if (self) {
        _placeHolderText = text;
    }
    return self;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == 0) {
        UITableViewCell* cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        return cell;
    } else {
        APPlaceHolderCell* cell = [[APPlaceHolderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.placeHolderText = self.placeHolderText;
        cell.showActivityIndicator = self.showActivityIndicator;
        return cell;
    }
}

- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

@end
