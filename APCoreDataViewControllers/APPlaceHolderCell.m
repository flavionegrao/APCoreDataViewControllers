//
//  APEmptyCell.m
//  Pods
//
//  Created by Flavio Negrão Torres on 15/09/14.
//
//

#import "APPlaceHolderCell.h"

@interface APPlaceHolderCell()

@property (nonatomic, strong) UILabel* placeholderLabel;
@property (nonatomic, strong) UIActivityIndicatorView* activityIndicator;

@end


@implementation APPlaceHolderCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _showActivityIndicator = NO;
        [self configCell];
    }
    return self;
}

- (void) configCell {
    
    [self addSubview:self.placeholderLabel];
    [self addSubview:self.activityIndicator];
    
    NSDictionary* views = @{@"label":self.placeholderLabel,
                            @"activityIndicator":self.activityIndicator};
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[activityIndicator]-[label]"
                                                                 options:0 metrics:nil views:views]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.placeholderLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:1]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.placeholderLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:1]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.activityIndicator attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:1]];
    
}

- (UILabel*) placeholderLabel {
    if (!_placeholderLabel) {
        _placeholderLabel = [UILabel new];
        _placeholderLabel.textColor = [UIColor lightGrayColor];
        _placeholderLabel.text = self.placeHolderText;
        _placeholderLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _placeholderLabel;
}

- (UIActivityIndicatorView*) activityIndicator {
    if (!_activityIndicator) {
        
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityIndicator.hidesWhenStopped = YES;
        _activityIndicator.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _activityIndicator;
}

- (void) setPlaceHolderText:(NSString *)loadingText {
    _placeHolderText = loadingText;
    self.placeholderLabel.text = loadingText;
}

- (void) setShowActivityIndicator:(BOOL)showActivityIndicator {
    if (showActivityIndicator) {
        [self.activityIndicator startAnimating];
    } else {
        [self.activityIndicator stopAnimating];
    }
}

@end
