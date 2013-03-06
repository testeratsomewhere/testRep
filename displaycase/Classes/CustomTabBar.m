//
//  RumexCustomTabBar.m
//  
//

#import "CustomTabBar.h"

@implementation CustomTabBar

@synthesize btnDisplays, btnActivity, btnSearch, btnSettings;
@synthesize imgTab, tabView;
@synthesize imgBg;

- (void)viewDidAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
    [self hideOriginalTabBar];
	[self addCustomElements];
    
	appDelegate = (displaycaseAppDelegate *) [UIApplication sharedApplication].delegate;
}

- (void)hideTabBar
{
	self.imgTab.hidden = YES;
	self.btnDisplays.hidden = YES;
	self.btnActivity.hidden = YES;
	self.btnSearch.hidden = YES;
	self.btnSettings.hidden = YES;
	self.imgBg.hidden = YES;
    
    self.btnDisplays.userInteractionEnabled=NO;
    self.btnActivity.userInteractionEnabled=NO;
    self.btnSearch.userInteractionEnabled=NO;
    self.btnSettings.userInteractionEnabled=NO;
    
}

- (void)showTabBar
{
	self.imgTab.hidden = NO;
	self.btnDisplays.hidden = NO;
	self.btnActivity.hidden = NO;
	self.btnSearch.hidden = NO;
	self.btnSettings.hidden = NO;
	self.imgBg.hidden = NO;
    
    self.btnDisplays.userInteractionEnabled=YES;
    self.btnActivity.userInteractionEnabled=YES;
    self.btnSearch.userInteractionEnabled=YES;
    self.btnSettings.userInteractionEnabled=YES;
    
}

- (void)hideOriginalTabBar
{
	for(UIView *view in self.view.subviews)
	{
		if([view isKindOfClass:[UITabBar class]])
		{
			view.hidden = YES;
			break;
		}
	}
}

-(void)addCustomElements
{

	imgTab = [[UIImageView alloc]initWithFrame:CGRectMake(0, 424, 320.0,56)];
    imgTab.image=[UIImage imageNamed:@"tab_bar_bg.png"];
	[self.view addSubview:imgTab];
	
	UIImage *btnImage = [UIImage imageNamed:@"tab_bar_icon_display_list_off.png"];
	UIImage *btnImageSelected = [UIImage imageNamed:@"tab_bar_icon_display_list_on.png"];
	  
    //Displays Button Custom Code
	btnDisplays = [UIButton buttonWithType:UIButtonTypeCustom]; //Setup the button
	btnDisplays.frame = CGRectMake(0, 430, 80, 50);
	
	[btnDisplays setTitle:@"Displays" forState:UIControlStateNormal];
	[btnDisplays setTitleColor:[UIColor colorWithRed:85/255.0f green:65/255.0f blue:40/255.0f alpha:1.0f] forState:UIControlStateNormal];
	[btnDisplays setTitleColor:[UIColor colorWithRed:255/255.0f green:243/255.0f blue:215/255.0f alpha:1.0f] forState:UIControlStateSelected];
	[btnDisplays.titleLabel setFont:[UIFont boldSystemFontOfSize:10.0]];
	[btnDisplays setTitleEdgeInsets:UIEdgeInsetsMake(5.0, -btnImage.size.width, -25.0, 0.0)];
	[btnDisplays setImage:btnImage forState:UIControlStateNormal];
	[btnDisplays setImageEdgeInsets:UIEdgeInsetsMake(-12.0, 0.0, 0.0, -36.0)];
	[btnDisplays setImage:btnImageSelected forState:UIControlStateSelected];
	[btnDisplays setTag:0]; // Assign the button a "tag" so when our "click" event is called we know which button was pressed.
	[btnDisplays setSelected:true]; // Set this button as selected (we will select the others to false as we only want Tab 1 to be selected initially
	
	[imgBg removeFromSuperview];
	imgBg = [[UIImageView alloc]initWithFrame:CGRectMake(15, 433, 48, 44)];
	imgBg.image=[UIImage imageNamed:@"tab_bar_highlight.png"];
	imgBg.backgroundColor = [UIColor clearColor];
	[self.view addSubview:imgBg];
	[self.view bringSubviewToFront:btnDisplays];
	
	// Now we repeat the process for the other buttons
	btnImage = [UIImage imageNamed:@"tab_bar_icon_activity_off.png"];
	btnImageSelected = [UIImage imageNamed:@"tab_bar_icon_activity_on.png"];
	
    
    //Activity Button Custom Code

    btnActivity = [UIButton buttonWithType:UIButtonTypeCustom];
	btnActivity.frame = CGRectMake(81, 430, 80, 50);
	
	[btnActivity setTitle:@"Activity" forState:UIControlStateNormal];
	[btnActivity setTitleColor:[UIColor colorWithRed:85/255.0f green:65/255.0f blue:40/255.0f alpha:1.0f] forState:UIControlStateNormal];
	[btnActivity setTitleColor:[UIColor colorWithRed:255/255.0f green:243/255.0f blue:215/255.0f alpha:1.0f] forState:UIControlStateSelected];
	[btnActivity.titleLabel setFont:[UIFont boldSystemFontOfSize:10.0]];
	[btnActivity setTitleEdgeInsets:UIEdgeInsetsMake(5.0, -btnImage.size.width, -25.0, 0.0)];
	[btnActivity setImage:btnImage forState:UIControlStateNormal];
	[btnActivity setImage:btnImageSelected forState:UIControlStateSelected];
	[btnActivity setImageEdgeInsets:UIEdgeInsetsMake(-12.0, 0.0, 0.0, -30.0)];
	[btnActivity setTag:1];
	
	btnImage = [UIImage imageNamed:@"tab_bar_icon_search_off.png"];
	btnImageSelected = [UIImage imageNamed:@"tab_bar_icon_search_on.png"];
	
    //Search Button Custom Code

    btnSearch = [UIButton buttonWithType:UIButtonTypeCustom];
	btnSearch.frame = CGRectMake(161, 430, 80, 50);
	[btnSearch setTitle:@"Search" forState:UIControlStateNormal];
	[btnSearch setTitleColor:[UIColor colorWithRed:85/255.0f green:65/255.0f blue:40/255.0f alpha:1.0f] forState:UIControlStateNormal];
	[btnSearch setTitleColor:[UIColor colorWithRed:255/255.0f green:243/255.0f blue:215/255.0f alpha:1.0f] forState:UIControlStateSelected];
	[btnSearch.titleLabel setFont:[UIFont boldSystemFontOfSize:10.0]];
	[btnSearch setTitleEdgeInsets:UIEdgeInsetsMake(5.0, -btnImage.size.width, -25.0, 0.0)];
	[btnSearch setImage:btnImage forState:UIControlStateNormal];
	[btnSearch setImage:btnImageSelected forState:UIControlStateSelected];
	[btnSearch setImageEdgeInsets:UIEdgeInsetsMake(-12.0, 0.0, 0.0, -30.0)];
	[btnSearch setTag:2];
	
	btnImage = [UIImage imageNamed:@"tab_bar_icon_settings_off.png"];
	btnImageSelected = [UIImage imageNamed:@"tab_bar_icon_settings_on.png"];
	
    //Settings Button Custom Code

    btnSettings = [UIButton buttonWithType:UIButtonTypeCustom];
	btnSettings.frame = CGRectMake(241, 430, 80, 50);
	[btnSettings setTitle:@"Settings" forState:UIControlStateNormal];
	[btnSettings setTitleColor:[UIColor colorWithRed:85/255.0f green:65/255.0f blue:40/255.0f alpha:1.0f] forState:UIControlStateNormal];
	[btnSettings setTitleColor:[UIColor colorWithRed:255/255.0f green:243/255.0f blue:215/255.0f alpha:1.0f] forState:UIControlStateSelected];
	[btnSettings.titleLabel setFont:[UIFont boldSystemFontOfSize:10.0]];
	[btnSettings setTitleEdgeInsets:UIEdgeInsetsMake(5.0, -btnImage.size.width, -25.0, 0.0)];
	[btnSettings setImage:btnImage forState:UIControlStateNormal];
	[btnSettings setImage:btnImageSelected forState:UIControlStateSelected];
	[btnSettings setImageEdgeInsets:UIEdgeInsetsMake(-12.0, 0.0, 0.0, -30.0)];
	[btnSettings setTag:3];
	
	[self.view addSubview:btnDisplays];
	[self.view addSubview:btnActivity];
	[self.view addSubview:btnSearch];
	[self.view addSubview:btnSettings];

	// Setup event handlers so that the buttonClicked method will respond to the touch up inside event.
	[btnDisplays addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
	[btnActivity addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
	[btnSearch addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
	[btnSettings addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
	
}

- (void)buttonClicked:(id)sender
{
	int tagNum = [sender tag];
	[self selectTab:tagNum];
}

- (void)selectTab:(int)tabID
{
	switch(tabID)
	{
		case 0:
			
			[imgBg removeFromSuperview];
			imgBg = [[UIImageView alloc]initWithFrame:CGRectMake(15, 433, 48, 44)];
			imgBg.image=[UIImage imageNamed:@"tab_bar_highlight.png"];
			imgBg.backgroundColor = [UIColor clearColor];
			[self.view addSubview:imgBg];
			[self.view bringSubviewToFront:btnDisplays];
			[btnDisplays setSelected:true];
			[btnActivity setSelected:false];
			[btnSearch setSelected:false];
			[btnSettings setSelected:false];
			break;
		case 1:
			[imgBg removeFromSuperview];
			imgBg = [[UIImageView alloc]initWithFrame:CGRectMake(95, 433, 48, 44)];
			imgBg.image=[UIImage imageNamed:@"tab_bar_highlight.png"];
			imgBg.backgroundColor = [UIColor clearColor];
			[self.view addSubview:imgBg];
			[self.view bringSubviewToFront:btnActivity];
			[btnDisplays setSelected:false];
			[btnActivity setSelected:true];
			[btnSearch setSelected:false];
			[btnSettings setSelected:false];
			break;
		case 2:
			[imgBg removeFromSuperview];
			imgBg = [[UIImageView alloc]initWithFrame:CGRectMake(175, 433, 48, 44)];
			imgBg.image=[UIImage imageNamed:@"tab_bar_highlight.png"];
			imgBg.backgroundColor = [UIColor clearColor];
			[self.view addSubview:imgBg];
			[self.view bringSubviewToFront:btnSearch];
			[btnDisplays setSelected:false];
			[btnActivity setSelected:false];
			[btnSearch setSelected:true];
			[btnSettings setSelected:false];
			break;
		case 3:
			[imgBg removeFromSuperview];
			imgBg = [[UIImageView alloc]initWithFrame:CGRectMake(255, 433, 48, 44)];
			imgBg.image=[UIImage imageNamed:@"tab_bar_highlight.png"];
			imgBg.backgroundColor = [UIColor clearColor];
			[self.view addSubview:imgBg];
			[self.view bringSubviewToFront:btnSettings];
			[btnDisplays setSelected:false];
			[btnActivity setSelected:false];
			[btnSearch setSelected:false];
			[btnSettings setSelected:true];
			break;
	}	
	
	self.selectedIndex = tabID;
	if (self.selectedIndex == tabID) 
	{
		UINavigationController *navController = (UINavigationController *)[self selectedViewController];
		[navController popToRootViewControllerAnimated:NO];
	} 
	else 
	{
		self.selectedIndex = tabID;
	}
	
}

- (void)dealloc 
{
	[btnDisplays release];
	[btnActivity release];
	[btnSearch release];
	[btnSettings release];
    [super dealloc];
	
}

@end
