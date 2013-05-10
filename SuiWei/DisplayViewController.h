//
//  DisplayViewController.h
//  WeiboTest
//
//  Created by lucas on 5/5/13.
//  Copyright (c) 2013 lucas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "EGORefreshTableHeaderView.h"

@protocol  DisplayViewControllerDelegate <NSObject>

- (void)hideStatuses;
- (void)getFriendsTime;

@end

@interface DisplayViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ASIHTTPRequestDelegate, EGORefreshTableHeaderDelegate>

{
    id<DisplayViewControllerDelegate> _delegate;
}

@property (nonatomic, assign) id<DisplayViewControllerDelegate> delegate;
- (void)updateData;
- (void)openApp;

@end