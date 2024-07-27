## Support me
<a href="https://www.paypal.com/donate/?hosted_button_id=NYWTBA4XM6ZS6" alt="Paypal">
  <img src="https://www.paypalobjects.com/en_US/BE/i/btn/btn_donateCC_LG.gif" />
</a>
<a href="https://www.patreon.com/Krowi" alt="Patreon">
  <img src="https://raw.githubusercontent.com/codebard/patron-button-and-widgets-by-codebard/master/images/become_a_patron_button.png" />
</a>
<a href='https://ko-fi.com/E1E6G64LS' target='_blank'><img height='36' style='border:0px;height:36px;' src='https://storage.ko-fi.com/cdn/kofi2.png?v=3' border='0' alt='Buy Me a Coffee at ko-fi.com' /></a>

## Purpose
This library was created to make showing users curated information via a fixed template. This library was initially created for personal use so documentation is lacking.

## Example
```lua
local tutorials = LibStub("Krowi_Tutorials-3.0");
local featuresTutorial = tutorials:New("FeaturesTutorial", SavedData);
featuresTutorial:SetFrameTitle("Your title");
local pages = {};
tinsert(pages, {
	Image = "The image",
	ImageSize = {930, 158},
	SubTitle = "The page subtitles",
	Text = "The page text"
});
featuresTutorial:SetPages(pages);
featuresTutorial:SetImageMargin(10);
featuresTutorial:SetTextMargin({10, 0, 10, 20});
featuresTutorial:ShowTutorial(1); -- Show page 1
```