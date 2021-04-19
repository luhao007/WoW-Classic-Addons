# Lib: DogTag-Unit-3.0

## [v90000.5](https://github.com/parnic/LibDogTag-Unit-3.0/tree/v90000.5) (2021-03-23)
[Full Changelog](https://github.com/parnic/LibDogTag-Unit-3.0/compare/v90000.4...v90000.5) [Previous Releases](https://github.com/parnic/LibDogTag-Unit-3.0/releases)

- Update TOC  
- Update outdated tags (#5)  
- Change to use manual iteration  
    It seems like FireEvent() can potentially invalidate the unit entries in  
    normalUnitsWackyDependents, so extract the next key before calling it.  
    Fixes #4  
