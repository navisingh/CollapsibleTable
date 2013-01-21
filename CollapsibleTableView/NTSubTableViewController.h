//
//  NTSubTableViewController.h
//  CollapsibleTableView
//
//  Created by Navi Singh on 1/20/13.
//  Copyright (c) 2013 Navi Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NTSubTable;
@class NTTableViewController;
@interface NTSubTableViewController : UIViewController
@property (nonatomic, strong) NTSubTable *tableViewCell;
@property (nonatomic, strong) NSString *headerLabel;

- (void) select:(CGFloat)height;
- (void) unselect;
- (id) initWithWidth:(CGFloat)width height:(CGFloat)height delegate:(NTTableViewController *)delegate;

@end
