#import "Webkit/Webkit.h"
#import "BackgroundView.h"
#import "StatusItemView.h"

@class PanelController;

@protocol PanelControllerDelegate <NSObject>

@optional

- (StatusItemView *)statusItemViewForPanelController:(PanelController *)controller;

@end

#pragma mark -

@interface PanelController : NSWindowController <NSWindowDelegate>
{
    BOOL _hasActivePanel;
    __unsafe_unretained BackgroundView *_backgroundView;
    __unsafe_unretained id<PanelControllerDelegate> _delegate;
}

@property (nonatomic, unsafe_unretained) IBOutlet BackgroundView *backgroundView;
@property (nonatomic, unsafe_unretained) IBOutlet NSTextField *importingText;
@property (nonatomic, unsafe_unretained) IBOutlet NSTextField *retryingText;
@property (nonatomic, unsafe_unretained) IBOutlet NSTextField *queuedText;
@property (nonatomic, unsafe_unretained) IBOutlet NSTextField *errorText;
@property (nonatomic, unsafe_unretained) IBOutlet NSTextField *totalSuccessText;
@property (nonatomic, unsafe_unretained) IBOutlet NSLevelIndicator *successProgress;
@property (strong, nonatomic) NSDictionary *stats;

@property (nonatomic) BOOL hasActivePanel;
@property (nonatomic, unsafe_unretained, readonly) id<PanelControllerDelegate> delegate;

- (id)initWithDelegate:(id<PanelControllerDelegate>)delegate;

- (void)openPanel;
- (void)closePanel;
- (NSRect)statusRectForWindow:(NSWindow *)window;
- (void)reloadData;
- (NSString *)formattedImporterProgressPercent:(NSString *)key;
- (double)rawImporterProgressPercent:(NSString *)key;
- (NSString *)formattedImporterProgressCount:(NSString *)key;
- (long)rawImporterProgressCount:(NSString *)key;
- (IBAction)showDetails:(id)sender;
- (void)refresh;

@end
