//
//  FSCalendarCell.m
//  Pods
//
//  Created by Wenchao Ding on 12/3/15.
//
//

#import "FSCalendarCell.h"
#import "FSCalendar.h"
#import "FSCalendarExtensions.h"
#import "FSCalendarDynamicHeader.h"
#import "FSCalendarConstants.h"

@interface FSCalendarCell ()

@property (readonly, nonatomic) UIColor *colorForCellFill;
@property (readonly, nonatomic) UIColor *colorForTitleLabel;
@property (readonly, nonatomic) UIColor *colorForSubtitleLabel;
@property (readonly, nonatomic) UIColor *colorForCellBorder;
@property (readonly, nonatomic) NSArray<UIColor *> *colorsForEvents;
@property (readonly, nonatomic) CGFloat borderRadius;
- (void)autoLayoutForEventView;


@end

@implementation FSCalendarCell

#pragma mark - Life cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{   
    UILabel *label;
    UIView *event1;
    UIView *event2;
    UIView *event3;
    CAShapeLayer *shapeLayer;
    
    label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    [self.contentView addSubview:label];
    self.titleLabel = label;
    
    event1 = [[UIView alloc] initWithFrame:CGRectZero];
    event1.backgroundColor = UIColor.purpleColor;
    self.event1View = event1;
    _event1View.translatesAutoresizingMaskIntoConstraints = false;
    [self.contentView addSubview:_event1View];
    
    event2 = [[UIView alloc] initWithFrame:CGRectZero];
    event2.backgroundColor = UIColor.redColor;
    self.event2View = event2;
    _event2View.translatesAutoresizingMaskIntoConstraints = false;
    [self.contentView addSubview:_event2View];
    
    event3 = [[UIView alloc] initWithFrame:CGRectZero];
    event3.backgroundColor = UIColor.orangeColor;
    self.event3View = event3;
    _event3View.translatesAutoresizingMaskIntoConstraints = false;
    [self.contentView addSubview:_event3View];
    
    shapeLayer = [CAShapeLayer layer];
    shapeLayer.backgroundColor = [UIColor clearColor].CGColor;
    shapeLayer.borderWidth = 1.0;
    shapeLayer.borderColor = [UIColor clearColor].CGColor;
    shapeLayer.opacity = 0;
    [self.contentView.layer insertSublayer:shapeLayer below:_titleLabel.layer];
    self.shapeLayer = shapeLayer;
    
    self.clipsToBounds = NO;
    self.contentView.clipsToBounds = NO;
    
}



- (void)layoutSubviews
{
    [super layoutSubviews];
        _titleLabel.frame = CGRectMake(
                                       self.contentView.center.x - 10.25,
                                       self.contentView.center.y - 13.25,
                                       20.5,
                                       20.5
                                       );
    _event1View.frame = CGRectMake(
                                   self.contentView.center.x,
                                   _titleLabel.frame.origin.y + _titleLabel.frame.size.height + 3,
                                   self.contentView.frame.size.width - 6,
                                   1.5);
    [_event1View.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:3].active = true;
    [_event1View.topAnchor constraintEqualToAnchor:_titleLabel.bottomAnchor constant:3].active = true;
    [_event1View.centerXAnchor constraintEqualToAnchor:self.contentView.centerXAnchor].active = true;
    [_event1View.heightAnchor constraintEqualToConstant: 1.5].active = true;
    
    [_event2View.leadingAnchor constraintEqualToAnchor:self.event1View.leadingAnchor].active = true;
    [_event2View.topAnchor constraintEqualToAnchor:_event1View.bottomAnchor constant:3].active = true;
    [_event2View.centerXAnchor constraintEqualToAnchor:self.contentView.centerXAnchor].active = true;
    [_event2View.heightAnchor constraintEqualToConstant: 1.5].active = true;
    
    [_event3View.leadingAnchor constraintEqualToAnchor:_event2View.leadingAnchor].active = true;
    [_event3View.topAnchor constraintEqualToAnchor:_event2View.bottomAnchor constant:3].active = true;
    [_event3View.centerXAnchor constraintEqualToAnchor:_event2View.centerXAnchor].active = true;
    [_event3View.heightAnchor constraintEqualToConstant: 1.5].active = true;
    
    CGFloat titleHeight = self.bounds.size.height*5.0/6.0;
    CGFloat diameter = MIN(self.bounds.size.height*5.0/6.0,self.bounds.size.width);
    diameter = diameter > FSCalendarStandardCellDiameter ? (diameter - (diameter-FSCalendarStandardCellDiameter)*0.5) : diameter;
    _shapeLayer.frame = CGRectMake((self.bounds.size.width-diameter)/2,
                                   (titleHeight-diameter)/2,
                                   diameter,
                                   diameter);
    
    CGPathRef path = [UIBezierPath bezierPathWithRoundedRect:_shapeLayer.bounds
                                                cornerRadius:CGRectGetWidth(_shapeLayer.bounds)*0.5*self.borderRadius].CGPath;
    if (!CGPathEqualToPath(_shapeLayer.path,path)) {
        _shapeLayer.path = path;
    }
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    if (self.window) { // Avoid interrupt of navigation transition somehow
        [CATransaction setDisableActions:YES]; // Avoid blink of shape layer.
    }
    self.shapeLayer.opacity = 0;
    [self.contentView.layer removeAnimationForKey:@"opacity"];
}

#pragma mark - Public

- (void)performSelecting
{
    _shapeLayer.opacity = 1;
        
    CAAnimationGroup *group = [CAAnimationGroup animation];
    CABasicAnimation *zoomOut = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    zoomOut.fromValue = @0.3;
    zoomOut.toValue = @1.2;
    zoomOut.duration = FSCalendarDefaultBounceAnimationDuration/4*3;
    CABasicAnimation *zoomIn = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    zoomIn.fromValue = @1.2;
    zoomIn.toValue = @1.0;
    zoomIn.beginTime = FSCalendarDefaultBounceAnimationDuration/4*3;
    zoomIn.duration = FSCalendarDefaultBounceAnimationDuration/4;
    group.duration = FSCalendarDefaultBounceAnimationDuration;
    group.animations = @[zoomOut, zoomIn];
    [_shapeLayer addAnimation:group forKey:@"bounce"];
    [self configureAppearance];
    
}

#pragma mark - Private

- (void)configureAppearance
{
    UIColor *textColor = self.colorForTitleLabel;
    if (![textColor isEqual:_titleLabel.textColor]) {
        _titleLabel.textColor = textColor;
    }
    UIFont *titleFont = self.calendar.appearance.titleFont;
    if (![titleFont isEqual:_titleLabel.font]) {
        _titleLabel.font = titleFont;
    }
    
    UIColor *borderColor = self.colorForCellBorder;
    UIColor *fillColor = self.colorForCellFill;
    
    BOOL shouldHideShapeLayer = !self.selected && !self.dateIsToday && !borderColor && !fillColor;
    
    if (_shapeLayer.opacity == shouldHideShapeLayer) {
        _shapeLayer.opacity = !shouldHideShapeLayer;
    }
    if (!shouldHideShapeLayer) {
        
        CGColorRef cellFillColor = self.colorForCellFill.CGColor;
        if (!CGColorEqualToColor(_shapeLayer.fillColor, cellFillColor)) {
            _shapeLayer.fillColor = cellFillColor;
        }
        
        CGColorRef cellBorderColor = self.colorForCellBorder.CGColor;
        if (!CGColorEqualToColor(_shapeLayer.strokeColor, cellBorderColor)) {
            _shapeLayer.strokeColor = cellBorderColor;
        }
        
        CGPathRef path = [UIBezierPath bezierPathWithRoundedRect:_shapeLayer.bounds
                                                    cornerRadius:CGRectGetWidth(_shapeLayer.bounds)*0.5*self.borderRadius].CGPath;
        if (!CGPathEqualToPath(_shapeLayer.path, path)) {
            _shapeLayer.path = path;
        }
        
    }
}

- (UIColor *)colorForCurrentStateInDictionary:(NSDictionary *)dictionary
{
    if (self.isSelected) {
        if (self.dateIsToday) {
            return dictionary[@(FSCalendarCellStateSelected|FSCalendarCellStateToday)] ?: dictionary[@(FSCalendarCellStateSelected)];
        }
        return dictionary[@(FSCalendarCellStateSelected)];
    }
    if (self.dateIsToday && [[dictionary allKeys] containsObject:@(FSCalendarCellStateToday)]) {
        return dictionary[@(FSCalendarCellStateToday)];
    }
    if (self.placeholder && [[dictionary allKeys] containsObject:@(FSCalendarCellStatePlaceholder)]) {
        return dictionary[@(FSCalendarCellStatePlaceholder)];
    }
    if (self.weekend && [[dictionary allKeys] containsObject:@(FSCalendarCellStateWeekend)]) {
        return dictionary[@(FSCalendarCellStateWeekend)];
    }
    return dictionary[@(FSCalendarCellStateNormal)];
}

#pragma mark - Properties

- (UIColor *)colorForCellFill
{
    if (self.selected) {
        return self.preferredFillSelectionColor ?: [self colorForCurrentStateInDictionary:_appearance.backgroundColors];
    }
    return self.preferredFillDefaultColor ?: [self colorForCurrentStateInDictionary:_appearance.backgroundColors];
}

- (UIColor *)colorForTitleLabel
{
    if (self.selected) {
        return self.preferredTitleSelectionColor ?: [self colorForCurrentStateInDictionary:_appearance.titleColors];
    }
    return self.preferredTitleDefaultColor ?: [self colorForCurrentStateInDictionary:_appearance.titleColors];
}

- (UIColor *)colorForSubtitleLabel
{
    if (self.selected) {
        return self.preferredSubtitleSelectionColor ?: [self colorForCurrentStateInDictionary:_appearance.subtitleColors];
    }
    return self.preferredSubtitleDefaultColor ?: [self colorForCurrentStateInDictionary:_appearance.subtitleColors];
}

- (UIColor *)colorForCellBorder
{
    if (self.selected) {
        return _preferredBorderSelectionColor ?: _appearance.borderSelectionColor;
    }
    return _preferredBorderDefaultColor ?: _appearance.borderDefaultColor;
}

- (NSArray<UIColor *> *)colorsForEvents
{
    if (self.selected) {
        return _preferredEventSelectionColors ?: @[_appearance.eventSelectionColor];
    }
    return _preferredEventDefaultColors ?: @[_appearance.eventDefaultColor];
}

- (CGFloat)borderRadius
{
    return _preferredBorderRadius >= 0 ? _preferredBorderRadius : _appearance.borderRadius;
}

#define OFFSET_PROPERTY(NAME,CAPITAL,ALTERNATIVE) \
\
@synthesize NAME = _##NAME; \
\
- (void)set##CAPITAL:(CGPoint)NAME \
{ \
    BOOL diff = !CGPointEqualToPoint(NAME, self.NAME); \
    _##NAME = NAME; \
    if (diff) { \
        [self setNeedsLayout]; \
    } \
} \
\
- (CGPoint)NAME \
{ \
    return CGPointEqualToPoint(_##NAME, CGPointInfinity) ? ALTERNATIVE : _##NAME; \
}

OFFSET_PROPERTY(preferredTitleOffset, PreferredTitleOffset, _appearance.titleOffset);
OFFSET_PROPERTY(preferredSubtitleOffset, PreferredSubtitleOffset, _appearance.subtitleOffset);
OFFSET_PROPERTY(preferredImageOffset, PreferredImageOffset, _appearance.imageOffset);
OFFSET_PROPERTY(preferredEventOffset, PreferredEventOffset, _appearance.eventOffset);

#undef OFFSET_PROPERTY

- (void)setCalendar:(FSCalendar *)calendar
{
    if (![_calendar isEqual:calendar]) {
        _calendar = calendar;
        _appearance = calendar.appearance;
        [self configureAppearance];
    }
}

- (void)setSubtitle:(NSString *)subtitle
{
    if (![_subtitle isEqualToString:subtitle]) {
        BOOL diff = (subtitle.length && !_subtitle.length) || (_subtitle.length && !subtitle.length);
        _subtitle = subtitle;
        if (diff) {
            [self setNeedsLayout];
        }
    }
}

@end

@implementation FSCalendarBlankCell

- (void)configureAppearance {}

@end



