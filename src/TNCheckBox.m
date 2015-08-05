//
//  RadioButton.m
//  TNCheckBox
//
//  Created by Frederik Jacques on 02/04/14.
//  Copyright (c) 2014 Frederik Jacques. All rights reserved.
//

#import "TNCheckBox.h"

@interface TNCheckBox()

@end

@implementation TNCheckBox

#pragma mark - Initializers
- (instancetype)initWithData:(TNCheckBoxData *)data {
    
    self = [super init];
    
    if (self) {
        self.data = data;
    }
    
    return self;
}

#pragma mark - Setup
- (void)setup {
    
    [self createLabel];
    [self createHiddenButton];
    
    [self.data addObserver:self forKeyPath:@"checked" options:NSKeyValueObservingOptionNew context:nil];
    
    [self checkWithAnimation:NO];
    self.frame = self.btnHidden.frame;
}

- (void)updateLabel {
    self.lblButton.backgroundColor = [UIColor clearColor];
    self.lblButton.titleLabel.font = self.data.labelFont;
    [self.lblButton setTitleColor:self.data.labelColor forState:UIControlStateNormal];
    [self.lblButton setTitle:self.data.labelText forState:UIControlStateNormal];
    
    if(self.data.labelBorderWidth){
        self.lblButton.layer.masksToBounds = YES;
        self.lblButton.layer.cornerRadius = self.data.labelBorderCornerRadius ?: 5.0;
        self.lblButton.layer.borderWidth = self.data.labelBorderWidth ?: 1.0;
        self.lblButton.layer.borderColor = self.data.labelBorderColor ?: [UIColor grayColor].CGColor;
    }
}

- (void)createCheckbox {};

- (void)createLabel {
    
    CGRect labelRect = [self.data.labelText boundingRectWithSize:CGSizeMake(150, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.data.labelFont} context:nil];
    CGSize labelSize = CGSizeMake(labelRect.size.width, labelRect.size.height);
    
    self.lblButton = [[UIButton alloc] initWithFrame:CGRectMake(self.checkBox.frame.origin.x + self.checkBox.frame.size.width + self.data.labelMarginLeft, (self.checkBox.frame.size.height - labelSize.height) / 2, self.data.labelWidth ?: labelSize.width, self.data.labelHeight ?: labelSize.height)];
    [self updateLabel];
    [self addSubview:self.lblButton];
}

- (void)createHiddenButton {
    
    int height = MAX(self.lblButton.frame.size.height, self.checkBox.frame.size.height);
    
    self.btnHidden = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnHidden.frame = CGRectMake(0, 0, self.lblButton.frame.origin.x + self.lblButton.frame.size.width, height);
    [self addSubview:self.btnHidden];
    
    [self.btnHidden addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark - Target / Actions
- (void)buttonTapped:(id)sender {
    
    self.data.checked = !self.data.checked;
    [self checkWithAnimation:YES];
    
    if ([self.delegate respondsToSelector:@selector(checkBoxDidChange:)]) {
        [self.delegate checkBoxDidChange:self];
    }
    
}

#pragma mark - Animations
- (void)checkWithAnimation:(BOOL)animated {}

#pragma mark - Getters / Setters
- (void)setPosition:(CGPoint)position {
    
    _position = position;
    
    self.frame = CGRectMake( position.x, position.y, self.frame.size.width, self.frame.size.height);
    
}

#pragma mark - Observers
- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([object isKindOfClass:[TNCheckBoxData class]] && [keyPath isEqualToString:@"checked"]) {
        [self checkWithAnimation:NO];
    }
}

- (void) dealloc {
    @try {
        [self.data removeObserver:self forKeyPath:@"checked"];
    }
    @catch (NSException *exception) {
        //
    }
}

@end
