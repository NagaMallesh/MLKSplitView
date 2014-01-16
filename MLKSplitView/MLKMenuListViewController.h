//
//  MLKMenuListViewController.h
//  MLKSplitView
//
//  Created by NagaMalleswar on 16/01/14.
//  Copyright (c) 2014 Nagamalleswar. All rights reserved.
//

#import "MLKViewController.h"

@class MLKMenuListViewController;

@protocol MLKMenuListVCDatasource <NSObject>

- (NSInteger)numberOfMenuItems;
- (NSString *)menuListView:(MLKMenuListViewController *)menuListVC titleForMenuItemAtIndex:(NSInteger)row;

@end

@protocol MLKMenuListVCDelegate <NSObject>

- (void)menuListView:(MLKMenuListViewController *)menuListVC didSelectMenuItemAtIndex:(NSInteger)row;

@end

@interface MLKMenuListViewController : MLKViewController

@property(nonatomic,assign) id<MLKMenuListVCDelegate> menuListVCDelegate;
@property(nonatomic,assign) id<MLKMenuListVCDatasource> menuListVCDatasource;

@end
