//
//  CustomTableViewCell.h
//  APCoreDataViewControllersExample
//
//  Created by Flavio Negrão Torres on 5/21/14.
//  Copyright (c) 2014 Flavio Negrão Torres. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *mainLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@end
