//
//  NTTableViewController.m
//  CollapsibleTableView
//
//  Created by Navi Singh on 1/20/13.
//  Copyright (c) 2013 Navi Singh. All rights reserved.
//

#import "NTTableViewController.h"
#import "NTTableView.h"
#import "NTSubTableViewController.h"
#import "NTSubTable.h"

@interface NTTableViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *subTableViewControllers;
@property (nonatomic, strong) NTTableView *table;
@property (nonatomic, assign) int selected;
@property (nonatomic, assign) CGFloat headerHeight;
@property (nonatomic, assign) CGFloat unselectedHeight;
@property (nonatomic, assign) CGFloat selectedHeight;
@end

@implementation NTTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        self.wantsFullScreenLayout = YES;
        
        self.headerHeight = 50;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    CGRect frame = self.view.frame;
    //    frame.origin.y = 0; //instead do self.wantsFullScreenLayout = YES; in initWithNibName:bundle
//    NSLog(@"table frame: %f, %f, %f, %f", frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
    self.table = [[NTTableView alloc] initWithFrame:frame];
    self.table.delegate = self;
    self.table.dataSource = self;
    [self.view addSubview:self.table];

    //Set up our view controllers.
    self.unselectedHeight = 40;  //default height for unselected controllers.
    
    NSMutableArray *controllers = [NSMutableArray array];
    controllers[0] = [[NTSubTableViewController alloc] initWithWidth:frame.size.width height:self.unselectedHeight delegate:self];
    controllers[1] = [[NTSubTableViewController alloc] initWithWidth:frame.size.width height:self.unselectedHeight delegate:self];
    controllers[2] = [[NTSubTableViewController alloc] initWithWidth:frame.size.width height:self.unselectedHeight delegate:self];
    controllers[3] = [[NTSubTableViewController alloc] initWithWidth:frame.size.width height:self.unselectedHeight delegate:self];
    controllers[4] = [[NTSubTableViewController alloc] initWithWidth:frame.size.width height:self.unselectedHeight delegate:self];
    
    self.selectedHeight = self.table.frame.size.height - (controllers.count - 1) * self.unselectedHeight;// - self.headerHeight;

    self.selected = 0;
    for (int n=0; n < controllers.count; n++) {
        NTSubTableViewController *vc = controllers[n];
        vc.headerLabel = [NSString stringWithFormat:@"Section %d", n];
        vc.tableViewCell.tag = n;
        if (n == self.selected)
            [vc select:self.selectedHeight];
        else
            [vc unselect];
    }

    self.subTableViewControllers = controllers;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return self.headerHeight; //only this height matters.
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    //return nil;
//    UIView *customSectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)]; //this height is irrelevant
//    customSectionHeaderView.backgroundColor = [UIColor redColor];
//    return customSectionHeaderView;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.subTableViewControllers.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{//only this height matters.
    if(indexPath.row == self.selected)
        return self.selectedHeight;
    return self.unselectedHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NTSubTableViewController *vc = self.subTableViewControllers[indexPath.row];
    return vc.tableViewCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// Deselect cell
	[tableView deselectRowAtIndexPath:indexPath animated:TRUE];
    
    
    NTSubTableViewController *vcUnselect = self.subTableViewControllers[self.selected];
    [vcUnselect unselect];

    self.selected = indexPath.row;
    NTSubTableViewController *vcSelect = self.subTableViewControllers[self.selected];
    [vcSelect select:self.selectedHeight];
	
	// This is where magic happens...
	[self.table beginUpdates];
	[self.table endUpdates];
}

- (void) setTouchedHeaderForController:(UIViewController *)controller
{
    for (int n = 0; n < self.subTableViewControllers.count; n++) {
        if (controller == self.subTableViewControllers[n]) {
            if (self.selected != n) {
                NTSubTableViewController *vcUnselect = self.subTableViewControllers[self.selected];
                [vcUnselect unselect];
                self.selected  = n;
                NTSubTableViewController *vcSelect = self.subTableViewControllers[self.selected];
                [vcSelect select:self.selectedHeight];
                // This is where magic happens...
                [self.table beginUpdates];
                [self.table endUpdates];
            };
        }
    }
}
@end
