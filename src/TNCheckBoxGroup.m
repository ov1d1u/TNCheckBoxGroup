//
//  TNCheckBoxGroup.m
//  TNCheckBoxDemo
//
//  Created by Frederik Jacques on 24/04/14.
//  Copyright (c) 2014 Frederik Jacques. All rights reserved.
//

#import "TNCheckBoxGroup.h"

NSString *const GROUP_CHANGED = @"groupChanged";

@interface TNCheckBoxGroup()

@property (nonatomic, strong) NSArray *checkBoxData;
@property (nonatomic) TNCheckBoxLayout layout;

@end

@implementation TNCheckBoxGroup {
    CGFloat _maxWidth;
    CGFloat _maxHeight;
}

- (instancetype)initWithCheckBoxData:(NSArray *)checkBoxData style:(TNCheckBoxLayout)layout {
    
    self = [super init];
    
    if (self) {
        self.checkBoxData = checkBoxData;
        self.layout = layout;
        self.rowItemCount = 3;
        self.marginBetweenItems = 15.0;
    }
    
    return self;
}

- (void)create {
    [self createCheckBoxes];
    self.frame = CGRectMake(0, 0, self.superview.frame.size.width, self.superview.frame.size.height);
}

- (void)createCheckBoxes {
    int i = 0;
    
    for (TNCheckBoxData *data in self.checkBoxData) {
        
        TNCheckBox *checkBox = nil;
        
        if( !data.labelFont) data.labelFont = self.labelFont;
        if( !data.labelColor) data.labelColor = self.labelColor;
        
        if( [data isKindOfClass:[TNCircularCheckBoxData class]] ){
            checkBox = [[TNCircularCheckBox alloc] initWithData:(TNCircularCheckBoxData *)data];
        }else if( [data isKindOfClass:[TNRectangularCheckBoxData class]] ){
            checkBox = [[TNRectangularCheckBox alloc] initWithData:(TNRectangularCheckBoxData *)data];
        }else if( [data isKindOfClass:[TNImageCheckBoxData class]] ){
            checkBox = [[TNImageCheckBox alloc] initWithData:(TNImageCheckBoxData *)data];
        }else {
            checkBox = [[TNFillCheckBox alloc] initWithData:(TNFillCheckBoxData *)data];
        }
        
        data.tag = i;
        
        checkBox.delegate = self;
        
        [self addSubview:checkBox];
        
        _maxWidth = fmaxf(_maxWidth, checkBox.frame.size.width);
        _maxHeight = fmaxf(_maxHeight, checkBox.frame.size.height);
        
        i++;
    }
    
    _maxWidth += self.marginBetweenItems;
    _maxHeight += self.marginBetweenItems;
}

- (void) layoutSubviews {
    [super layoutSubviews];
    if (!self.superview) return;
    NSInteger wfraction = floorf(self.superview.frame.size.width / _maxWidth);
    
    CGFloat currentX = 0.0;
    CGFloat currentY = 0.0;
    
    NSInteger i = 0;
    
    for (TNCheckBox *checkBox in self.subviews) {
        if (![checkBox isKindOfClass:[TNCheckBox class]]) continue;
        
        checkBox.frame = CGRectMake(currentX, currentY, checkBox.frame.size.width, checkBox.frame.size.height);
        if (self.layout == TNCheckBoxLayoutHorizontal) {
            i++;
            currentX = i * _maxWidth;
            
            if (i >= wfraction) {
                currentX = 0.0;
                i = 0;
                currentY += _maxHeight;
            }
        } else {
            currentY += _maxHeight;
            if (currentY + _maxHeight > self.superview.frame.size.height) {
                currentY = 0.0;
                currentX += _maxWidth;
            }
        }
    }
}

- (void)checkBoxDidChange:(TNCheckBox *)checkbox {
    [[NSNotificationCenter defaultCenter] postNotificationName:GROUP_CHANGED object:self userInfo:@{@"checkbox": checkbox}];
    
}

- (void)setPosition:(CGPoint)position {
    
    self.frame = CGRectMake(position.x, position.y, self.frame.size.width, self.frame.size.height);
}

#pragma mark - Getters / Setters
- (NSArray *)checkedCheckBoxes {
    
    NSIndexSet *set = [self.checkBoxData indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        
        TNCheckBoxData *data = (TNCheckBoxData *)obj;
        return data.checked;
    }];
    
    return [self.checkBoxData objectsAtIndexes:set];
}

- (NSArray *)uncheckedCheckBoxes {
    
    NSIndexSet *set = [self.checkBoxData indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        
        TNCheckBoxData *data = (TNCheckBoxData *)obj;
        return !data.checked;
    }];
    
    return [self.checkBoxData objectsAtIndexes:set];
}

- (UIColor *)labelColor {
    
    if( !_labelColor ){
        _labelColor = [UIColor blackColor];
    }
    
    return _labelColor;
    
}

- (UIFont *)labelFont {
    
    if( !_labelFont ){
        _labelFont = [UIFont systemFontOfSize:14];
    }
    
    return  _labelFont;
}


@end
