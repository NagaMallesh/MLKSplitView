//
//  MLKSplitViewController.h
//  MLKSplitView
//
//  Created by NagaMalleswar on 16/01/14.
//  Copyright (c) 2014 Nagamalleswar. All rights reserved.
//

#import "MLKViewController.h"
#import "MLKMenuListViewController.h"

@interface MLKSplitViewController : MLKViewController <MLKMenuListVCDelegate,MLKMenuListVCDatasource>

- (id)initWithViewMenuListViewController:(MLKMenuListViewController *)listVC
                andDetailViewControllers:(NSArray *)splitViewControllers;

@end
