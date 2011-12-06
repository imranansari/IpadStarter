//
//  DetailViewController.m
//  IpadStarter
//
//  Created by Imran Ansari on 11/25/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController.h"

#import "JSBridgeWebView.h"

#import "SBJson.h"

@interface DetailViewController ()
@property(strong, nonatomic) UIPopoverController *masterPopoverController;

- (void)configureView;
@end

@implementation DetailViewController

@synthesize detailItem = _detailItem;
@synthesize detailDescriptionLabel = _detailDescriptionLabel;
@synthesize masterPopoverController = _masterPopoverController;

- (void)dealloc {
    [_detailItem release];
    [_detailDescriptionLabel release];
    [_masterPopoverController release];
    [super dealloc];
}

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        [_detailItem release];
        _detailItem = [newDetailItem retain];

        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }
}

-(void) loadMaskPage
{	
	//NSURL* url = [[NSBundle mainBundle] URLForResource:@"masks" withExtension:@"html"];
    //[webView loadRequest:[NSURLRequest requestWithURL:@"http://www.google.com"]];
    
    NSString *urlAddress = @"http://localhost:4567/form";
    NSURL *url = [NSURL URLWithString:urlAddress];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [webView loadRequest:requestObj];
    
}

- (void)configureView {
    // Update the user interface for the detail item.

    //webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    webView = [[JSBridgeWebView alloc] initWithFrame:self.view.bounds];
    [webView setDelegate:self];


    	[self loadMaskPage];
    //
    //    if (self.detailItem) {
    //        self.detailDescriptionLabel.text = [self.detailItem description];
    //        //self.detailDescriptionLabel.text = @"yyy";
    //    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    //[super viewWillAppear:animated];
    [self.view addSubview:webView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController {
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}


//bridge

- (BOOL)webView:(UIWebView *)p_WebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	NSLog(@"Should page load?. %@", [request URL]);
	return TRUE;
}

- (void)webViewDidFinishLoad:(UIWebView *)p_WebView
{
	NSLog(@"Page did finish load. %@", [[p_WebView request] URL]);
}

- (void)webViewDidStartLoad:(UIWebView *)p_WebView
{
	NSLog(@"Page did start load. %@", [[p_WebView request] URL]);
}

- (void)webView:(UIWebView *)p_WebView didFailLoadWithError:(NSError *)error
{
	NSLog(@"Page did fail with error. %@", [[p_WebView request] URL]);
}


- (void)webView:(UIWebView*) webview didReceiveJSNotificationWithDictionary:(NSString*) jsonString
{
    //describeDictionary(dictionary);
    
	
    
    //NSLog(@"message: %@", "message", [dictionary objectForKey:"message"]);
    
    UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:@"JSON passed from WebView" 
                                                     message: jsonString 
                                                    delegate:nil 
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
    
    //[alert show];
    [alert release];
    
    
    //SBJsonParser* jsonParser = [[[SBJsonParser alloc] init] autorelease]; 
    
    //NSDictionary* jsonDic = [jsonParser objectWithString:myJsonStr];
    
    
    
    NSRange openBracket = [jsonString rangeOfString:@"value\":"];
    int loc1 = openBracket.location + 7;
    NSRange closeBracket = [jsonString rangeOfString:@"}"];
    NSRange numberRange = NSMakeRange(loc1, closeBracket.location - loc1 + 1);
    NSString *jsonObj = [jsonString substringWithRange:numberRange];
    NSLog(@"value = %@", jsonObj);
    
    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
    NSDictionary* jsonDic = [jsonParser objectWithString:jsonObj];
    NSLog ( @"firstName = %@", [jsonDic objectForKey: @"firstName"]);
    
    
    //NSError *error = nil;
    //NSArray *jsonObjects = [jsonParser objectWithString:jsonString error:&error];
    //[jsonParser release], jsonParser = nil;
    
    //NSDictionary* jsonDic = [jsonObj objectWithString:jsonStr];
    //NSDictionary* dicTranslated = [self translateDictionary:jsonDic];
    
    
}

@end
