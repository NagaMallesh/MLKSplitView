//
//  MLKSplitViewController.m
//  MLKSplitView
//
//  Created by NagaMalleswar on 16/01/14.
//  Copyright (c) 2014 Nagamalleswar. All rights reserved.
//

#import "MLKSplitViewController.h"

#define MASTER_VIEW_WIDTH           300
#define SPLIT_GAP                   1.5

#define DETAIL_VIEW_FRAME_SHRINKED  CGRectMake(0,0, MASTER_VIEW_WIDTH, self.view.bounds.size.height) detailViewFrame:CGRectMake(MASTER_VIEW_WIDTH + SPLIT_GAP, 0, self.view.bounds.size.width - MASTER_VIEW_WIDTH - SPLIT_GAP, self.view.bounds.size.height)
#define DETAIL_VIEW_FRAME_EXPANDED  CGRectMake(-MASTER_VIEW_WIDTH,0, MASTER_VIEW_WIDTH, self.view.bounds.size.height) detailViewFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)

#define MENU_BUTTON_FRAME           CGRectMake(0, 0, 20, 20)
#define MENU_IMAGE                  @"Menu.png"

#define FIRST_VC            @"First View Controller"
#define SECOND_VC           @"Second View Controller"
#define THIRD_VC            @"Third View Controller"
#define FOURTH_VC           @"Fourth View Controller"

@interface MLKSplitViewController ()

@property(nonatomic,retain) NSMutableArray *viewControllers;
@property(nonatomic,retain) UISwipeGestureRecognizer *leftSwipeGestureRecognizer;
@property(nonatomic,retain) UISwipeGestureRecognizer *rightSwipeGestureRecognizer;

@property(nonatomic,assign) BOOL isMasterViewHidden;
@property(nonatomic,retain) MLKViewController *selectedMenuVC;
@property(nonatomic,retain) MLKMenuListViewController *menuListVC;

@end

@implementation MLKSplitViewController

@synthesize viewControllers;
@synthesize leftSwipeGestureRecognizer;
@synthesize rightSwipeGestureRecognizer;

@synthesize isMasterViewHidden;
@synthesize selectedMenuVC;
@synthesize menuListVC;

- (id)initWithViewMenuListViewController:(MLKMenuListViewController *)listVC
                andDetailViewControllers:(NSArray *)splitViewControllers
{
    self = [super init];
    
    if (self)
	{
        self.menuListVC = listVC;
		self.viewControllers = [splitViewControllers mutableCopy];
    }
    
    return self;
}

#pragma mark -
#pragma mark View Life Cycle

- (void)loadView
{
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor blackColor];
    
    if( self.viewControllers.count > 0 )
    {
        // Add Master View
        menuListVC.menuListVCDatasource = self;
        menuListVC.menuListVCDelegate = self;
        [self.view addSubview:menuListVC.view];
        
        // Add initial detail view
        selectedMenuVC = [self.viewControllers objectAtIndex:0];
        [self.view addSubview:selectedMenuVC.view];
        [self setupMenuOptionButton];
    }
}

- (void)viewDidLoad
{
	[super viewDidLoad];
    
    // Add left gesture recognizer
    self.leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hideMasterView:)];
    [self.leftSwipeGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:leftSwipeGestureRecognizer];
    
    // Add right gesture recognizer
    self.rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showMasterView:)];
    [self.rightSwipeGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:rightSwipeGestureRecognizer];
    
    // Hide Navigation Bar
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
    
	for (UIViewController *viewController in self.viewControllers)
	{
		[viewController viewDidAppear:animated];
	}
    
	[self layoutSubviews];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    
	for (UIViewController *viewController in self.viewControllers)
	{
		[viewController viewWillAppear:animated];
	}
}

#pragma mark -
#pragma mark UI Orientation

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	for (UIViewController *viewController in self.viewControllers)
	{
		[viewController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
	}
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    for (UIViewController *viewController in self.viewControllers)
	{
		[viewController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
	}
}

- (void)willAnimateRotationToInterfaceOrientation: (UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
{
	[super willAnimateRotationToInterfaceOrientation:interfaceOrientation duration:duration];
    [self layoutSubviews];
}

- (void)layoutSubviews
{
    if( !isMasterViewHidden )
    {
        [self setMasterViewFrame:DETAIL_VIEW_FRAME_SHRINKED];
    }
}

#pragma mark -
#pragma mark Gesture Actions

- (IBAction)hideMasterView:(id)sender
{
    if( !isMasterViewHidden )
    {
        [UIView animateWithDuration:1.0 animations:^{
            
            [self setMasterViewFrame:DETAIL_VIEW_FRAME_EXPANDED];
        }];
        
        isMasterViewHidden = YES;
    }
    
}

- (IBAction)showMasterView:(id)sender
{
    if( isMasterViewHidden )
    {
        [UIView animateWithDuration:1.0 animations:^{
            
            [self setMasterViewFrame:DETAIL_VIEW_FRAME_SHRINKED];
        }];
        
        isMasterViewHidden = NO;
    }
}

#pragma mark -
#pragma mark MLKMenuListVCDatasource

- (NSInteger)numberOfMenuItems
{
    return self.viewControllers.count;
}

- (NSString *)menuListView:(MLKMenuListViewController *)menuListVC titleForMenuItemAtIndex:(NSInteger)row
{
    NSString *menuTitle = nil;
    
    switch (row)
    {
        case 0:
            menuTitle = FIRST_VC;
            break;
            
        case 1:
            menuTitle = SECOND_VC;
            break;
            
        case 2:
            menuTitle = THIRD_VC;
            break;
            
        case 3:
            menuTitle = FOURTH_VC;
            break;
    }
    
    return menuTitle;
}

#pragma mark -
#pragma mark MLKMenuListVCDelegate

- (void)menuListView:(MLKMenuListViewController *)menuListVC didSelectMenuItemAtIndex:(NSInteger)row
{
    CGRect detailViewFrame = selectedMenuVC.view.frame;
    [selectedMenuVC.view removeFromSuperview];
    
    selectedMenuVC = [self.viewControllers objectAtIndex:row];
    selectedMenuVC.view.frame = detailViewFrame;
    
    [self setupMenuOptionButton];
    
    [self.view addSubview:selectedMenuVC.view];
}

#pragma mark -
#pragma mark Methods

- (void)setMasterViewFrame:(CGRect)masterViewFrame detailViewFrame:(CGRect)detailViewFrame
{
    menuListVC.view.frame = masterViewFrame;
    selectedMenuVC.view.frame = detailViewFrame;
}

- (void)showOrHideMenu
{
    if( isMasterViewHidden )
    {
        [self showMasterView:nil];
    }
    else
    {
        [self hideMasterView:nil];
    }
}

- (void)setupMenuOptionButton
{
    if( !selectedMenuVC.mlkNavigationItem.leftBarButtonItem )
    {
        UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        menuButton.frame = MENU_BUTTON_FRAME;
        [menuButton setBackgroundImage:[UIImage imageNamed:MENU_IMAGE] forState:UIControlStateNormal];
        [menuButton addTarget:self action:@selector(showOrHideMenu) forControlEvents:UIControlEventTouchUpInside];
        
        selectedMenuVC.mlkNavigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    }
}

@end
