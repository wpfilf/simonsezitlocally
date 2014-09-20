//
//  GameUtils.h
//  SimonSezItLocally
//
//  Created by Andrei Bechet on 20/09/14.
//  Copyright (c) 2014 CodeFest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface GameUtils : NSObject


+ (NSArray*)generateGameColorSeq:(short)sizeOfSeq;
+ (UIColor*)decodeColor:(short)code;

@end
