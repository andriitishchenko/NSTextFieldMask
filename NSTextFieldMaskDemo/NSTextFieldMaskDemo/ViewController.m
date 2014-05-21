//
//  ViewController.m
//  NSTextFieldMaskDemo
//
//  Created by Andrii Tishchenko on 05.02.14.
//  Copyright (c) 2014 Andrii Tishchenko. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSTextFieldMask*tf = [[NSTextFieldMask alloc] initWithFrame:CGRectMake(20, 160, 400, 40)];
    tf.mask_delegate = self;
    tf.maskPlaceholderColor = [UIColor greenColor];
    tf.textColor = [UIColor redColor];
    tf.maskPlaceholderSymbolAlpha = @"+";
    tf.maskPlaceholderSymbolNumber = @"%";
    tf.placeholder = @"NUM:### ALPHA:~~~";
    [self.view addSubview:tf];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//
//-(void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    [self.test removeFromSuperview];
//    self.test = nil;
//}

-(void)textFieldMask:(NSTextFieldMask*)tf continueWithString:(NSString*)string
{
    NSLog(@"%@",string);
}
-(NSString*)textFieldMask:(NSTextFieldMask*)tf willProcessWithCharacter:(NSString*)character inRange:(NSRange)range
{
    return [character uppercaseString];
}
-(void)textFieldMask:(NSTextFieldMask*)tf wrongCharacterAtPosition:(NSInteger)position
{
    NSLog(@"wrong at pos %d",position);
}

@end
