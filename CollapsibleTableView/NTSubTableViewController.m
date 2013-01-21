//
//  NTSubTableViewController.m
//  CollapsibleTableView
//
//  Created by Navi Singh on 1/20/13.
//  Copyright (c) 2013 Navi Singh. All rights reserved.
//

#import "NTSubTableViewController.h"
#import "NTTableViewController.h"

@interface NTSubTableViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, weak) NTTableViewController *delegate;
@property (nonatomic, assign) CGFloat headerHeight;
@property (nonatomic, strong) UIToolbar *headerView;
@end

@implementation NTSubTableViewController

- (id) initWithWidth:(CGFloat)width height:(CGFloat)height delegate:(NTTableViewController *)delegate
{
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        self.wantsFullScreenLayout = YES;
        
        self.headerHeight = height;
        self.delegate = delegate;
        
        self.tableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"row"];
        self.tableViewCell.frame = CGRectMake(0, 0, width, height); 
        [self.view addSubview:self.tableViewCell];
        
        CGRect frame = self.tableViewCell.frame;
        //    frame.origin.y = 0; //instead do self.wantsFullScreenLayout = YES; in initWithNibName:bundle
//        NSLog(@"subtable frame: %f, %f, %f, %f", frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
        self.table = [[UITableView alloc] initWithFrame:frame];
        self.table.delegate = self;
        self.table.dataSource = self;
        [self.tableViewCell addSubview:self.table];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

//    CGRect frame = self.tableViewCell.frame;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) select:(CGFloat)height
{
    CGRect frame = CGRectMake(0, 0, self.tableViewCell.frame.size.width, height);
    self.tableViewCell.frame = frame;
    self.table.frame = frame;
    NSLog(@"subtable frame: %f, %f, %f, %f", frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);

    int indicatorIcon = 104;// http://alsalom.wordpress.com/2012/03/02/uibarbuttonitem-apples-documented-and-undocumented-system-buttons/
    UIBarButtonItem *indicatorButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:indicatorIcon target:nil action:nil];
    UIBarButtonItem *label = [[UIBarButtonItem alloc] initWithTitle: self.headerLabel style:UIBarButtonItemStylePlain target:nil action:nil];
    
    NSArray *items = [NSArray arrayWithObjects:indicatorButton, label, nil];
    [self.headerView setItems:items animated:NO];
    [self.headerView sizeToFit];
}

- (void) unselect
{
    CGRect frame = CGRectMake(0, 0, self.tableViewCell.frame.size.width, self.headerHeight);
    self.tableViewCell.frame = frame;
    self.table.frame = frame;
    NSLog(@"subtable frame: %f, %f, %f, %f", frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);

    int indicatorIcon = 102;// http://alsalom.wordpress.com/2012/03/02/uibarbuttonitem-apples-documented-and-undocumented-system-buttons/
    UIBarButtonItem *indicatorButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:indicatorIcon target:nil action:nil];
    UIBarButtonItem *label = [[UIBarButtonItem alloc] initWithTitle: self.headerLabel style:UIBarButtonItemStylePlain target:nil action:nil];
    
    NSArray *items = [NSArray arrayWithObjects:indicatorButton, label, nil];
    [self.headerView setItems:items animated:NO];
    [self.headerView sizeToFit];
}

- (UIToolbar *) headerView
{
    if (_headerView == nil) {
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 200, self.headerHeight)];
        UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTouchHeader:)];
        [toolbar addGestureRecognizer:singleFingerTap];
        
        int indicatorIcon = 104;// http://alsalom.wordpress.com/2012/03/02/uibarbuttonitem-apples-documented-and-undocumented-system-buttons/        
        UIBarButtonItem *indicatorButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:indicatorIcon target:nil action:nil];
        UIBarButtonItem *label = [[UIBarButtonItem alloc] initWithTitle: self.headerLabel style:UIBarButtonItemStylePlain target:nil action:nil];
        
        NSArray *items = [NSArray arrayWithObjects:indicatorButton, label, nil];
        [toolbar setItems:items animated:NO];
        [toolbar sizeToFit];
        _headerView = toolbar;
    }
    return _headerView;
}

- (void) didTouchHeader:(id)sender
{
    [self.delegate setTouchedHeaderForController:self];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.headerHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 30; //only this height matters.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell           = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"blah %d %d", self.tableViewCell.tag, indexPath.row];
    return cell;
}


@end
