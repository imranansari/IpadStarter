//
//  DetailViewController.h
//  IpadStarter
//
//  Created by Imran Ansari on 11/25/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSBridgeWebView.h"


@interface DetailViewController : UIViewController <UISplitViewControllerDelegate,JSBridgeWebViewDelegate> {
    
	JSBridgeWebView* webView;
	
	}

-(void) loadMaskPage;


@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end
