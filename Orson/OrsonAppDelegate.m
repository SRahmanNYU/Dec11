//
//  OrsonAppDelegate.m
//  Orson
//
//  Created by NYU User on 12/2/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>
#import "OrsonAppDelegate.h"

@implementation OrsonAppDelegate
@synthesize window = _window;

- (BOOL) application: (UIApplication *) application didFinishLaunchingWithOptions: (NSDictionary *) launchOptions
{
	UIScreen *screen = [UIScreen mainScreen];
	self.window = [[UIWindow alloc] initWithFrame: screen.bounds];
	// Override point for customization after application launch.

	NSBundle *bundle = [NSBundle mainBundle];
	videoUrl = [NSURL fileURLWithPath: [bundle pathForResource: @"OprahShow" ofType: @"mov"]];

	NSArray *controllers = [NSArray arrayWithObjects:
		[[UIViewController alloc] initWithNibName: nil bundle: nil],        //"Profile"
		[[UIViewController alloc] initWithNibName: nil bundle: nil],        //"Theme"
		[[MPMoviePlayerViewController alloc] initWithContentURL: videoUrl], //"Video"
		[[UIViewController alloc] initWithNibName: nil bundle: nil],        //"Theme"
		[[UIViewController alloc] initWithNibName: nil bundle: nil],        //"Web"
		nil
	];

    UIViewController *viewController = [controllers objectAtIndex: 0];
	//The first view is a UITextView.
    viewController.title = @"Profile";
	viewController.tabBarItem.image = [UIImage imageNamed: @"Profile.png"];
	viewController.view = [[UITextView alloc] initWithFrame: screen.applicationFrame];
	viewController.view.backgroundColor = [UIColor blackColor];
    
	viewController.view = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"Oprah.jpg"]];
	viewController.view.contentMode = UIViewContentModeCenter;
    
    /*
    ((UITextView *)viewController.view).editable = NO;
	((UITextView *)viewController.view).textColor = [UIColor whiteColor];
	((UITextView *)viewController.view).font = [UIFont fontWithName: @"Times New Roman" size: 20];
    
	((UITextView *)viewController.view).text =	//Graham Greene
    @"If you are to understand this strange, rather sad story "
    @"the frost-nipped weeds where the snow was thin.";
    */
    
  	//The second view is a UIImageView.

	viewController = [controllers objectAtIndex: 1];
	viewController.title = @"Theme";
	viewController.tabBarItem.image = [UIImage imageNamed: @"Theme.png"];
    
	NSURL *audioUrl = [NSURL fileURLWithPath: [bundle pathForResource: @"OprahTheme" ofType: @"mp3"]];
	NSError *error = nil;
	audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL: audioUrl error: &error];
	if (audioPlayer == nil) {
		NSLog(@"error == %@", error);
		return YES;
	}
	audioPlayer.numberOfLoops = -1; //infinite
    
	/*
	The third view is not a view at all.  But it has a MPMoviePlayerController.

	"After all, it's not that awful.  But what the fellow says, in Italy for thirty years
	under the Borgias they had warfare, terror, murder, bloodshed, but they produced Michaelangelo,
	Leonardo da Vinci, and the Renaissance.  In Switzerland, they had brotherly love.  They had five
	hundred years of democracy and peace.  And what did that produce?  The cuckoo clock."
	*/

	viewController = [controllers objectAtIndex: 2];
	viewController.title = @"Show";
	viewController.tabBarItem.image = [UIImage imageNamed: @"Video.png"];

	((MPMoviePlayerViewController *)viewController).moviePlayer.shouldAutoplay = NO;
	((MPMoviePlayerViewController *)viewController).moviePlayer.initialPlaybackTime = 3.27;
	[((MPMoviePlayerViewController *)viewController).moviePlayer prepareToPlay];

	

	//The fifth view is a UIWebView.  The m. in the url stands for "mobile".

	viewController = [controllers objectAtIndex: 3];
	viewController.tabBarItem.image = [UIImage imageNamed: @"Location-Pointer.png"];
	viewController.title = @"Twitter";
	UIWebView *webView = [[UIWebView alloc] initWithFrame: screen.applicationFrame];
	viewController.view = webView;
	webView.scalesPageToFit = YES;

	NSURL *webUrl = [NSURL URLWithString: @"https://twitter.com/Oprah"];
	NSData *data = [NSData dataWithContentsOfURL: webUrl];
	
	if (data == nil) {
		NSLog(@"could not load URL %@", webUrl);
		return YES;
	}
    
    	[webView loadData: data MIMEType: @"text/html" textEncodingName: @"NSUTF8StringEncoding" baseURL: webUrl];
    
    //There is no fourth view.  But there is a fourth view controller.  Its view property is nil.
	
	viewController = [controllers objectAtIndex: 4];
	viewController.title = @"More";
	viewController.tabBarItem.image = [UIImage imageNamed: @"triRight.png"];
	viewController.view = [[UITextView alloc] initWithFrame: screen.applicationFrame];
	viewController.view.backgroundColor = [UIColor blackColor];
    
    ((UITextView *)viewController.view).editable = NO;
	((UITextView *)viewController.view).textColor = [UIColor whiteColor];
	((UITextView *)viewController.view).font = [UIFont fontWithName: @"Times New Roman" size: 40];
    
	((UITextView *)viewController.view).text =	//Graham Greene
    @"STAY TUNED...MORE ON OPRAH "
    @"COMING SOON!!!";


	UITabBarController *tabBarController = [[UITabBarController alloc] init];
	self.window.rootViewController = tabBarController;
	tabBarController.viewControllers = controllers;
	tabBarController.delegate = self;
	last = ((UIViewController *)[tabBarController.viewControllers objectAtIndex: 0]).title;
	[self.window makeKeyAndVisible];
	return YES;
}


- (void) applicationWillResignActive: (UIApplication *) application
{
	/*
	 Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	 Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	 */
}

- (void) applicationDidEnterBackground: (UIApplication *) application
{
	/*
	 Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	 If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	 */
}

- (void) applicationWillEnterForeground: (UIApplication *) application
{
	/*
	 Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	 */
}

- (void) applicationDidBecomeActive: (UIApplication *) application
{
	/*
	 Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	 */
}

- (void) applicationWillTerminate: (UIApplication *) application
{
	/*
	 Called when the application is about to terminate.
	 Save data if appropriate.
	 See also applicationDidEnterBackground:.
	 */
}

#pragma mark -
#pragma mark Protocol UITabBarControllerDelegate

- (void) tabBarController: (UITabBarController *)
	tabBarController didSelectViewController: (UIViewController *) viewController {

	if ([last isEqualToString: @"Video"] && ![viewController.title isEqualToString: @"Video"]) {
		//We are leaving the Video tab.

		MPMoviePlayerViewController *moviePlayerViewController =
			[tabBarController.viewControllers objectAtIndex: 2];

		MPMoviePlayerController *moviePlayerController = moviePlayerViewController.moviePlayer;
		NSTimeInterval currentPlaybackTime = moviePlayerController.currentPlaybackTime;
		moviePlayerController.contentURL = videoUrl;
		moviePlayerController.initialPlaybackTime = currentPlaybackTime;
		[moviePlayerController prepareToPlay];
	}

	if ([viewController.title isEqualToString: @"Theme"]) {
		//We are arriving at the Audio tab.
		[audioPlayer play];
	} else if ([last isEqualToString: @"Theme"]) {
		//We are leaving the Audio tab.
		[audioPlayer pause];
	}

	last = viewController.title;
}


@end
