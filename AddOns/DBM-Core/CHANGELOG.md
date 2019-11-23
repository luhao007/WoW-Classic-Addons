# Deadly Boss Mods Core

## [1.13.21](https://github.com/DeadlyBossMods/DBM-Classic/tree/1.13.21) (2019-11-22)
[Full Changelog](https://github.com/DeadlyBossMods/DBM-Classic/compare/1.13.20...1.13.21)

- Set Hotfix notices to the bosses that now use syncing, post combat log nerf, so users on older mods will know an important updates exists  
    Bump Core version for new release  
- Also add Onyxia's fear to sync list  
- First batch of mod updates to deal with combat log nerf. Most bosses/mods should be fine with a 50 yard limit but these were outliers that needed updates.  
     - Updated Kazzak world boss mod to sync mark target, so it's not limitted by 50 yard combat log range.  
     - Updated Baron Geddon mod to sync bomb target so it's not limitted by combat log range (in most cases it won't be, but you never know with some odd spread strats)  
     - Updated Majordomo mod to sync Teleport, Magic Reflect, and Melee Reflect spells so mod isn't limitted by limited combat log range, since boss favors a lot of spreading.  
     - Updated Ragnaros mod to now sync Wrath of ragnaros cast, so you never miss a warning/timer do to combat log range limit.  
     - Updated Onyxia mod to now sync Fireball casts, so when raid is massively spread out during Phase 2, you'll still get alerts for it even if she's > 50 yards away.  
- Fix lua error, closes #25  
