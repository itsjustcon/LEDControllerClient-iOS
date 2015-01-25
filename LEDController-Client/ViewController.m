//
//  ViewController.m
//  LEDController-Client
//
//  Created by Connor Grady on 1/24/15.
//  Copyright (c) 2015 Stadium Runner. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <Color-Picker-for-iOS/HRColorPickerView.h>

@interface ViewController ()

@property (nonatomic, strong) AFHTTPRequestOperationManager *requestManager;
@property (nonatomic, weak) HRColorPickerView *colorPickerView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.colorPickerView.color = [UIColor whiteColor];
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    self.colorPickerView.frame = self.view.bounds;
    
}

- (void)pickerDidChangeColor:(HRColorPickerView *)colorPickerView {
    NSLog(@"CHANGED COLOR: %@", colorPickerView.color);
    
    // CONVERT COLOR TO RGB
    CGFloat red, green, blue;
    [colorPickerView.color getRed:&red green:&green blue:&blue alpha:nil];
    NSString *hexStr = [NSString stringWithFormat:@"#%02x%02x%02x", (int)(255.0 * red), (int)(255.0 * green), (int)(255.0 * blue)];
    
    NSLog(@"PARSED HEX STRING: %@", hexStr);
    
    NSDictionary *parameters = @{ @"hex": hexStr };
    
    [self.requestManager POST:@"http://10.0.0.67:8080/" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}



#pragma mark - Getters

- (AFHTTPRequestOperationManager *)requestManager {
    if (!_requestManager) {
        _requestManager = [AFHTTPRequestOperationManager manager];
        _requestManager.requestSerializer = [AFJSONRequestSerializer new];
    }
    return _requestManager;
}

- (HRColorPickerView *)colorPickerView {
    if (!_colorPickerView) {
        HRColorPickerView *colorPickerView = [HRColorPickerView new];
        colorPickerView.color = [UIColor whiteColor];
        [colorPickerView addTarget:self action:@selector(pickerDidChangeColor:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview: _colorPickerView = colorPickerView ];
    }
    return _colorPickerView;
}



@end
