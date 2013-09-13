#import "MenubarController.h"
#import "StatusItemView.h"
#import "HTTPClient.h"

@implementation MenubarController

@synthesize statusItemView = _statusItemView;

#define REFRESH_TIME 60

#pragma mark -

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        // Install status item into the menu bar
        NSStatusItem *statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:STATUS_ITEM_VIEW_WIDTH];
        _statusItemView = [[StatusItemView alloc] initWithStatusItem:statusItem];
        _statusItemView.image1 = [NSImage imageNamed:@"icon-green"];
        _statusItemView.image2 = [NSImage imageNamed:@"icon-yellow"];
        _statusItemView.image3 = [NSImage imageNamed:@"icon-red"];
        _statusItemView.image4 = [NSImage imageNamed:@"icon-grey"];
        _statusItemView.action = @selector(togglePanel:);
    }
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:REFRESH_TIME target:self selector:@selector(refresh) userInfo:nil repeats:YES];
    [timer fire];
    
    return self;
}

- (void)refresh
{
    NSURL *url = [NSURL URLWithString:@"https://secure.outright.com/admin/importer_alerts/current"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        int alertLevel = [[JSON objectForKey:@"level"] intValue];
        _statusItemView.isGood = alertLevel == 1;
        _statusItemView.isBad  = alertLevel == 2;
        _statusItemView.isUgly = alertLevel == 3;
        [_statusItemView redrawIcon];
        
        NSString *levelName    = [JSON objectForKey:@"level_name"];
        NSString *description  = [JSON objectForKey:@"description"];
        NSString *currentAlert = [NSString stringWithFormat:@"(%@) : %@", levelName, description];
        
        if([currentAlert isNotEqualTo:previousAlert]) {
            NSLog(@"previous: %@", previousAlert);
            NSLog(@"current: %@", currentAlert);
            [self showNotification:currentAlert];
            previousAlert = currentAlert;
        }
    } failure:nil];
    
    [operation start];
}

- (IBAction)showNotification:(NSString *)alert
{
    NSUserNotification *notification = [[NSUserNotification alloc] init];
    notification.title = @"Importer Alerts";
    notification.informativeText = alert;
    notification.soundName = NSUserNotificationDefaultSoundName;
    
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
}

- (void)dealloc
{
    [[NSStatusBar systemStatusBar] removeStatusItem:self.statusItem];
}

#pragma mark -
#pragma mark Public accessors

- (NSStatusItem *)statusItem
{
    return self.statusItemView.statusItem;
}

#pragma mark -

- (BOOL)hasActiveIcon
{
    return self.statusItemView.isHighlighted;
}

- (void)setHasActiveIcon:(BOOL)flag
{
    self.statusItemView.isHighlighted = flag;
}

@end
