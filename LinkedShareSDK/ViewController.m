
#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)loginClicked
{
    NSArray *permissions = [NSArray arrayWithObjects:LISDK_BASIC_PROFILE_PERMISSION,LISDK_W_SHARE_PERMISSION,nil];
    [LISDKSessionManager createSessionWithAuth:permissions state:nil showGoToAppStoreDialog:YES successBlock:^(NSString *returnState){
        NSLog(@"%s","success called!");
        NSString *url = [NSString stringWithFormat:@"https://api.linkedin.com/v1/people/~"];
        if ([LISDKSessionManager hasValidSession]) {
            [[LISDKAPIHelper sharedInstance] getRequest:url success:^(LISDKAPIResponse *response) {
            NSString *dataStr = response.data;
            NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSLog(@"JSON Dict -------------->%@",json);
            }error:^(LISDKAPIError *apiError) {
                NSLog(@"%@",apiError);
            }];
        }
    }errorBlock:^(NSError *error){
    NSLog(@"%s","error called!");
    }];
}
- (IBAction)LoginBtn:(id)sender {
    [self loginClicked];
}
- (IBAction)showprofile:(id)sender {
    DeeplinkSuccessBlock success = ^(NSString *returnState) {
        NSLog(@"Success with returned state: %@",returnState);
    };
    DeeplinkErrorBlock error = ^(NSError *error, NSString *returnState) {
        NSLog(@"Error with returned state: %@", returnState);
        NSLog(@"Error %@", error);
    };
    [[LISDKDeeplinkHelper sharedInstance] viewCurrentProfileWithState:@"viewMyProfileButton" showGoToAppStoreDialog:YES success:success error:error];

}

- (IBAction)Share:(id)sender {
    NSString *url = [NSString stringWithFormat:@"https://api.linkedin.com/v1/people/~/shares"];
    NSString *payload = [NSString stringWithFormat:@"{\"comment\":\"This is  Test Status http://www.inwizards.com\",\"visibility\":{ \"code\":\"anyone\" }}"];
    if ([LISDKSessionManager hasValidSession]) {
        [[LISDKAPIHelper sharedInstance] postRequest:url stringBody:payload success:^(LISDKAPIResponse *responce) {
            NSLog(@"Share Success");
        } error:^(LISDKAPIError *apiErr) {
            NSLog(@"Share Fail");
        }];
    }
}

@end
