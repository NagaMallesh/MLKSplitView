//
//  MLKMenuListViewController.m
//  MLKSplitView
//
//  Created by NagaMalleswar on 16/01/14.
//  Copyright (c) 2014 Nagamalleswar. All rights reserved.
//

#import "MLKMenuListViewController.h"

#define NUMBER_OF_ROWS      4
#define CELL_IDENTIFIER     @"MasterCell"

@implementation MLKMenuListViewController

@synthesize menuListVCDelegate;
@synthesize menuListVCDatasource;

#pragma mark -
#pragma mark UIViewController Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark -
#pragma mark UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = 0;
    
    if( [menuListVCDatasource respondsToSelector:@selector(numberOfMenuItems)] )
    {
        numberOfRows = [menuListVCDatasource numberOfMenuItems];
    }
    
    return numberOfRows;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *masterCell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
    
    if( !masterCell )
    {
        masterCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFIER];
        
        if( [menuListVCDatasource respondsToSelector:@selector(menuListView:titleForMenuItemAtIndex:)] )
        {
            masterCell.textLabel.text = [menuListVCDatasource menuListView:self titleForMenuItemAtIndex:indexPath.row];
        }
    }
    
    return masterCell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if( [menuListVCDelegate respondsToSelector:@selector(menuListView:didSelectMenuItemAtIndex:)] )
    {
        [menuListVCDelegate menuListView:self didSelectMenuItemAtIndex:indexPath.row];
    }
}

@end
