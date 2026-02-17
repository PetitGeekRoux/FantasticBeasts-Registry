//
//  MOMClassificationEngine.m
//  FantasticBeasts
//
//  Created by Kevin St-Pierre on 2026-02-14.
//

#import "MOMClassificationEngine.h"

@implementation MOMClassificationEngine

+ (NSInteger)calculateClassificationWithAggressiveness:(double)aggressiveness
                                            rarity:(double)rarity
                                    controllability:(double)controllability
                                       intelligence:(double)intelligence {

	double score = (aggressiveness * 0.4) +
                   (rarity * 0.2) +
                   ((1.0 - controllability) * 0.3) + 
                   (intelligence * 0.1);
    

	if (score < 0.2) return 1;
    if (score < 0.4) return 2;
    if (score < 0.6) return 3;
    if (score < 0.8) return 4;
    return 5;
}

+ (NSString *)descriptionForClassification:(NSInteger)classification {
    switch (classification) {
        case 1: return @"Boring - No threat";
        case 2: return @"Harmless - May be domesticated";
        case 3: return @"Manageable - Skilled wizard required";
        case 4: return @"Dangerous - Specialized knowledge needed";
        case 5: return @"Killer - Impossible to train or domesticate";
        default: return @"Unknown classification";
    }
}

@end
