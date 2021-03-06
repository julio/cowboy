#import "StatusItemView.h"

@implementation StatusItemView

@synthesize statusItem = _statusItem;
@synthesize image = _image;
@synthesize isHighlighted = _isHighlighted;
@synthesize isGood = _isGood;
@synthesize isBad  = _isBad;
@synthesize isUgly = _isUgly;
@synthesize image1 = _image1;
@synthesize image2 = _image2;
@synthesize image3 = _image3;
@synthesize image4 = _image4;
@synthesize action = _action;
@synthesize target = _target;

#pragma mark -

- (id)initWithStatusItem:(NSStatusItem *)statusItem
{
    CGFloat itemWidth = [statusItem length];
    CGFloat itemHeight = [[NSStatusBar systemStatusBar] thickness];
    NSRect itemRect = NSMakeRect(0.0, 0.0, itemWidth, itemHeight);
    self = [super initWithFrame:itemRect];
    
    if (self != nil) {
        _statusItem = statusItem;
        _statusItem.view = self;
    }
    return self;
}


#pragma mark -

- (void)drawRect:(NSRect)dirtyRect
{
    NSImage *icon;

    if (self.isGood) {
        icon = self.image1;
    } else if (self.isBad) {
        icon = self.image2;
    } else if (self.isUgly) {
        icon = self.image3;
    } else {
        icon = self.image4;
    }

    NSSize iconSize = [icon size];
    NSRect bounds = self.bounds;
    CGFloat iconX = roundf((NSWidth(bounds) - iconSize.width) / 2);
    CGFloat iconY = roundf((NSHeight(bounds) - iconSize.height) / 2);
    NSPoint iconPoint = NSMakePoint(iconX, iconY);
    [icon compositeToPoint:iconPoint operation:NSCompositeSourceOver];
}

#pragma mark -
#pragma mark Mouse tracking

- (void)mouseDown:(NSEvent *)theEvent
{
    [NSApp sendAction:self.action to:self.target from:self];
}

#pragma mark -
#pragma mark Accessors

- (void)setHighlighted:(BOOL)newFlag
{
    if (_isHighlighted == newFlag) return;
    _isHighlighted = newFlag;
    [self setNeedsDisplay:YES];
}
- (void) redrawIcon
{
    [self setNeedsDisplay:YES];
}

#pragma mark -

- (void)setImage:(NSImage *)newImage
{
    NSLog(@"image %@", newImage);
    if (_image != newImage) {
        _image = newImage;
        [self setNeedsDisplay:YES];
    }
}

#pragma mark -

- (NSRect)globalRect
{
    NSRect frame = [self frame];
    frame.origin = [self.window convertBaseToScreen:frame.origin];
    return frame;
}

@end
