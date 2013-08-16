#import "MenubarController.h"
#import "StatusItemView.h"
#import "HTTPClient.h"

@implementation MenubarController

@synthesize statusItemView = _statusItemView;

#pragma mark -

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        // Install status item into the menu bar
        NSStatusItem *statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:STATUS_ITEM_VIEW_WIDTH];
        _statusItemView = [[StatusItemView alloc] initWithStatusItem:statusItem];
        _statusItemView.image = [NSImage imageNamed:@"icon-green"];
        _statusItemView.alternateImage = [NSImage imageNamed:@"icon-red"];
        _statusItemView.image1 = [NSImage imageNamed:@"icon-green"];
        _statusItemView.image2 = [NSImage imageNamed:@"icon-yellow"];
        _statusItemView.image3 = [NSImage imageNamed:@"icon-red"];
        _statusItemView.action = @selector(togglePanel:);
        
        [self updateStats];
    }
    
    [NSTimer scheduledTimerWithTimeInterval:6 target:self selector:@selector(refresh) userInfo:nil repeats:YES];
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
        
        NSString *alert = [JSON objectForKey:@"level_name"];
        NSString *description = [JSON objectForKey:@"description"];
        NSString *fullAlert = [NSString stringWithFormat:@"%@ : %@", description, alert];
        
        [self showNotification:fullAlert];
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

- (void)updateStats
{
    [[HTTPClient sharedClient] setUsername:@"andrew.katz@outright.com" andPassword:@"1234"];
    
    [[HTTPClient sharedClient] getPath:@"/admin/importer_progress" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        int importerLevel = [[[responseObject objectForKey:@"importer_status"] objectForKey:@"level"] intValue];
        BOOL importerStatus = importerLevel == 1;
        
        NSLog(@"%d", importerLevel);
        [self setHasActiveIcon:importerStatus];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // error stuff here
        NSLog(@"error: %@", error);
    }];
}

@end
