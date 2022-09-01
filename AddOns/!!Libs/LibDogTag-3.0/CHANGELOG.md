# Lib: DogTag-3.0

## [v90200.1](https://github.com/parnic/LibDogTag-3.0/tree/v90200.1) (2022-03-22)
[Full Changelog](https://github.com/parnic/LibDogTag-3.0/compare/v90100.1...v90200.1) [Previous Releases](https://github.com/parnic/LibDogTag-3.0/releases)

- Update TOCs  
- Update TOCs  
- Fix syntax coloring for 9.0-based clients. (#7)  
    * Fix syntax coloring for 9.0-based clients.  
    Caused by this change in WoW 9.0:  
    > The `|r` escape sequence now pops nested `|c` color sequences in-order, instead of resetting the text to the default color.  
    Unfortunately, it seems this color sequence stack is very small. Seemed to only be around 8 colors max before it gives up and gets stuck on a color permanently unless you manually `|r`eset the color.  
    * Fixes so docs look good again.  
    * Different approach that shouldn't break non-9.0 clients like classic.  
    * Cleanup  
    * Right, those bits aren't supposed to retain the brackets around them.  
- Fixes https://github.com/ascott18/TellMeWhen/issues/1910 - properly reconstitute UTF8 strings rather than arbitrarily turning all bytes above 127 into escape sequences. (#6)  
