//
//  MOMClassificationEngine.h
//  FantasticBeasts
//
//  Created by Kevin St-Pierre on 2026-02-14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MOMClassificationEngine : NSObject

+ (NSInteger)calculateClassificationWithAggressiveness:(double)aggressiveness
												rarity:(double)rarity
									   controllability:(double)controllability
										  intelligence:(double)intelligence;

+ (NSString *)descriptionForClassification:(NSInteger)classification;

@end

NS_ASSUME_NONNULL_END
