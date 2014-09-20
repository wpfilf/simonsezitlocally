//
//  GameUtils.m
//  SimonSezItLocally
//
//  Created by Andrei Bechet on 20/09/14.
//  Copyright (c) 2014 CodeFest. All rights reserved.
//

#import "GameUtils.h"
#include <stdlib.h>

@implementation GameUtils

+ (NSArray*)generateGameColorSeq:(short)sizeOfSeq {
    
    NSMutableArray *gameColorSeq = [[NSMutableArray alloc] initWithCapacity:sizeOfSeq];
    
    for (int i = 0; i < sizeOfSeq; i++) {
        int r = arc4random_uniform(3);
        NSNumber *n = [NSNumber numberWithInt:r];
        [gameColorSeq addObject:n];
    }
    
    return gameColorSeq;
}

+ (UIColor*)decodeColor:(short)code {

    switch (code) {
        case 0:
            return [UIColor purpleColor];
        case 1:
            return [UIColor blueColor];
        case 2:
            return [UIColor greenColor];
        default:
            return [UIColor whiteColor];
    }
}



@end
