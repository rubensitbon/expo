#import <ReactABI35_0_0/ABI35_0_0RCTLog.h>
#import <ReactABI35_0_0/ABI35_0_0RCTViewManager.h>
#import <ReactABI35_0_0/ABI35_0_0RCTBridgeModule.h>
#import <ReactABI35_0_0/ABI35_0_0RCTEventEmitter.h>

#import "ABI35_0_0RNHelpshift.h"
#import <Helpshift/HelpshiftCore.h>
#import <Helpshift/HelpshiftSupport.h>

@implementation ABI35_0_0RNHelpshift

-(id)init {
    self = [super init];
    [[HelpshiftSupport sharedInstance] setDelegate:self];
    return self;
}

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

+ (BOOL)requiresMainQueueSetup
{
    return YES;
}


ABI35_0_0RCT_EXPORT_MODULE()

ABI35_0_0RCT_EXPORT_METHOD(init:(NSString *)apiKey domain:(NSString *)domain appId:(NSString *)appId)
{
    [HelpshiftCore initializeWithProvider:[HelpshiftSupport sharedInstance]];
    [HelpshiftCore installForApiKey:apiKey domainName:domain appID:appId];
}

ABI35_0_0RCT_EXPORT_METHOD(login:(NSDictionary *)user)
{
    HelpshiftUserBuilder *userBuilder = [[HelpshiftUserBuilder alloc] initWithIdentifier:user[@"identifier"] andEmail:user[@"email"]];
    if (user[@"name"]) userBuilder.name = user[@"name"];
    if (user[@"authToken"]) userBuilder.authToken = user[@"authToken"];
    [HelpshiftCore login:userBuilder.build];
}

ABI35_0_0RCT_EXPORT_METHOD(logout)
{
    [HelpshiftCore logout];
}

ABI35_0_0RCT_EXPORT_METHOD(showConversation)
{
    UIViewController *rootController = UIApplication.sharedApplication.delegate.window.rootViewController;
    [HelpshiftSupport showConversation:rootController withConfig: nil];
}

ABI35_0_0RCT_EXPORT_METHOD(showConversationWithCIFs:(NSDictionary *)cifs)
{
    HelpshiftAPIConfigBuilder *builder = [[HelpshiftAPIConfigBuilder alloc] init];
    builder.customIssueFields = cifs;
    HelpshiftAPIConfig *apiConfig = [builder build];
    UIViewController *rootController = UIApplication.sharedApplication.delegate.window.rootViewController;
    [HelpshiftSupport showConversation:rootController withConfig: apiConfig];
}

ABI35_0_0RCT_EXPORT_METHOD(showFAQs)
{
    UIViewController *rootController = UIApplication.sharedApplication.delegate.window.rootViewController;
    [HelpshiftSupport showFAQs:rootController withConfig:nil];
}

ABI35_0_0RCT_EXPORT_METHOD(showFAQsWithCIFs:(NSDictionary *)cifs)
{
    HelpshiftAPIConfigBuilder *builder = [[HelpshiftAPIConfigBuilder alloc] init];
    builder.customIssueFields = cifs;
    HelpshiftAPIConfig *apiConfig = [builder build];
    UIViewController *rootController = UIApplication.sharedApplication.delegate.window.rootViewController;
    [HelpshiftSupport showFAQs:rootController withConfig:apiConfig];
}

ABI35_0_0RCT_EXPORT_METHOD(requestUnreadMessagesCount)
{
    [HelpshiftSupport requestUnreadMessagesCount:YES];
}

- (NSArray<NSString *> *)supportedEvents
{
    return @[
             @"Helpshift/SessionBegan",
             @"Helpshift/SessionEnded",
             @"Helpshift/NewConversationStarted",
             @"Helpshift/ConversationEnded",
             @"Helpshift/UserRepliedToConversation",
             @"Helpshift/UserCompletedCustomerSatisfactionSurvey",
             @"Helpshift/DidReceiveNotification",
             @"Helpshift/DidReceiveUnreadMessagesCount",
             @"Helpshift/DidReceiveUnreadMessagesCount",
             @"Helpshift/AuthenticationFailed"
    ];
}

- (void) helpshiftSupportSessionHasBegun {
    ABI35_0_0RCTLog(@"Helpshift/SessionBegan");
    [self sendEventWithName:@"Helpshift/SessionBegan" body:nil];
}

- (void) helpshiftSupportSessionHasEnded {
    ABI35_0_0RCTLog(@"Helpshift/SessionEnded");
    [self sendEventWithName:@"Helpshift/SessionEnded" body:nil];
}

- (void) newConversationStartedWithMessage:(NSString *)newConversationMessage {
    ABI35_0_0RCTLog(@"Helpshift/NewConversationStarted: %@", newConversationMessage);
    [self sendEventWithName:@"Helpshift/NewConversationStarted" body:@{@"newConversationMessage": newConversationMessage}];
}

- (void) conversationEnded {
    ABI35_0_0RCTLog(@"Helpshift/ConversationEnded");
    [self sendEventWithName:@"Helpshift/ConversationEnded" body:nil];
}

- (void) userRepliedToConversationWithMessage:(NSString *)newMessage {
    ABI35_0_0RCTLog(@"Helpshift/UserRepliedToConversation: %@", newMessage);
    [self sendEventWithName:@"Helpshift/UserRepliedToConversation" body:@{@"newMessage": newMessage}];
}

- (void) userCompletedCustomerSatisfactionSurvey:(NSInteger)rating withFeedback:(NSString *)feedback {
    ABI35_0_0RCTLog(@"Helpshift/UserCompletedCustomerSatisfactionSurvey rating: %ld feedback: %@", rating, feedback);
    [self sendEventWithName:@"Helpshift/UserCompletedCustomerSatisfactionSurvey" body:@{@"rating": @(rating), @"feedback": feedback}];
}

- (void) didReceiveInAppNotificationWithMessageCount:(NSInteger)count {
    ABI35_0_0RCTLog(@"Helpshift/DidReceiveNotification: %ld", count);
    [self sendEventWithName:@"Helpshift/DidReceiveNotification" body:@{@"count": @(count)}];
}

- (void)didReceiveUnreadMessagesCount:(NSInteger)count {
    ABI35_0_0RCTLog(@"Helpshift/DidReceiveUnreadMessagesCount: %ld", count);
    [self sendEventWithName:@"Helpshift/DidReceiveUnreadMessagesCount" body:@{@"count": @(count)}];
}

- (void) authenticationFailedForUser:(HelpshiftUser *)user withReason:(HelpshiftAuthenticationFailureReason)reason {
    ABI35_0_0RCTLog(@"Helpshift/AuthenticationFailed user: %@", user);
    [self sendEventWithName:@"Helpshift/AuthenticationFailed" body:@{@"user": user}];
}

@end



@interface ABI35_0_0RNTHelpshiftManager : ABI35_0_0RCTViewManager
@property(nonatomic,strong) UIView* helpshiftView;
@end

@implementation ABI35_0_0RNTHelpshiftManager

ABI35_0_0RCT_EXPORT_MODULE()

ABI35_0_0RCT_CUSTOM_VIEW_PROPERTY(config, NSDictionary, ABI35_0_0RNTHelpshiftManager) {
    [HelpshiftCore initializeWithProvider:[HelpshiftSupport sharedInstance]];
    [HelpshiftCore installForApiKey:json[@"apiKey"]
                         domainName:json[@"domain"]
                              appID:json[@"appId"]];

    // Log user in if identified
    if (json[@"user"]) {
        NSDictionary *user = json[@"user"];
        HelpshiftUserBuilder *userBuilder = [[HelpshiftUserBuilder alloc] initWithIdentifier:user[@"identifier"] andEmail:user[@"email"]];
        if (user[@"name"]) userBuilder.name = user[@"name"];
        if (user[@"authToken"]) userBuilder.authToken = user[@"authToken"];
        [HelpshiftCore login:userBuilder.build];
    }

    // Get the Helpshift conversation view controller.
    HelpshiftAPIConfigBuilder *builder = [HelpshiftAPIConfigBuilder new];
    // Add CIFS if existing
    if (json[@"cifs"]) builder.customIssueFields = json[@"cifs"];
    [HelpshiftSupport conversationViewControllerWithConfig:[builder build] completion:^(UIViewController *conversationVC) {
        UIViewController *rootController = [self currentViewController];

        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:conversationVC];
        [navController willMoveToParentViewController:rootController];

        if (json[@"height"] && json[@"width"]) {
            float height = [json[@"height"] floatValue];
            float width = [json[@"width"] floatValue];
            navController.view.frame = CGRectMake(0, 0, width, height);
        }

        [self.helpshiftView addSubview:navController.view];
        [rootController addChildViewController:navController];
        [navController didMoveToParentViewController:rootController];
    }];
}

- (UIViewController *)currentViewController {
  UIViewController *controller = [[[UIApplication sharedApplication] keyWindow] rootViewController];
  UIViewController *presentedController = controller.presentedViewController;

  while (presentedController && ![presentedController isBeingDismissed]) {
    controller = presentedController;
    presentedController = controller.presentedViewController;
  }

  // For Expo client, use the same logic as in ExpoKit currentViewController but this isn't a unimodule
  // so adapt it for here
  if ([controller respondsToSelector:@selector(contentViewController)]) {
      UIViewController *contentController = [controller performSelector:@selector(contentViewController)];

      if (contentController != nil) {
        controller = contentController;
        while (controller.presentedViewController != nil) {
          controller = controller.presentedViewController;
        }
      }
  }

  return controller;
}

- (UIView *)view
{
    UIView *view = [[UIView alloc] init];
    self.helpshiftView = view;
    return view;
}

@end
