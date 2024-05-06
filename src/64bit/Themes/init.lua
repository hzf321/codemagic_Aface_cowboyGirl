require "Themes/Pngs"
require "Controllers/ThemeControl"

require "Themes/base/component/ThemeBaseViewControlDelegate"



require "Themes/base/component/ThemeBaseCollectMapViewControl"
require "Themes/base/component/ThemeBaseMapGame_33"
require "Themes/base/component/ThemeBaseSlotGame"
require "Themes/base/component/ThemeBaseWheelGame"
-- require "Themes/base/component/ThemeBaseWheelViewControl"
-- require "Themes/base/component/ThemeBaseWheelView"
require "Themes/base/component/ThemeBaseStoreVControl"
require "Themes/base/component/ThemeBaseStoreView"

require "Themes/base/ThemeBaseView"
require "Themes/base/ThemeBaseJackpotControl"
require "Themes/base/ThemeBaseTransitionControl"
require "Themes/base/ThemeBaseAudioControl"
require "Themes/base/ThemeBaseBonusControl"
require "Themes/base/ThemeBaseFreeControl"
require "Themes/base/ThemeBaseViewControl"


require "Themes/base/ThemeBaseBetControl"
-- require "Themes/base/ThemeBaseStoreGameTipsDialog"


THEME_LIST =  -- class 类名， controller（define 代表ThemeControl）， scale 代表缩放系数，  resourceId 主题使用的资源id，   headerStyle header类型选择 ， name 主题名字，  chooseBetId bet选择界面资源id， loadingId 进入主题的loading的界面资源id
{
	-- 普通房
	[101]	= {['class'] = "ThemeElephantFortune",			['basebet'] = 7500, 	['scale'] = 1, ['resourceId'] = 101, ['headerStyle'] = 5, ['name'] = "LION TREASURE", 	         ['chooseBetId'] = 101, ['loadingId'] = 101, ["portrait"] = 0,["questScale"] = 1   , ["highLimit"] = 0},
	[102]   = {['class'] = "ThemeLuckyDrums", 				['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 102, ['headerStyle'] = 3, ['name'] = "FORTUNE GONG", 	 	     ['chooseBetId'] = 102, ['loadingId'] = 102, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 0},
	[103]   = {['class'] = "ThemeBulkyLink", 		    	['basebet'] = 8000, 	['scale'] = 1, ['resourceId'] = 103, ['headerStyle'] = 5, ['name'] = "DANCING LION",    		 ['chooseBetId'] = 103, ['loadingId'] = 103, ["portrait"] = 0,["questScale"] = 1   , ["highLimit"] = 0},
	[105]   = {['class'] = "ThemeWildFieryJackpots", 		['basebet'] = 6000, 	['scale'] = 1, ['resourceId'] = 105, ['headerStyle'] = 3, ['name'] = "HIGH POWER JACKPOTS",      ['chooseBetId'] = 105, ['loadingId'] = 105, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 0},
	[106]   = {['class'] = "ThemeFuDaoCaiDao", 				['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 106, ['headerStyle'] = 3, ['name'] = "EASTERN RICHES", 	 	     ['chooseBetId'] = 106, ['loadingId'] = 106, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 0},
	[107]   = {['class'] = "ThemeCashWheelDeluxe", 	    	['basebet'] = 7500, 	['scale'] = 1, ['resourceId'] = 107, ['headerStyle'] = 3, ['name'] = "FORTUNE WHEEL DELUXE",     ['chooseBetId'] = 107, ['loadingId'] = 107, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 0},
	[108]   = {['class'] = "ThemeChiefOfTheGods", 			['basebet'] = 7500, 	['scale'] = 1, ['resourceId'] = 108, ['headerStyle'] = 5, ['name'] = "THOR", 			 	     ['chooseBetId'] = 108, ['loadingId'] = 108, ["portrait"] = 0,["questScale"] = 1   , ["highLimit"] = 0},
	[109]   = {['class'] = "ThemeEpicLinkCrystalDeluxe", 	['basebet'] = 5000, 	['scale'] = 1, ['resourceId'] = 109, ['headerStyle'] = 5, ['name'] = "JEWELS NIGHT", 	 	     ['chooseBetId'] = 109, ['loadingId'] = 109, ["portrait"] = 0,["questScale"] = 1   , ["highLimit"] = 0},
	[110]   = {['class'] = "ThemeHephaestusUnleashed", 		['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 110, ['headerStyle'] = 3, ['name'] = "HEPHAESTUS", 			     ['chooseBetId'] = 110, ['loadingId'] = 110, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 0},
	[111]   = {['class'] = "ThemeEpicLinkGoldReelBurst", 	['basebet'] = 5000, 	['scale'] = 1, ['resourceId'] = 111, ['headerStyle'] = 5, ['name'] = "GOLD BURST", 	 		     ['chooseBetId'] = 111, ['loadingId'] = 111, ["portrait"] = 0,["questScale"] = 1   , ["highLimit"] = 0},
	[112]   = {['class'] = "ThemeRapidPayUltra", 			['basebet'] = 5000, 	['scale'] = 1, ['resourceId'] = 112, ['headerStyle'] = 3, ['name'] = "EGYPTIAN FANTASY", 	     ['chooseBetId'] = 112, ['loadingId'] = 112, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 0},
	[113]   = {['class'] = "ThemeQuickHitPlatinumPlus", 	['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 113, ['headerStyle'] = 3, ['name'] = "RAPID PAY PLATINUM", 	     ['chooseBetId'] = 113, ['loadingId'] = 113, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 0},
	[114]   = {['class'] = "ThemeCandyMagic", 	        	['basebet'] = 5000, 	['scale'] = 1, ['resourceId'] = 114, ['headerStyle'] = 5, ['name'] = "CANDY MAGIC", 	 	     ['chooseBetId'] = 114, ['loadingId'] = 114, ["portrait"] = 0,["questScale"] = 1   , ["highLimit"] = 0},
	[115]   = {['class'] = "ThemeMajesticPanda", 			['basebet'] = 5000, 	['scale'] = 1, ['resourceId'] = 115, ['headerStyle'] = 3, ['name'] = "REGAL TIGER", 	 	     ['chooseBetId'] = 115, ['loadingId'] = 115, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 0},
	[116]   = {['class'] = "ThemeHaidiBierHaus", 			['basebet'] = 5000, 	['scale'] = 1, ['resourceId'] = 116, ['headerStyle'] = 3, ['name'] = "LEPRECHAUN'S COINS", 	     ['chooseBetId'] = 116, ['loadingId'] = 116, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 0},
	[117]   = {['class'] = "ThemeFiveTreasures", 			['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 117, ['headerStyle'] = 3, ['name'] = "BRILLIANT TREASURES", 	 ['chooseBetId'] = 117, ['loadingId'] = 117, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 0},
	[118]   = {['class'] = "ThemeMammothGrand", 			['basebet'] = 6000, 	['scale'] = 1, ['resourceId'] = 118, ['headerStyle'] = 3, ['name'] = "MAMMOTH GRAND", 	 	     ['chooseBetId'] = 118, ['loadingId'] = 118, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 0},
	[119]   = {['class'] = "ThemeCandyMagicGrand", 			['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 119, ['headerStyle'] = 3, ['name'] = "CANDY MAGIC GRAND", 	     ['chooseBetId'] = 119, ['loadingId'] = 119, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 0},
	[120]   = {['class'] = "ThemeSpinItGrand", 				['basebet'] = 5000, 	['scale'] = 1, ['resourceId'] = 120, ['headerStyle'] = 3, ['name'] = "WINNER'S PARADISE", 	     ['chooseBetId'] = 120, ['loadingId'] = 120, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 0},
	[121]   = {['class'] = "ThemeFortuneKitty", 		    ['basebet'] = 5000, 	['scale'] = 1, ['resourceId'] = 121, ['headerStyle'] = 5, ['name'] = "MANEKI NEKO RICHES", 	     ['chooseBetId'] = 121, ['loadingId'] = 121, ["portrait"] = 0,["questScale"] = 1   , ["highLimit"] = 0},
	[122]   = {['class'] = "ThemeBigMoney", 		        ['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 122, ['headerStyle'] = 5, ['name'] = "BIG MONEY FRENZY", 	     ['chooseBetId'] = 122, ['loadingId'] = 122, ["portrait"] = 0,["questScale"] = 1   , ["highLimit"] = 0},
	[123]   = {['class'] = "ThemeMermaid", 		    		['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 123, ['headerStyle'] = 5, ['name'] = "POWER OF SEA", 	         ['chooseBetId'] = 123, ['loadingId'] = 123, ["portrait"] = 0,["questScale"] = 1   , ["highLimit"] = 0},
	[124]   = {['class'] = "ThemeSmashPinata", 	    		['basebet'] = 6000, 	['scale'] = 1, ['resourceId'] = 124, ['headerStyle'] = 5, ['name'] = "HAPPY PIÑATA FIESTA",      ['chooseBetId'] = 124, ['loadingId'] = 124, ["portrait"] = 0,["questScale"] = 1   , ["highLimit"] = 0},
	[125]   = {['class'] = "ThemeSplendidIsland", 			['basebet'] = 5000, 	['scale'] = 1, ['resourceId'] = 125, ['headerStyle'] = 3, ['name'] = "SPLENDID ISLAND", 	     ['chooseBetId'] = 125, ['loadingId'] = 125, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 0},
	[126]   = {['class'] = "ThemeMagicJackpotVault", 		['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 126, ['headerStyle'] = 5, ['name'] = "MAGIC JACKPOT VAULT",      ['chooseBetId'] = 126, ['loadingId'] = 126, ["portrait"] = 0,["questScale"] = 1   , ["highLimit"] = 0},
	[127]   = {['class'] = "ThemeMrCashFrenzy", 		    ['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 127, ['headerStyle'] = 5, ['name'] = "MR. Golden Slots", 	     ['chooseBetId'] = 127, ['loadingId'] = 127, ["portrait"] = 0,["questScale"] = 1   , ["highLimit"] = 0},
	[128]   = {['class'] = "ThemeRoyalPuppies", 			['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 128, ['headerStyle'] = 3, ['name'] = "ROYAL PUPPIES", 	 	     ['chooseBetId'] = 128, ['loadingId'] = 128, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 0},
	[129]   = {['class'] = "ThemeBigMoneyHolidayFrenzy", 	['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 129, ['headerStyle'] = 3, ['name'] = "BIG MONEY HOLIDAY FRENZY", ['chooseBetId'] = 129, ['loadingId'] = 129, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 0},
	[130]   = {['class'] = "ThemeMammothGrandGems", 		['basebet'] = 6000, 	['scale'] = 1, ['resourceId'] = 130, ['headerStyle'] = 3, ['name'] = "MAMMOTH GRAND GEMS", 		 ['chooseBetId'] = 130, ['loadingId'] = 130, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 0},
	[131]   = {['class'] = "ThemeDiamondsLifeDeluxe", 		['basebet'] = 5000, 	['scale'] = 1, ['resourceId'] = 131, ['headerStyle'] = 3, ['name'] = "JEWELS NIGHT DELUXE", 	 ['chooseBetId'] = 131, ['loadingId'] = 131, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 0},
	[132]   = {['class'] = "ThemeHexoGems", 				['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 132, ['headerStyle'] = 3, ['name'] = "MAJESTIC PANDA", 	 		 ['chooseBetId'] = 132, ['loadingId'] = 132, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 0},
	[133]   = {['class'] = "ThemeMagicForest", 				['basebet'] = 6000, 	['scale'] = 1, ['resourceId'] = 133, ['headerStyle'] = 5, ['name'] = "SPIRITS OF PIXIES", 	 	 ['chooseBetId'] = 133, ['loadingId'] = 133, ["portrait"] = 0,["questScale"] = 1   , ["highLimit"] = 0},
	[134]   = {['class'] = "ThemeTwinFireFrenzy", 			['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 134, ['headerStyle'] = 3, ['name'] = "DANCING CARNIVAL", 	 	 ['chooseBetId'] = 134, ['loadingId'] = 134, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 0},
	[135]   = {['class'] = "ThemeJinSeDao", 		        ['basebet'] = 5000, 	['scale'] = 1, ['resourceId'] = 135, ['headerStyle'] = 3, ['name'] = "JALAPEÑO DELIGHT", 	     ['chooseBetId'] = 135, ['loadingId'] = 135, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 0},
	[136]   = {['class'] = "ThemeFortuneGongV", 		    ['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 136, ['headerStyle'] = 3, ['name'] = "HOT HOT DRUMS", 	         ['chooseBetId'] = 136, ['loadingId'] = 136, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 0},
	[137]   = {['class'] = "ThemeBlockBonanza", 		    ['basebet'] = 5000, 	['scale'] = 1, ['resourceId'] = 137, ['headerStyle'] = 3, ['name'] = "LET'S PARTY", 	         ['chooseBetId'] = 137, ['loadingId'] = 137, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 0},
	[138]   = {['class'] = "ThemeMightyCash", 		        ['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 138, ['headerStyle'] = 5, ['name'] = "WESTERN CASH", 	         ['chooseBetId'] = 138, ['loadingId'] = 138, ["portrait"] = 0,["questScale"] = 1 , ["highLimit"] = 0},
	[139]   = {['class'] = "ThemeGoldenEgypt", 				['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 139, ['headerStyle'] = 5, ['name'] = "GORGEOUS GODDESS", 	 	 ['chooseBetId'] = 139, ['loadingId'] = 139, ["portrait"] = 0,["questScale"] = 1   , ["highLimit"] = 0},
	[140]   = {['class'] = "ThemeCashClimb", 		    	['basebet'] = 5000, 	['scale'] = 1, ['resourceId'] = 140, ['headerStyle'] = 3, ['name'] = "THUNDERING MUSTANG", 	     ['chooseBetId'] = 140, ['loadingId'] = 140, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 0},
	[141]   = {['class'] = "ThemeCleopatraGold", 		    ['basebet'] = 6000, 	['scale'] = 1, ['resourceId'] = 141, ['headerStyle'] = 3, ['name'] = "GOLDEN ISLAND TREASURE", 	 ['chooseBetId'] = 141, ['loadingId'] = 141, ["portrait"] = 1,["questScale"] = 1, ["highLimit"] = 0},
	[142]   = {['class'] = "ThemeMammon", 		    		['basebet'] = 7500, 	['scale'] = 1, ['resourceId'] = 142, ['headerStyle'] = 5, ['name'] = "FORTUNE WILD", 	         ['chooseBetId'] = 142, ['loadingId'] = 142, ["portrait"] = 0,["questScale"] = 1   , ["highLimit"] = 0},
	[143]   = {['class'] = "ThemeLotsaSlots", 		        ['basebet'] = 8000, 	['scale'] = 1, ['resourceId'] = 143, ['headerStyle'] = 3, ['name'] = "SLOTS TOWER", 	         ['chooseBetId'] = 143, ['loadingId'] = 143, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 0},
	[144]   = {['class'] = "ThemeEgyptQueen", 		        ['basebet'] = 6000, 	['scale'] = 1, ['resourceId'] = 144, ['headerStyle'] = 3, ['name'] = "MYSTERIOUS SCARAB", 	     ['chooseBetId'] = 144, ['loadingId'] = 144, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 0},
	[145]   = {['class'] = "ThemeHeroAndDragon", 			['basebet'] = 6000, 	['scale'] = 1, ['resourceId'] = 145, ['headerStyle'] = 5, ['name'] = "INVINCIBLE BRAVE", 	 	 ['chooseBetId'] = 145, ['loadingId'] = 145, ["portrait"] = 0,["questScale"] = 1   , ["highLimit"] = 0},
	[146]   = {['class'] = "ThemeDoubleCash", 			    ['basebet'] = 5000, 	['scale'] = 1, ['resourceId'] = 146, ['headerStyle'] = 5, ['name'] = "PUNK FANTASY", 	 	     ['chooseBetId'] = 146, ['loadingId'] = 146, ["portrait"] = 0,["questScale"] = 1   , ["highLimit"] = 0},
	[147]   = {['class'] = "ThemeGorilla", 			    	['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 147, ['headerStyle'] = 5, ['name'] = "SUPERB GORILLA", 	 	     ['chooseBetId'] = 147, ['loadingId'] = 147, ["portrait"] = 0,["questScale"] = 1   , ["highLimit"] = 0},
	[148]   = {['class'] = "ThemeLuckyFunnyKitties", 		['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 148, ['headerStyle'] = 5, ['name'] = "LUCKY FUNNY KITTIES", 	 ['chooseBetId'] = 148, ['loadingId'] = 148, ["portrait"] = 0,["questScale"] = 1   , ["highLimit"] = 0},
	[149]   = {['class'] = "ThemeBlazingGirl", 				['basebet'] = 6000, 	['scale'] = 1, ['resourceId'] = 149, ['headerStyle'] = 3, ['name'] = "Mia's Beer Hall", 	 	 ['chooseBetId'] = 149, ['loadingId'] = 149, ["portrait"] = 1,["questScale"] = 1   , ["highLimit"] = 0},
	[150]   = {['class'] = "ThemeCrazyMoney", 		        ['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 150, ['headerStyle'] = 5, ['name'] = "CASH FEVER", 	             ['chooseBetId'] = 150, ['loadingId'] = 150, ["portrait"] = 0,["questScale"] = 1   , ["highLimit"] = 0},
	[151]   = {['class'] = "ThemeFrenzy4Classics", 			['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 151, ['headerStyle'] = 3, ['name'] = "FRENZY 4 CLASSICS", 	 	 ['chooseBetId'] = 151, ['loadingId'] = 151, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 0},
	[152]   = {['class'] = "ThemeJackpotParty",  			['basebet'] = 7500, 	['scale'] = 1, ['resourceId'] = 152, ['headerStyle'] = 5, ['name'] = "GANGSTER CITY", 	 	     ['chooseBetId'] = 152, ['loadingId'] = 152, ["portrait"] = 0,["questScale"] = 1 , ["highLimit"] = 0},
	[153]   = {['class'] = "ThemeWizards", 					['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 153, ['headerStyle'] = 3, ['name'] = "WITCH OF FORTUNE", 	 	 ['chooseBetId'] = 153, ['loadingId'] = 153, ["portrait"] = 1,["questScale"] = 1   , ["highLimit"] = 0},
	[154]   = {['class'] = "ThemeHappyHarvest", 			['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 154, ['headerStyle'] = 5, ['name'] = "HAPPY HARVEST", 	 	 	 ['chooseBetId'] = 154, ['loadingId'] = 154, ["portrait"] = 0,["questScale"] = 1   , ["highLimit"] = 0},
	[155]   = {['class'] = "ThemeZombie", 				    ['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 155, ['headerStyle'] = 3, ['name'] = "ZOMBIE NATION", 	 	     ['chooseBetId'] = 155, ['loadingId'] = 155, ["portrait"] = 1,["questScale"] = 1   , ["highLimit"] = 0},
	[156]	= {['class'] = "ThemeDiamondDiamond",			['basebet'] = 10000,	['scale'] = 1, ['resourceId'] = 156, ['headerStyle'] = 5, ['name'] = "DIAMOND DIAMOND",          ['chooseBetId'] = 156, ['loadingId'] = 156, ["portrait"] = 0,["questScale"] = 1, ["highLimit"] = 0},
	[157]   = {['class'] = "ThemeFairypyMania", 		    ['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 157, ['headerStyle'] = 3, ['name'] = "THEME PARK BLAST", 	     ['chooseBetId'] = 157, ['loadingId'] = 157, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 0},
	[158]   = {['class'] = "ThemeMightyDouble", 		    ['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 158, ['headerStyle'] = 3, ['name'] = "ICY WOLF",  				 ['chooseBetId'] = 158, ['loadingId'] = 158, ["portrait"] = 1,["questScale"] = 1, ["highLimit"] = 0},
	[159]   = {['class'] = "ThemeBonnieAndClyde", 		    ['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 159, ['headerStyle'] = 3, ['name'] = "THE LEGACY OF BONNIE AND CLYDE",  ['chooseBetId'] = 159, ['loadingId'] = 159, ["portrait"] = 1,["questScale"] = 1, ["highLimit"] = 0},
	[160]   = {['class'] = "ThemeSushiLover", 		        ['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 160, ['headerStyle'] = 3, ['name'] = "SUSHI LOVER",               ['chooseBetId'] = 160, ['loadingId'] = 160, ["portrait"] = 1,["questScale"] = 1, ["highLimit"] = 0},
	[161]	= {['class'] = "ThemeStarStax",					['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 161, ['headerStyle'] = 3, ['name'] = "PRINCE CHARMING",		     ['chooseBetId'] = 161, ['loadingId'] = 161, ["portrait"] = 1,["questScale"] = 1, ["highLimit"] = 0},
	[162]	= {['class'] = "ThemeBubbleBlast",				['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 162, ['headerStyle'] = 3, ['name'] = "SUPER WICKED BLAST",		 ['chooseBetId'] = 162, ['loadingId'] = 162, ["portrait"] = 1,["questScale"] = 1, ["highLimit"] = 0},
	[163]   = {['class'] = "ThemeMermaidRising", 		    ['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 163, ['headerStyle'] = 3, ['name'] = "QUEEN OF SEA", 	  	   	['chooseBetId'] = 163, ['loadingId'] = 163, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 0},
	[164]   = {['class'] = "ThemeFireFortune",              ['basebet'] = 10000,    ['scale'] = 1, ['resourceId'] = 164, ['headerStyle'] = 5, ['name'] = "GLORY OF THE MAYA",        ['chooseBetId'] = 164, ['loadingId'] = 164, ['portrait'] = 0,['questScale'] = 1, ['highLimit'] = 0},
	[165]   = {['class'] = "ThemeWheelShoot",               ['basebet'] = 10000,    ['scale'] = 1, ['resourceId'] = 165, ['headerStyle'] = 5, ['name'] = "THANKSGIVING HOLIDAY FRENZY",    ['chooseBetId'] = 165, ['loadingId'] = 165, ['portrait'] = 0,['questScale'] = 1, ['highLimit'] = 0},
	[166]   = {['class'] = "ThemeRisingRiches",             ['basebet'] = 10000,    ['scale'] = 1, ['resourceId'] = 166, ['headerStyle'] = 5, ['name'] = "GOLDEN 70s",           	 ['chooseBetId'] = 166, ['loadingId'] = 166, ['portrait'] = 0,['questScale'] = 1, ['highLimit'] = 0},
	[167]   = {['class'] = "ThemeLuckyFishmania",           ['basebet'] = 10000,    ['scale'] = 1, ['resourceId'] = 167, ['headerStyle'] = 5, ['name'] = "LUCKY FISHMANIA",          ['chooseBetId'] = 167, ['loadingId'] = 167, ['portrait'] = 0,['questScale'] = 1, ['highLimit'] = 0},
	[168]   = {['class'] = "ThemeChristmas",                ['basebet'] = 10000,    ['scale'] = 1, ['resourceId'] = 168, ['headerStyle'] = 3, ['name'] = "WHERE IS THE SANTA CLAUS", ['chooseBetId'] = 168, ['loadingId'] = 168, ['portrait'] = 1,['questScale'] = 1, ['highLimit'] = 0},
	[169]   = {['class'] = "ThemeIndianaJones",             ['basebet'] = 10000,    ['scale'] = 1, ['resourceId'] = 169, ['headerStyle'] = 3, ['name'] = "TREASURE JUNGLE",          ['chooseBetId'] = 169, ['loadingId'] = 169, ['portrait'] = 1,['questScale'] = 1, ['highLimit'] = 0},
	[170]   = {['class'] = "ThemeSolarDisc",                ['basebet'] = 10000,    ['scale'] = 1, ['resourceId'] = 170, ['headerStyle'] = 5, ['name'] = "INCREDIBLE WOMAN",         ['chooseBetId'] = 170, ['loadingId'] = 170, ['portrait'] = 0,['questScale'] = 1, ['highLimit'] = 0},
	[171]   = {['class'] = "ThemeBuffaloXtreme", 		    ['basebet'] = 6000, 	['scale'] = 1, ['resourceId'] = 171, ['headerStyle'] = 3, ['name'] = "JUNGLE KING", 	 		 ['chooseBetId'] = 171, ['loadingId'] = 171, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 0},
	[172]   = {['class'] = "ThemeTowerStack",               ['basebet'] = 10000,    ['scale'] = 1, ['resourceId'] = 172, ['headerStyle'] = 3, ['name'] = "CASH FEVER DELUXE",        ['chooseBetId'] = 172, ['loadingId'] = 172, ['portrait'] = 1,['questScale'] = 1, ['highLimit'] = 0},
	[173]   = {['class'] = "ThemeSunGoddess",               ['basebet'] = 10000,    ['scale'] = 1, ['resourceId'] = 173, ['headerStyle'] = 3, ['name'] = "SUN GODDESS",              ['chooseBetId'] = 173, ['loadingId'] = 173, ['portrait'] = 1,['questScale'] = 1, ['highLimit'] = 0},
	[174]   = {['class'] = "ThemeDracula",                  ['basebet'] = 10000,    ['scale'] = 1, ['resourceId'] = 174, ['headerStyle'] = 5, ['name'] = "MANIAC DRACULA",           ['chooseBetId'] = 174, ['loadingId'] = 174, ['portrait'] = 0,['questScale'] = 1, ['highLimit'] = 0},
	[175]   = {['class'] = "ThemeGameFortune", 		    	['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 175, ['headerStyle'] = 3, ['name'] = "FORTUNE GENIE", 	 		 ['chooseBetId'] = 175, ['loadingId'] = 175, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 0},
	[176]   = {['class'] = "ThemeCupid", 		    	    ['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 176, ['headerStyle'] = 3, ['name'] = "CUPID'S CRUSH", 	 		 ['chooseBetId'] = 176, ['loadingId'] = 176, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 0},
	[177]   = {['class'] = "ThemePowerOfDragons",           ['basebet'] = 10000,    ['scale'] = 1, ['resourceId'] = 177, ['headerStyle'] = 3, ['name'] = "POWER OF DRAGONS",         ['chooseBetId'] = 177, ['loadingId'] = 177, ['portrait'] = 1,['questScale'] = 1, ['highLimit'] = 0},
	[178]   = {['class'] = "ThemeMagicNile",                ['basebet'] = 10000,    ['scale'] = 1, ['resourceId'] = 178, ['headerStyle'] = 3, ['name'] = "MONSTER CASH",             ['chooseBetId'] = 178, ['loadingId'] = 178, ['portrait'] = 1,['questScale'] = 1, ['highLimit'] = 0},
	[179]   = {['class'] = "ThemeLeprechaunGoldSlot", 		['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 179, ['headerStyle'] = 3, ['name'] = "MOMENT OF WONDER", 	     ['chooseBetId'] = 179, ['loadingId'] = 179, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 0},
	[180]   = {['class'] = "ThemeZorro",                    ['basebet'] = 10000,    ['scale'] = 1, ['resourceId'] = 180, ['headerStyle'] = 3, ['name'] = "MASKED HERO",   	         ['chooseBetId'] = 180, ['loadingId'] = 180, ['portrait'] = 1,['questScale'] = 0.95, ['highLimit'] = 0},
	[181]   = {['class'] = "ThemePussBingo",                ['basebet'] = 10000,    ['scale'] = 1, ['resourceId'] = 181, ['headerStyle'] = 3, ['name'] = "BINGO MEOW",               ['chooseBetId'] = 181, ['loadingId'] = 181, ['portrait'] = 1,['questScale'] = 1, ['highLimit'] = 0},
	[182]   = {['class'] = "ThemeHexBreak",                 ['basebet'] = 10000,    ['scale'] = 1, ['resourceId'] = 182, ['headerStyle'] = 3, ['name'] = "GRAND GEMINI",             ['chooseBetId'] = 182, ['loadingId'] = 182, ['portrait'] = 1,['questScale'] = 1, ['highLimit'] = 0},
	[183]   = {['class'] = "ThemeSpeedyFire", 		    	['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 183, ['headerStyle'] = 3, ['name'] = "SPEEDY FIRE", 	 		 ['chooseBetId'] = 183, ['loadingId'] = 183, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 0},
	[184]   = {['class'] = "ThemeDiamondForest", 		    ['basebet'] = 7500, 	['scale'] = 1, ['resourceId'] = 184, ['headerStyle'] = 3, ['name'] = "DIAMOND FOREST", 	 		 ['chooseBetId'] = 184, ['loadingId'] = 184, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 0},
	[185]   = {['class'] = "ThemeFortuneWildDeluxe", 		['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 185, ['headerStyle'] = 3, ['name'] = "FORTUNE WILD DELUXE", 	 ['chooseBetId'] = 185, ['loadingId'] = 185, ["portrait"] = 1,["questScale"] = 1, ["highLimit"] = 0},
	[186]   = {['class'] = "ThemeCleopatra",         		['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 186, ['headerStyle'] = 3, ['name'] = "GORGEOUS CLEOPATRA", 	   	 ['chooseBetId'] = 186, ['loadingId'] = 186, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 0},
	[187]   = {['class'] = "ThemeCashFalls",         		['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 187, ['headerStyle'] = 3, ['name'] = "YEAR OF THE RAT", 	 	 ['chooseBetId'] = 187, ['loadingId'] = 187, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 0},
	[188]   = {['class'] = "ThemeZeus",         			['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 188, ['headerStyle'] = 3, ['name'] = "KING OF OLYMPUS", 	 	 ['chooseBetId'] = 188, ['loadingId'] = 188, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 0},
	[189]   = {['class'] = "ThemeCupidII",         			['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 189, ['headerStyle'] = 3, ['name'] = "CUPID'S CRUSH DELUXE",	 ['chooseBetId'] = 189, ['loadingId'] = 189, ["portrait"] = 1,["questScale"] = 1, ["highLimit"] = 0},
	[190]   = {['class'] = "ThemeFireItUp", 		  	    ['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 190, ['headerStyle'] = 3, ['name'] = "SMOKIN' HOT RICHES", 	 	 ['chooseBetId'] = 190, ['loadingId'] = 190, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 0},
	[191]   = {['class'] = "ThemeMeDuSa", 		  	        ['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 191, ['headerStyle'] = 3, ['name'] = "RISING MEDUSA", 	 		 ['chooseBetId'] = 191, ['loadingId'] = 191, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 0},
	[192]   = {['class'] = "ThemeWildAustralia", 		  	['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 192, ['headerStyle'] = 3, ['name'] = "WILD AUSTRALIA",			 ['chooseBetId'] = 192, ['loadingId'] = 192, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 0},
	[193]   = {['class'] = "ThemeQuickHitRB", 		     	['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 193, ['headerStyle'] = 3, ['name'] = "SLOTS TOWER DELUXE",		 ['chooseBetId'] = 193, ['loadingId'] = 193, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 0},
	[194]   = {['class'] = "ThemePowerSlot", 		  	    ['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 194, ['headerStyle'] = 3, ['name'] = "ADVENTURES IN SPACE", 	 ['chooseBetId'] = 194, ['loadingId'] = 194, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 0},
	[195]   = {['class'] = "ThemeTwinStrike",               ['basebet'] = 10000,    ['scale'] = 1, ['resourceId'] = 195, ['headerStyle'] = 5, ['name'] = "FREEDOM EAGLE",            ['chooseBetId'] = 195, ['loadingId'] = 195, ['portrait'] = 0,['questScale'] = 1, ['highLimit'] = 0},
	[196]   = {['class'] = "ThemeFairyHollow",              ['basebet'] = 10000,    ['scale'] = 1, ['resourceId'] = 196, ['headerStyle'] = 5, ['name'] = "FIRE RICHES",              ['chooseBetId'] = 196, ['loadingId'] = 196, ['portrait'] = 0,['questScale'] = 1, ['highLimit'] = 0},
	[197]   = {['class'] = "ThemeSplendidIslandDeluxe", 	['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 197, ['headerStyle'] = 3, ['name'] = "SPLENDID ISLAND DELUXE", 	 ['chooseBetId'] = 197, ['loadingId'] = 197, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 0},
	[198]   = {['class'] = "ThemeTakeTheCake", 		      	['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 198, ['headerStyle'] = 3, ['name'] = "CIRCUS CARNIVAL",			 ['chooseBetId'] = 198, ['loadingId'] = 198, ["portrait"] = 1,["questScale"] = 1, ["highLimit"] = 0},
	[199]   = {['class'] = "ThemeGoldOfTenochtitlan",		['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 199, ['headerStyle'] = 5, ['name'] = "FORTUNE TRAIN", 	         ['chooseBetId'] = 199, ['loadingId'] = 199, ["portrait"] = 0,["questScale"] = 1 , ["highLimit"] = 0},
	[200]   = {['class'] = "ThemeBigThree",		            ['basebet'] = 30000, 	['scale'] = 1, ['resourceId'] = 200, ['headerStyle'] = 3, ['name'] = "BIG 3", 	                 ['chooseBetId'] = 200, ['loadingId'] = 200, ["portrait"] = 1,["questScale"] = 1, ["highLimit"] = 0},
	[201]   = {['class'] = "ThemeRockDisco",		        ['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 201, ['headerStyle'] = 3, ['name'] = "ROCK'N'DISCO", 	         ['chooseBetId'] = 201, ['loadingId'] = 201, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 0},
	[202]   = {['class'] = "ThemeFuDai",		            ['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 202, ['headerStyle'] = 3, ['name'] = "MEGA VAULT BILLIONAIRE", 	 ['chooseBetId'] = 202, ['loadingId'] = 202, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 0},
	[203]   = {['class'] = "ThemeSpaceCat_MainViewControl",		['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 203, ['headerStyle'] = 3, ['name'] = "SPACE CAT",['chooseBetId'] = 203, ['loadingId'] = 203, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 0, ["isNew"] = true}, -- SpaceCat/
	[204]   = {['class'] = "ThemeFrenzy2x2Classics", 		['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 204, ['headerStyle'] = 5, ['name'] = "FRENZY 2X2 CLASSICS", 	 ['chooseBetId'] = 204, ['loadingId'] = 204, ["portrait"] = 0,["questScale"] = 1 , ["highLimit"] = 0},
	[205]   = {['class'] = "ThemeStoneAgedTreasure", 		['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 205, ['headerStyle'] = 3, ['name'] = "STONE-AGED TREASURE", 	 ['chooseBetId'] = 205, ['loadingId'] = 205, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 0},
	[206]   = {['class'] = "DragonBattle/DragonBMain", 		['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 206,['headerStyle'] = 3, ['name'] = "DRAGON'S BATTLE", 	 	 ['chooseBetId'] = 206, ['loadingId'] = 206, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 0,["isNew2"] = true},
	[207]   = {['class'] = "ThemeFortureTrain",       	 	['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 207, ['headerStyle'] = 3, ['name'] = "FORTUNE TRAIN DELUXE", 	 ['chooseBetId'] = 207, ['loadingId'] = 207, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 0},
	[208]   = {['class'] = "ThemeSpinItGrandNew", 			['basebet'] = 5000, 	['scale'] = 1, ['resourceId'] = 208, ['headerStyle'] = 3, ['name'] = "FORTUNE BABY",      	     ['chooseBetId'] = 208, ['loadingId'] = 208, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 0},
	[209]   = {['class'] = "ThemeGoblin", 		            ['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 209, ['headerStyle'] = 3, ['name'] = "GOBLIN'S TREASURE", 	     ['chooseBetId'] = 209, ['loadingId'] = 209, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 0},
	[210]   = {['class'] = "ThemeZombieNew", 				['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 210, ['headerStyle'] = 3, ['name'] = "OCEAN CLASH", 	 	     ['chooseBetId'] = 210, ['loadingId'] = 210, ["portrait"] = 1,["questScale"] = 1   , ["highLimit"] = 0},
	[211]   = {['class'] = "ThemePrinceCharmingDeluxe_MainViewControl",		['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 211, ['headerStyle'] = 3, ['name'] = "PRINCE CHARMING DELUXE", 	                 ['chooseBetId'] = 211, ['loadingId'] = 211, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 0, ["isNew2"] = true},
	[212]   = {['class'] = "ThemeAliceMain",		    ['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 212, ['headerStyle'] = 3, ['name'] = "ALICE'S ADVENTURE",        ['chooseBetId'] = 212, ['loadingId'] = 212, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 0}, -- Alice/
	[213]   = {['class'] = "ThemeCashMoolah",		        ['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 213, ['headerStyle'] = 3, ['name'] = "CASH MOOLAH",              ['chooseBetId'] = 213, ['loadingId'] = 213, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 0},
	[214]   = {['class'] = "ThemeHalloween_Control",	  ['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 214, ['headerStyle'] = 3, ['name'] = "SPOOKY HALLOWEEN",    ['chooseBetId'] = 214, ['loadingId'] = 214, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 0},
	[215]   = {['class'] = "ThemeLuckyBee_MainViewControl",	['basebet'] = 10000,	['scale'] = 1,	['resourceId'] = 215,	['headerStyle'] = 3,	['name'] = "LUCKY BEE",	['chooseBetId'] = 211,	['loadingId'] = 215,	["portrait"] = 1,	["questScale"] = 1 ,	["highLimit"] = 0,	["isNew2"] = true},
	[216]   = {['class'] = "ThemeIceQMain",    	['basebet'] = 10000,	['scale'] = 1, ['resourceId'] = 216, ['headerStyle'] = 5, ['name'] = "ICY QUEEN",	             ['chooseBetId'] = 216, ['loadingId'] = 216, ["portrait"] = 0,["questScale"] = 1 ,   ["highLimit"] = 0},
	[217]   = {['class'] = "ThemeZombieNation",	            ['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 217, ['headerStyle'] = 3, ['name'] = "ZOMBIE NATION",    ['chooseBetId'] = 217, ['loadingId'] = 217, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 0},
	[218]   = {['class'] = "ThemeTurkeyBlast",		        ['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 218, ['headerStyle'] = 3, ['name'] = "TURKEY BLAST",              ['chooseBetId'] = 218, ['loadingId'] = 218, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 0},
	[219]   = {['class'] = "ThemePirateP_MainViewControl", ['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 219, ['headerStyle'] = 3, ['name'] = "PELICAN QUEST",     ['chooseBetId'] = 219, ['loadingId'] = 219, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 0, ["isNew2"] = true},
	[220]   = {['class'] = "ThemeApollo_MainControl",['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 220, ['headerStyle'] = 3, ['name'] = "APOLLO",                   ['chooseBetId'] = 220, ['loadingId'] = 220, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 0, ["isNew2"] = true},
	[221]   = {['class'] = "ThemeCandyClash_MainViewControl", ['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 221, ['headerStyle'] = 3, ['name'] = "CANDY CLASH",     ['chooseBetId'] = 221, ['loadingId'] = 221, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 0, ["isNew2"] = true},
	[222]   = {['class'] = "ThemeChristmasMain",    	['basebet'] = 10000,	['scale'] = 1, ['resourceId'] = 222, ['headerStyle'] = 5, ['name'] = "SANTA MAGIC",	             ['chooseBetId'] = 222, ['loadingId'] = 222, ["portrait"] = 0,["questScale"] = 1 ,   ["highLimit"] = 0},
	[223]   = {['class'] = "ThemeMayaM_MainViewControl",    	['basebet'] = 10000,	['scale'] = 1, ['resourceId'] = 223, ['headerStyle'] = 5, ['name'] = "MAYAN MIRACLE ",	['chooseBetId'] = 223, ['loadingId'] = 223, ["portrait"] = 0,["questScale"] = 1 ,   ["highLimit"] = 0, ["isNew2"] = true},
	[224]   = {['class'] = "ThemeFQ_Main",		['basebet'] = 10000,	['scale'] = 1, ['resourceId'] = 224, ['headerStyle'] = 3, ['name'] = "FLAMING QUEEN",	         ['chooseBetId'] = 224, ['loadingId'] = 224, ["portrait"] = 1,["questScale"] = 1 ,   ["highLimit"] = 0, ["isNew2"] = true},
	[226]   = {['class'] = "ThemeLeapinLemurs",		        ['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 226, ['headerStyle'] = 5, ['name'] = "LEAPIN' LEMURS",              ['chooseBetId'] = 226, ['loadingId'] = 226, ["portrait"] = 0,["questScale"] = 1 , ["highLimit"] = 0},
	[225]   = {['class'] = "ThemeGoldRush_MainControl",	    ['basebet'] = 10000, 	['scale'] = 1, 		['resourceId'] = 225, 	['headerStyle'] = 5, 	['name'] = "GOLD RUSH WITH ROISIN",		['chooseBetId'] = 225,	['loadingId'] = 225, 	["portrait"] = 0,	["questScale"] = 1 , ["highLimit"] = 0, ["isNew2"] = true},
	[227]   = {['class'] = "ThemeEgyptianPharaonsMain",    	['basebet'] = 10000,	['scale'] = 1, ['resourceId'] = 227, ['headerStyle'] = 3, ['name'] = "RISE OF EGYPT",	             ['chooseBetId'] = 227, ['loadingId'] = 227, ["portrait"] = 1,["questScale"] = 1 ,   ["highLimit"] = 0},
	[228]   = {['class'] = "ThemeRisingPegasus",		    ['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 228, ['headerStyle'] = 3, ['name'] = "RISING PEGASUS",            ['chooseBetId'] = 228, ['loadingId'] = 228, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 0},
	[229]   = {['class'] = "ThemeRomanticQ_MainViewControl",	['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 229, ['headerStyle'] = 3, ['name'] = "ROMANTIC QUEEN",   ['chooseBetId'] = 229, ['loadingId'] = 229, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 0, ["isNew2"] = true},
	[230]   = {['class'] = "ThemeGRII_Main",    	['basebet'] = 10000,	['scale'] = 1, ['resourceId'] = 230, ['headerStyle'] = 3, ['name'] = "GOLD RUSH DELUXE",          ['chooseBetId'] = 230, ['loadingId'] = 230, ["portrait"] = 1,["questScale"] = 1 ,   ["highLimit"] = 0,["isNew2"] = true},
	[231]   = {['class'] = "ThemeMysteriousPixies_MainControl",    	['basebet'] = 10000,	['scale'] = 1, ['resourceId'] = 231, ['headerStyle'] = 5, ['name'] = "MYSTERIOUS PIXIES",          ['chooseBetId'] = 231, ['loadingId'] = 231, ["portrait"] = 0,["questScale"] = 1 ,   ["highLimit"] = 0,["isNew2"] = true},
	[232]   = {['class'] = "ThemeSummerSurfingMain", ['basebet'] = 10000,	['scale'] = 1, ['resourceId'] = 232, ['headerStyle'] = 5, ['name'] = "SURFERS PARADISE",          ['chooseBetId'] = 232, ['loadingId'] = 232, ["portrait"] = 0,["questScale"] = 1 ,   ["highLimit"] = 0},
	[233]   = {['class'] = "ThemeOrientalRiches_MainViewControl",    	['basebet'] = 10000,	['scale'] = 1, ['resourceId'] = 233, ['headerStyle'] = 5, ['name'] = "ORIENTAL RICHES",          ['chooseBetId'] = 233, ['loadingId'] = 233, ["portrait"] = 0,["questScale"] = 1 ,   ["highLimit"] = 0,["isNew2"] = true},
	[234]   = {['class'] = "ThemePengunB_MainViewControl",    	['basebet'] = 10000,	['scale'] = 1, ['resourceId'] = 234, ['headerStyle'] = 3, ['name'] = "PENGUIN'S BOUNTY",          ['chooseBetId'] = 234, ['loadingId'] = 234, ["portrait"] = 1,["questScale"] = 1 ,   ["highLimit"] = 0,["isNew2"] = true},
	[235]   = {['class'] = "ThemeWizardOfOz",		        ['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 235, ['headerStyle'] = 3, ['name'] = "LEGEND OF OZ",            ['chooseBetId'] = 235, ['loadingId'] = 235, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 0},
	[236]   = {['class'] = "EasterMain",             ['basebet'] = 10000,	['scale'] = 1, ['resourceId'] = 236, ['headerStyle'] = 5, ['name'] = "EASTER BONANZA",          ['chooseBetId'] = 236, ['loadingId'] = 236, ["portrait"] = 0,["questScale"] = 1 ,   ["highLimit"] = 0,["isNew2"] = true},
	[237]   = {['class'] = "ThemeCabinWoods_MainControl",       ['basebet'] = 10000,	['scale'] = 1, ['resourceId'] = 237, ['headerStyle'] = 5, ['name'] = "CABIN IN THE WOODS",      ['chooseBetId'] = 237, ['loadingId'] = 237, ["portrait"] = 0,["questScale"] = 1 ,   ["highLimit"] = 0,["isNew2"] = true},
	[238]   = {['class'] = "CannonBallMain",             ['basebet'] = 10000,	['scale'] = 1, ['resourceId'] = 238, ['headerStyle'] = 5, ['name'] = "PIGGY RICHES",          ['chooseBetId'] = 238, ['loadingId'] = 238, ["portrait"] = 0,["questScale"] = 1 ,   ["highLimit"] = 0,["isNew2"] = true},
	[239]   = {['class'] = "ThemePotPrizes_MainViewControl",     ['basebet'] = 10000,	['scale'] = 1, ['resourceId'] = 239, ['headerStyle'] = 3, ['name'] = "WICKED BELLE",          ['chooseBetId'] = 239, ['loadingId'] = 239, ["portrait"] = 1,["questScale"] = 1 ,   ["highLimit"] = 0,["isNew2"] = true},
	[240]   = {['class'] = "WestZoneMain",             ['basebet'] = 10000,	['scale'] = 1, ['resourceId'] = 240, ['headerStyle'] = 5, ['name'] = "WEST ZONE",          ['chooseBetId'] = 240, ['loadingId'] = 240, ["portrait"] = 0,["questScale"] = 1 ,   ["highLimit"] = 0,["isNew2"] = true},
	[241]   = {['class'] = "ThemeKingsPower_MainControl",		    ['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 241, ['headerStyle'] = 3, ['name'] = "KING'S POWER",            ['chooseBetId'] = 241, ['loadingId'] = 241, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 0, ["isNew2"] = true},
	[242]   = {['class'] = "ThemeOrientalFortune_MainControl",    	['basebet'] = 10000,	['scale'] = 1, ['resourceId'] = 242, ['headerStyle'] = 5, ['name'] = "ORIENTAL FORTUNE",          ['chooseBetId'] = 242, ['loadingId'] = 242, ["portrait"] = 0,["questScale"] = 1 ,   ["highLimit"] = 0,["isNew2"] = true},
	[243]   = {['class'] = "ThreeMusketeers/ThreeMusketeersMain",    	['basebet'] = 10000,	['scale'] = 1, ['resourceId'] = 243, ['headerStyle'] = 5, ['name'] = "ORIENTAL FORTUNE",          ['chooseBetId'] = 243, ['loadingId'] = 243, ["portrait"] = 0,["questScale"] = 1 ,   ["highLimit"] = 0,["isNew2"] = true},
	[244]   = {['class'] = "MightyC_MainViewControl",    	['basebet'] = 10000,	['scale'] = 1, ['resourceId'] = 244, ['headerStyle'] = 5, ['name'] = "RHINO RUSH",          ['chooseBetId'] = 244, ['loadingId'] = 244, ["portrait"] = 0,["questScale"] = 1 ,   ["highLimit"] = 0,["isNew2"] = true},
	[245]   = {['class'] = "BellAdamMain",    			    ['basebet'] = 10000,	['scale'] = 1, ['resourceId'] = 245, ['headerStyle'] = 5, ['name'] = "BELLE AND ADAM",          ['chooseBetId'] = 245, ['loadingId'] = 245, ["portrait"] = 0,["questScale"] = 1 ,   ["highLimit"] = 0,["isNew2"] = true},
	[246]   = {['class'] = "MadHatter/MadHatterMain",             ['basebet'] = 10000,	['scale'] = 1, ['resourceId'] = 246, ['headerStyle'] = 5, ['name'] = "Mr.Mad Hatter",          ['chooseBetId'] = 246, ['loadingId'] = 246, ["portrait"] = 0,["questScale"] = 1 ,   ["highLimit"] = 0,["isNew2"] = true},
	[249]   = {['class'] = "ThemeRobinHood_MainControl",    	['basebet'] = 10000,	['scale'] = 1, ['resourceId'] = 249, ['headerStyle'] = 3, ['name'] = "ROBIN HOOD",          ['chooseBetId'] = 249, ['loadingId'] = 249, ["portrait"] = 1,["questScale"] = 1 ,   ["highLimit"] = 0,["isNew2"] = true},
	
	[325]   = {['class'] = "KingOfEgypt_MainViewControl",    	['basebet'] = 10000,	['scale'] = 1, ['resourceId'] = 325, ['headerStyle'] = 5, ['name'] = "ROBIN HOOD",          ['chooseBetId'] = 325, ['loadingId'] = 325, ["portrait"] = 0,["questScale"] = 1 ,   ["highLimit"] = 0,["isNew2"] = true},

	[306]   = {['class'] = "MagicWizardsMain",		['basebet'] = 10000,	['scale'] = 1, ['resourceId'] = 306, ['headerStyle'] = 3, ['name'] = "FLAMING QUEEN",	        ['chooseBetId'] = 306, ['loadingId'] = 306, ["portrait"] = 1,["questScale"] = 1 ,   ["highLimit"] = 0, ["isNew2"] = true, loading_anim = 1},
	[328]   = {['class'] = "FunkySkunk_MainControl",['basebet'] = 10000,	['scale'] = 1, ['resourceId'] = 328, ['headerStyle'] = 5, ['name'] = "ORIENTAL FORTUNE",        ['chooseBetId'] = 328, ['loadingId'] = 328, ["portrait"] = 0,["questScale"] = 1 ,   ["highLimit"] = 0,["isNew2"] = true, loading_anim = 1},
	[329]   = {['class'] = "JungleTigerMain",    	['basebet'] = 10000,	['scale'] = 1, ['resourceId'] = 329, ['headerStyle'] = 5, ['name'] = "RHINO RUSH",          	['chooseBetId'] = 329, ['loadingId'] = 329, ["portrait"] = 0,["questScale"] = 1 ,   ["highLimit"] = 0,["isNew2"] = true, loading_anim = 1},
	[331]   = {['class'] = "TrickyKitties_MainControl",['basebet'] = 10000, ['scale'] = 1, ['resourceId'] = 331, ['headerStyle'] = 5, ['name'] = "LEAPIN' LEMURS",          ['chooseBetId'] = 331, ['loadingId'] = 331, ["portrait"] = 0,["questScale"] = 1 , ["highLimit"] = 0, ["isNew2"] = true, loading_anim = 1},
	[346]   = {['class'] = "SafariPriMain", 		['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 346, ['headerStyle'] = 3, ['name'] = "MAGIC JACKPOT VAULT",     ['chooseBetId'] = 346, ['loadingId'] = 346, ["portrait"] = 1,["questScale"] = 1   , ["highLimit"] = 0, ["isNew2"] = true, loading_anim = 1 },
	[251]   = {['class'] = "ThemeKingArthur_MainControl", 		['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 251, ['headerStyle'] = 5, ['name'] = "KING ARTHUR",     ['chooseBetId'] = 251, ['loadingId'] = 251, ["portrait"] = 0,["questScale"] = 1   , ["highLimit"] = 0, ["isNew2"] = true},
	[365]   = {['class'] = "AmericanStars_MainControl", 		['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 365, ['headerStyle'] = 5, ['name'] = "AMERICAN STARS",     ['chooseBetId'] = 365, ['loadingId'] = 365, ["portrait"] = 0,["questScale"] = 1   , ["highLimit"] = 0, ["isNew2"] = true},


	-- 高级房
	[601]	= {['class'] = "ThemeElephantFortune",			['basebet'] = 7500, 	['scale'] = 1, ['resourceId'] = 101, ['headerStyle'] = 2, ['name'] = "LION TREASURE", 	         ['chooseBetId'] = 101, ['loadingId'] = 101, ["portrait"] = 0,["questScale"] = 1   , ["highLimit"] = 1},
	[602]   = {['class'] = "ThemeLuckyDrums", 				['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 102, ['headerStyle'] = 7, ['name'] = "FORTUNE GONG", 	 	     ['chooseBetId'] = 102, ['loadingId'] = 102, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 1},

	[603]   = {['class'] = "ThemeBulkyLink", 		    	['basebet'] = 8000, 	['scale'] = 1, ['resourceId'] = 103, ['headerStyle'] = 2, ['name'] = "DANCING LION",     		 ['chooseBetId'] = 603, ['loadingId'] = 103, ["portrait"] = 0,["questScale"] = 1   , ["highLimit"] = 1},
	[605]   = {['class'] = "ThemeWildFieryJackpots", 		['basebet'] = 6000, 	['scale'] = 1, ['resourceId'] = 105, ['headerStyle'] = 7, ['name'] = "HIGH POWER JACKPOTS",      ['chooseBetId'] = 105, ['loadingId'] = 105, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 1},
	[606]   = {['class'] = "ThemeFuDaoCaiDao", 		    	['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 106, ['headerStyle'] = 7, ['name'] = "EASTERN RICHES", 	 	     ['chooseBetId'] = 106, ['loadingId'] = 106, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 1},
	[607]   = {['class'] = "ThemeCashWheelDeluxe", 	    	['basebet'] = 7500, 	['scale'] = 1, ['resourceId'] = 107, ['headerStyle'] = 7, ['name'] = "FORTUNE WHEEL DELUXE",     ['chooseBetId'] = 107, ['loadingId'] = 107, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 1},
	[608]   = {['class'] = "ThemeChiefOfTheGods", 			['basebet'] = 7500, 	['scale'] = 1, ['resourceId'] = 108, ['headerStyle'] = 2, ['name'] = "THOR", 			 	     ['chooseBetId'] = 608, ['loadingId'] = 108, ["portrait"] = 0,["questScale"] = 1   , ["highLimit"] = 1},
	[609]   = {['class'] = "ThemeEpicLinkCrystalDeluxe", 	['basebet'] = 5000, 	['scale'] = 1, ['resourceId'] = 109, ['headerStyle'] = 2, ['name'] = "JEWELS NIGHT", 	 	     ['chooseBetId'] = 109, ['loadingId'] = 109, ["portrait"] = 0,["questScale"] = 1   , ["highLimit"] = 1},
	[610]   = {['class'] = "ThemeHephaestusUnleashed", 		['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 110, ['headerStyle'] = 7, ['name'] = "HEPHAESTUS", 			     ['chooseBetId'] = 610, ['loadingId'] = 110, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 1},
	[611]   = {['class'] = "ThemeEpicLinkGoldReelBurst", 	['basebet'] = 5000, 	['scale'] = 1, ['resourceId'] = 111, ['headerStyle'] = 2, ['name'] = "GOLD BURST", 	 		     ['chooseBetId'] = 111, ['loadingId'] = 111, ["portrait"] = 0,["questScale"] = 1   , ["highLimit"] = 1},
	[612]   = {['class'] = "ThemeRapidPayUltra", 			['basebet'] = 5000, 	['scale'] = 1, ['resourceId'] = 112, ['headerStyle'] = 7, ['name'] = "EGYPTIAN FANTASY", 	     ['chooseBetId'] = 612, ['loadingId'] = 112, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 1},
	[613]   = {['class'] = "ThemeQuickHitPlatinumPlus", 	['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 113, ['headerStyle'] = 7, ['name'] = "RAPID PAY PLATINUM", 	     ['chooseBetId'] = 613, ['loadingId'] = 113, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 1},
	[614]   = {['class'] = "ThemeCandyMagic", 	        	['basebet'] = 5000, 	['scale'] = 1, ['resourceId'] = 114, ['headerStyle'] = 2, ['name'] = "CANDY MAGIC", 	 	     ['chooseBetId'] = 114, ['loadingId'] = 114, ["portrait"] = 0,["questScale"] = 1   , ["highLimit"] = 1},
	[615]   = {['class'] = "ThemeMajesticPanda", 			['basebet'] = 5000, 	['scale'] = 1, ['resourceId'] = 115, ['headerStyle'] = 7, ['name'] = "REGAL TIGER", 	 	     ['chooseBetId'] = 615, ['loadingId'] = 115, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 1},
	[616]   = {['class'] = "ThemeHaidiBierHaus", 			['basebet'] = 5000, 	['scale'] = 1, ['resourceId'] = 116, ['headerStyle'] = 7, ['name'] = "LEPRECHAUN'S COINS", 	     ['chooseBetId'] = 616, ['loadingId'] = 116, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 1},
	[617]   = {['class'] = "ThemeFiveTreasures", 			['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 117, ['headerStyle'] = 7, ['name'] = "BRILLIANT TREASURES", 	 ['chooseBetId'] = 117, ['loadingId'] = 117, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 1},
	[618]   = {['class'] = "ThemeMammothGrand", 			['basebet'] = 6000, 	['scale'] = 1, ['resourceId'] = 118, ['headerStyle'] = 7, ['name'] = "MAMMOTH GRAND", 	 	     ['chooseBetId'] = 618, ['loadingId'] = 118, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 1},
	[619]   = {['class'] = "ThemeCandyMagicGrand", 			['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 119, ['headerStyle'] = 7, ['name'] = "CANDY MAGIC GRAND", 	     ['chooseBetId'] = 619, ['loadingId'] = 119, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 1},
	[620]   = {['class'] = "ThemeSpinItGrand", 				['basebet'] = 5000, 	['scale'] = 1, ['resourceId'] = 120, ['headerStyle'] = 7, ['name'] = "WINNER'S PARADISE", 	     ['chooseBetId'] = 120, ['loadingId'] = 120, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 1},
	[621]   = {['class'] = "ThemeFortuneKitty", 		    ['basebet'] = 5000, 	['scale'] = 1, ['resourceId'] = 121, ['headerStyle'] = 2, ['name'] = "MANEKI NEKO RICHES", 	     ['chooseBetId'] = 121, ['loadingId'] = 121, ["portrait"] = 0,["questScale"] = 1   , ["highLimit"] = 1},
	[622]   = {['class'] = "ThemeBigMoney", 		        ['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 122, ['headerStyle'] = 2, ['name'] = "BIG MONEY FRENZY", 	     ['chooseBetId'] = 622, ['loadingId'] = 122, ["portrait"] = 0,["questScale"] = 1   , ["highLimit"] = 1},
	[623]   = {['class'] = "ThemeMermaid", 		    		['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 123, ['headerStyle'] = 2, ['name'] = "POWER OF SEA", 	         ['chooseBetId'] = 123, ['loadingId'] = 123, ["portrait"] = 0,["questScale"] = 1   , ["highLimit"] = 1},
	[624]   = {['class'] = "ThemeSmashPinata", 		    	['basebet'] = 6000, 	['scale'] = 1, ['resourceId'] = 124, ['headerStyle'] = 2, ['name'] = "HAPPY PIÑATA FIESTA",      ['chooseBetId'] = 624, ['loadingId'] = 124, ["portrait"] = 0,["questScale"] = 1   , ["highLimit"] = 1},
	[625]   = {['class'] = "ThemeSplendidIsland", 			['basebet'] = 5000, 	['scale'] = 1, ['resourceId'] = 125, ['headerStyle'] = 7, ['name'] = "SPLENDID ISLAND", 	     ['chooseBetId'] = 625, ['loadingId'] = 125, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 1},
	[626]   = {['class'] = "ThemeMagicJackpotVault", 		['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 126, ['headerStyle'] = 2, ['name'] = "MAGIC JACKPOT VAULT",      ['chooseBetId'] = 626, ['loadingId'] = 126, ["portrait"] = 0,["questScale"] = 1   , ["highLimit"] = 1},
	[627]   = {['class'] = "ThemeMrCashFrenzy", 		    ['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 127, ['headerStyle'] = 2, ['name'] = "MR. Golden Slots", 	     ['chooseBetId'] = 627, ['loadingId'] = 127, ["portrait"] = 0,["questScale"] = 1   , ["highLimit"] = 1},
	[628]   = {['class'] = "ThemeRoyalPuppies", 			['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 128, ['headerStyle'] = 7, ['name'] = "ROYAL PUPPIES", 	 	     ['chooseBetId'] = 628, ['loadingId'] = 128, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 1},
	[629]   = {['class'] = "ThemeBigMoneyHolidayFrenzy", 	['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 129, ['headerStyle'] = 7, ['name'] = "BIG MONEY HOLIDAY FRENZY", ['chooseBetId'] = 629, ['loadingId'] = 129, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 1},
	[630]   = {['class'] = "ThemeMammothGrandGems", 		['basebet'] = 6000, 	['scale'] = 1, ['resourceId'] = 130, ['headerStyle'] = 7, ['name'] = "MAMMOTH GRAND GEMS", 		 ['chooseBetId'] = 630, ['loadingId'] = 130, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 1},
	[631]   = {['class'] = "ThemeDiamondsLifeDeluxe", 		['basebet'] = 5000, 	['scale'] = 1, ['resourceId'] = 131, ['headerStyle'] = 7, ['name'] = "JEWELS NIGHT DELUXE", 	 ['chooseBetId'] = 631, ['loadingId'] = 131, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 1},
	[632]   = {['class'] = "ThemeHexoGems", 				['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 132, ['headerStyle'] = 7, ['name'] = "MAJESTIC PANDA", 		 	 ['chooseBetId'] = 632, ['loadingId'] = 132, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 1},
	[633]   = {['class'] = "ThemeMagicForest", 				['basebet'] = 6000, 	['scale'] = 1, ['resourceId'] = 133, ['headerStyle'] = 2, ['name'] = "SPIRITS OF PIXIES", 	 	 ['chooseBetId'] = 633, ['loadingId'] = 133, ["portrait"] = 0,["questScale"] = 1   , ["highLimit"] = 1},
	[634]   = {['class'] = "ThemeTwinFireFrenzy", 			['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 134, ['headerStyle'] = 7, ['name'] = "DANCING CARNIVAL", 	 	 ['chooseBetId'] = 634, ['loadingId'] = 134, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 1},
	[635]   = {['class'] = "ThemeJinSeDao", 		        ['basebet'] = 5000, 	['scale'] = 1, ['resourceId'] = 135, ['headerStyle'] = 7, ['name'] = "JALAPEÑO DELIGHT", 	     ['chooseBetId'] = 635, ['loadingId'] = 135, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 1},
	[636]   = {['class'] = "ThemeFortuneGongV", 		    ['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 136, ['headerStyle'] = 7, ['name'] = "HOT HOT DRUMS", 	         ['chooseBetId'] = 636, ['loadingId'] = 136, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 1},
	[637]   = {['class'] = "ThemeBlockBonanza", 		    ['basebet'] = 5000, 	['scale'] = 1, ['resourceId'] = 137, ['headerStyle'] = 7, ['name'] = "LET'S PARTY", 	         ['chooseBetId'] = 637, ['loadingId'] = 137, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 1},
	[638]   = {['class'] = "ThemeMightyCash", 		        ['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 138, ['headerStyle'] = 2, ['name'] = "WESTERN CASH", 	         ['chooseBetId'] = 638, ['loadingId'] = 138, ["portrait"] = 0,["questScale"] = 1 , ["highLimit"] = 1},
	[639]   = {['class'] = "ThemeGoldenEgypt", 				['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 139, ['headerStyle'] = 2, ['name'] = "GORGEOUS GODDESS", 	 	 ['chooseBetId'] = 639, ['loadingId'] = 139, ["portrait"] = 0,["questScale"] = 1   , ["highLimit"] = 1},
	[640]   = {['class'] = "ThemeCashClimb", 		    	['basebet'] = 5000, 	['scale'] = 1, ['resourceId'] = 140, ['headerStyle'] = 7, ['name'] = "THUNDERING MUSTANG", 	     ['chooseBetId'] = 640, ['loadingId'] = 140, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 1},
	[641]   = {['class'] = "ThemeCleopatraGold", 		    ['basebet'] = 6000, 	['scale'] = 1, ['resourceId'] = 141, ['headerStyle'] = 7, ['name'] = "GOLDEN ISLAND TREASURE", 	 ['chooseBetId'] = 641, ['loadingId'] = 141, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 1},
	[642]   = {['class'] = "ThemeMammon", 		    		['basebet'] = 7500, 	['scale'] = 1, ['resourceId'] = 142, ['headerStyle'] = 2, ['name'] = "FORTUNE WILD", 	         ['chooseBetId'] = 642, ['loadingId'] = 142, ["portrait"] = 0,["questScale"] = 1   , ["highLimit"] = 1},
	[643]   = {['class'] = "ThemeLotsaSlots", 		        ['basebet'] = 8000, 	['scale'] = 1, ['resourceId'] = 143, ['headerStyle'] = 7, ['name'] = "SLOTS TOWER", 	         ['chooseBetId'] = 643, ['loadingId'] = 143, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 1},
	[644]   = {['class'] = "ThemeEgyptQueen", 		        ['basebet'] = 6000, 	['scale'] = 1, ['resourceId'] = 144, ['headerStyle'] = 7, ['name'] = "MYSTERIOUS SCARAB", 	     ['chooseBetId'] = 644, ['loadingId'] = 144, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 1},
	[645]   = {['class'] = "ThemeHeroAndDragon", 			['basebet'] = 6000, 	['scale'] = 1, ['resourceId'] = 145, ['headerStyle'] = 2, ['name'] = "INVINCIBLE BRAVE", 	 	 ['chooseBetId'] = 645, ['loadingId'] = 145, ["portrait"] = 0,["questScale"] = 1   , ["highLimit"] = 1},
	[646]   = {['class'] = "ThemeDoubleCash", 				['basebet'] = 5000, 	['scale'] = 1, ['resourceId'] = 146, ['headerStyle'] = 2, ['name'] = "DOUNLE CASH", 	 	     ['chooseBetId'] = 646, ['loadingId'] = 146, ["portrait"] = 0,["questScale"] = 1   , ["highLimit"] = 1},
	[647]   = {['class'] = "ThemeGorilla", 					['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 147, ['headerStyle'] = 2, ['name'] = "SUPERB GORILLA", 	 	     ['chooseBetId'] = 647, ['loadingId'] = 147, ["portrait"] = 0,["questScale"] = 1   , ["highLimit"] = 1},
	[648]   = {['class'] = "ThemeLuckyFunnyKitties", 		['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 148, ['headerStyle'] = 2, ['name'] = "LUCKY FUNNY KITTIES", 	 ['chooseBetId'] = 648, ['loadingId'] = 148, ["portrait"] = 0,["questScale"] = 1   , ["highLimit"] = 1},
	[649]   = {['class'] = "ThemeBlazingGirl", 				['basebet'] = 6000, 	['scale'] = 1, ['resourceId'] = 149, ['headerStyle'] = 7, ['name'] = "Mia's Beer Hall", 	 	 ['chooseBetId'] = 649, ['loadingId'] = 149, ["portrait"] = 1,["questScale"] = 1   , ["highLimit"] = 1},
	[650]   = {['class'] = "ThemeCrazyMoney", 		        ['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 150, ['headerStyle'] = 2, ['name'] = "CASH FEVER", 	         	 ['chooseBetId'] = 650, ['loadingId'] = 150, ["portrait"] = 0,["questScale"] = 1   , ["highLimit"] = 1},
	[651]   = {['class'] = "ThemeFrenzy4Classics", 			['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 151, ['headerStyle'] = 7, ['name'] = "FRENZY 4 CLASSICS", 		 ['chooseBetId'] = 151, ['loadingId'] = 151, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 1},
	[652]   = {['class'] = "ThemeJackpotParty", 			['basebet'] = 7500, 	['scale'] = 1, ['resourceId'] = 152, ['headerStyle'] = 2, ['name'] = "GANGSTER CITY", 	 	     ['chooseBetId'] = 652, ['loadingId'] = 152, ["portrait"] = 0,["questScale"] = 1 , ["highLimit"] = 1},
	[653]   = {['class'] = "ThemeWizards", 					['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 153, ['headerStyle'] = 7, ['name'] = "WITCH OF FORTUNE", 	 	 ['chooseBetId'] = 653, ['loadingId'] = 153, ["portrait"] = 1,["questScale"] = 1   , ["highLimit"] = 1},
	[654]   = {['class'] = "ThemeHappyHarvest", 			['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 154, ['headerStyle'] = 2, ['name'] = "HAPPY HARVEST", 	 	 	 ['chooseBetId'] = 654, ['loadingId'] = 154, ["portrait"] = 0,["questScale"] = 1   , ["highLimit"] = 1},
	[655]   = {['class'] = "ThemeZombie", 				    ['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 155, ['headerStyle'] = 7, ['name'] = "ZOMBIE NATION", 	 	     ['chooseBetId'] = 655, ['loadingId'] = 155, ["portrait"] = 1,["questScale"] = 1   , ["highLimit"] = 1},
	[656]	= {['class'] = "ThemeDiamondDiamond",			['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 156, ['headerStyle'] = 2, ['name'] = "DIAMOND DIAMOND",          ['chooseBetId'] = 156, ['loadingId'] = 156, ["portrait"] = 0,["questScale"] = 1, ["highLimit"] = 1},
	[657]   = {['class'] = "ThemeFairypyMania", 		    ['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 157, ['headerStyle'] = 7, ['name'] = "THEME PARK BLAST", 	     ['chooseBetId'] = 657, ['loadingId'] = 157, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 1},
	[658]   = {['class'] = "ThemeMightyDouble", 		    ['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 158, ['headerStyle'] = 7, ['name'] = "ICY WOLF", 				 ['chooseBetId'] = 658, ['loadingId'] = 158, ["portrait"] = 1,["questScale"] = 1, ["highLimit"] = 1},
	[659]   = {['class'] = "ThemeBonnieAndClyde", 		    ['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 159, ['headerStyle'] = 7, ['name'] = "THE LEGACY OF BONNIE AND CLYDE",  ['chooseBetId'] = 659, ['loadingId'] = 159, ["portrait"] = 1,["questScale"] = 1, ["highLimit"] = 1},
	[660]   = {['class'] = "ThemeSushiLover", 		        ['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 160, ['headerStyle'] = 7, ['name'] = "SUSHI LOVER",               ['chooseBetId'] = 660, ['loadingId'] = 160, ["portrait"] = 1,["questScale"] = 1, ["highLimit"] = 1},
	[661]	= {['class'] = "ThemeStarStax",					['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 161, ['headerStyle'] = 7, ['name'] = "PRINCE CHARMING",          ['chooseBetId'] = 661, ['loadingId'] = 161, ["portrait"] = 1,["questScale"] = 1, ["highLimit"] = 1},
	[662]	= {['class'] = "ThemeBubbleBlast",				['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 162, ['headerStyle'] = 7, ['name'] = "SUPER WICKED BLAST",		 ['chooseBetId'] = 662, ['loadingId'] = 162, ["portrait"] = 1,["questScale"] = 1, ["highLimit"] = 1},
	[663]   = {['class'] = "ThemeMermaidRising", 		    ['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 163, ['headerStyle'] = 7, ['name'] = "QUEEN OF SEA", 	 		['chooseBetId'] = 663, ['loadingId'] = 163, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 1},
	[664]   = {['class'] = "ThemeFireFortune",              ['basebet'] = 10000,    ['scale'] = 1, ['resourceId'] = 164, ['headerStyle'] = 2, ['name'] = "GLORY OF THE MAYA",        ['chooseBetId'] = 664, ['loadingId'] = 164, ['portrait'] = 0,['questScale'] = 1, ['highLimit'] = 1},
	[665]   = {['class'] = "ThemeWheelShoot",               ['basebet'] = 10000,    ['scale'] = 1, ['resourceId'] = 165, ['headerStyle'] = 2, ['name'] = "THANKSGIVING HOLIDAY FRENZY",            ['chooseBetId'] = 665, ['loadingId'] = 165, ['portrait'] = 0,['questScale'] = 1, ['highLimit'] = 1},
	[666]   = {['class'] = "ThemeRisingRiches",             ['basebet'] = 10000,    ['scale'] = 1, ['resourceId'] = 166, ['headerStyle'] = 2, ['name'] = "GOLDEN 70s",               ['chooseBetId'] = 666, ['loadingId'] = 166, ['portrait'] = 0,['questScale'] = 1, ['highLimit'] = 1},
	[667]   = {['class'] = "ThemeLuckyFishmania",           ['basebet'] = 10000,    ['scale'] = 1, ['resourceId'] = 167, ['headerStyle'] = 2, ['name'] = "LUCKY FISHMANIA",          ['chooseBetId'] = 667, ['loadingId'] = 167, ['portrait'] = 0,['questScale'] = 1, ['highLimit'] = 1},
	[668]   = {['class'] = "ThemeChristmas",                ['basebet'] = 10000,    ['scale'] = 1, ['resourceId'] = 168, ['headerStyle'] = 7, ['name'] = "WHERE IS THE SANTA CLAUS", ['chooseBetId'] = 668, ['loadingId'] = 168, ['portrait'] = 1,['questScale'] = 1, ['highLimit'] = 1},
	[669]   = {['class'] = "ThemeIndianaJones",             ['basebet'] = 10000,    ['scale'] = 1, ['resourceId'] = 169, ['headerStyle'] = 7, ['name'] = "TREASURE JUNGLE",          ['chooseBetId'] = 669, ['loadingId'] = 169, ['portrait'] = 1,['questScale'] = 1, ['highLimit'] = 1},
	[670]   = {['class'] = "ThemeSolarDisc",                ['basebet'] = 10000,    ['scale'] = 1, ['resourceId'] = 170, ['headerStyle'] = 2, ['name'] = "INCREDIBLE WOMAN",         ['chooseBetId'] = 670, ['loadingId'] = 170, ['portrait'] = 0,['questScale'] = 1, ['highLimit'] = 1},
	[671]   = {['class'] = "ThemeBuffaloXtreme", 		    ['basebet'] = 6000, 	['scale'] = 1, ['resourceId'] = 171, ['headerStyle'] = 7, ['name'] = "JUNGLE KING", 	 		['chooseBetId'] = 671, ['loadingId'] = 171, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 1},
	[672]   = {['class'] = "ThemeTowerStack",               ['basebet'] = 10000,    ['scale'] = 1, ['resourceId'] = 172, ['headerStyle'] = 7, ['name'] = "CASH FEVER DELUXE",        ['chooseBetId'] = 672, ['loadingId'] = 172, ['portrait'] = 1,['questScale'] = 1, ['highLimit'] = 1},
	[673]   = {['class'] = "ThemeSunGoddess",               ['basebet'] = 10000,    ['scale'] = 1, ['resourceId'] = 173, ['headerStyle'] = 7, ['name'] = "SUN GODDESS",              ['chooseBetId'] = 673, ['loadingId'] = 173, ['portrait'] = 1,['questScale'] = 1, ['highLimit'] = 1},
	[674]   = {['class'] = "ThemeDracula",                  ['basebet'] = 10000,    ['scale'] = 1, ['resourceId'] = 174, ['headerStyle'] = 2, ['name'] = "MANIAC DRACULA",           ['chooseBetId'] = 674, ['loadingId'] = 174, ['portrait'] = 0,['questScale'] = 1, ['highLimit'] = 1},
	[675]   = {['class'] = "ThemeGameFortune",              ['basebet'] = 10000,    ['scale'] = 1, ['resourceId'] = 175, ['headerStyle'] = 7, ['name'] = "FORTUNE GENIE",           ['chooseBetId'] = 675, ['loadingId'] = 175, ['portrait'] = 1,['questScale'] = 1, ['highLimit'] = 1},
	[676]   = {['class'] = "ThemeCupid", 		    	    ['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 176, ['headerStyle'] = 7, ['name'] = "CUPID'S CRUSH", 	 		 ['chooseBetId'] = 676, ['loadingId'] = 176, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 1},
	[677]   = {['class'] = "ThemePowerOfDragons",           ['basebet'] = 10000,    ['scale'] = 1, ['resourceId'] = 177, ['headerStyle'] = 7, ['name'] = "POWER OF DRAGONS",         ['chooseBetId'] = 677, ['loadingId'] = 177, ['portrait'] = 1,['questScale'] = 1, ['highLimit'] = 1},
	[678]   = {['class'] = "ThemeMagicNile",                ['basebet'] = 10000,    ['scale'] = 1, ['resourceId'] = 178, ['headerStyle'] = 7, ['name'] = "MONSTER CASH",             ['chooseBetId'] = 678, ['loadingId'] = 178, ['portrait'] = 1,['questScale'] = 1, ['highLimit'] = 1},
	[679]   = {['class'] = "ThemeLeprechaunGoldSlot", 		['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 179, ['headerStyle'] = 7, ['name'] = "MOMENT OF WONDER", 	 ['chooseBetId'] = 679, ['loadingId'] = 179, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 1},
	[680]   = {['class'] = "ThemeZorro",                    ['basebet'] = 10000,    ['scale'] = 1, ['resourceId'] = 180, ['headerStyle'] = 7, ['name'] = "MASKED HERO",		         ['chooseBetId'] = 680, ['loadingId'] = 180, ['portrait'] = 1,['questScale'] = 0.95, ['highLimit'] = 1},
	[681]   = {['class'] = "ThemePussBingo",                ['basebet'] = 10000,    ['scale'] = 1, ['resourceId'] = 181, ['headerStyle'] = 7, ['name'] = "BINGO MEOW",               ['chooseBetId'] = 681, ['loadingId'] = 181, ['portrait'] = 1,['questScale'] = 1, ['highLimit'] = 1},
	[682]   = {['class'] = "ThemeHexBreak",                 ['basebet'] = 10000,    ['scale'] = 1, ['resourceId'] = 182, ['headerStyle'] = 7, ['name'] = "GRAND GEMINI",             ['chooseBetId'] = 682, ['loadingId'] = 182, ['portrait'] = 1,['questScale'] = 1, ['highLimit'] = 1},
	[683]   = {['class'] = "ThemeSpeedyFire",               ['basebet'] = 10000,    ['scale'] = 1, ['resourceId'] = 183, ['headerStyle'] = 7, ['name'] = "SPEEDY FIRE",           ['chooseBetId'] = 683, ['loadingId'] = 183, ['portrait'] = 1,['questScale'] = 1, ['highLimit'] = 1},
	[684]   = {['class'] = "ThemeDiamondForest", 		    ['basebet'] = 7500, 	['scale'] = 1, ['resourceId'] = 184, ['headerStyle'] = 7, ['name'] = "DIAMOND FOREST", 	 		 ['chooseBetId'] = 684, ['loadingId'] = 184, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 1},
	[685]   = {['class'] = "ThemeFortuneWildDeluxe", 		['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 185, ['headerStyle'] = 7, ['name'] = "FORTUNE WILD DELUXE", 	 ['chooseBetId'] = 685, ['loadingId'] = 185, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 1},
	[686]   = {['class'] = "ThemeCleopatra",         		['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 186, ['headerStyle'] = 7, ['name'] = "GORGEOUS CLEOPATRA",     	 ['chooseBetId'] = 686, ['loadingId'] = 186, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 1},
	[687]   = {['class'] = "ThemeCashFalls",         		['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 187, ['headerStyle'] = 7, ['name'] = "YEAR OF THE RAT", 	 	 ['chooseBetId'] = 687, ['loadingId'] = 187, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 1},
	[688]   = {['class'] = "ThemeZeus",         			['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 188, ['headerStyle'] = 7, ['name'] = "KING OF OLYMPUS", 	 	 ['chooseBetId'] = 688, ['loadingId'] = 188, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 1},
	[689]   = {['class'] = "ThemeCupidII",         			['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 189, ['headerStyle'] = 7, ['name'] = "CUPID'S CRUSH DELUXE",	 ['chooseBetId'] = 689, ['loadingId'] = 189, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 1},
	[690]   = {['class'] = "ThemeFireItUp", 		 	    ['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 190, ['headerStyle'] = 7, ['name'] = "FSMOKIN' HOT RICHES", 	 			 ['chooseBetId'] = 690, ['loadingId'] = 190, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 1},
	[691]   = {['class'] = "ThemeMeDuSa", 		  	        ['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 191, ['headerStyle'] = 7, ['name'] = "RISING MEDUSA", 	 		 ['chooseBetId'] = 691, ['loadingId'] = 191, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 1},
	[692]   = {['class'] = "ThemeWildAustralia", 		  	['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 192, ['headerStyle'] = 7, ['name'] = "WILD AUSTRALIA",			 ['chooseBetId'] = 692, ['loadingId'] = 192, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 1},
	[693]   = {['class'] = "ThemeQuickHitRB", 		     	['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 193, ['headerStyle'] = 7, ['name'] = "SLOTS TOWER DELUXE",		 ['chooseBetId'] = 693, ['loadingId'] = 193, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 1},
	[694]   = {['class'] = "ThemePowerSlot", 		     	['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 194, ['headerStyle'] = 7, ['name'] = "ADVENTURES IN SPACE",		 ['chooseBetId'] = 694, ['loadingId'] = 194, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 1},
	[695]   = {['class'] = "ThemeTwinStrike",               ['basebet'] = 10000,    ['scale'] = 1, ['resourceId'] = 195, ['headerStyle'] = 2, ['name'] = "FREEDOM EAGLE",            ['chooseBetId'] = 695, ['loadingId'] = 195, ['portrait'] = 0,['questScale'] = 1, ['highLimit'] = 1},
	[696]   = {['class'] = "ThemeFairyHollow",              ['basebet'] = 10000,    ['scale'] = 1, ['resourceId'] = 196, ['headerStyle'] = 2, ['name'] = "FIRE RICHES",              ['chooseBetId'] = 696, ['loadingId'] = 196, ['portrait'] = 0,['questScale'] = 1, ['highLimit'] = 1},
	[697]   = {['class'] = "ThemeSplendidIslandDeluxe", 	['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 197, ['headerStyle'] = 7, ['name'] = "SPLENDID ISLAND DELUXE", 	 ['chooseBetId'] = 697, ['loadingId'] = 197, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 1},
	[698]   = {['class'] = "ThemeTakeTheCake",              ['basebet'] = 10000,    ['scale'] = 1, ['resourceId'] = 198, ['headerStyle'] = 7, ['name'] = "CIRCUS CARNIVAL", 		 ['chooseBetId'] = 698, ['loadingId'] = 198, ['portrait'] = 1,['questScale'] = 1, ['highLimit'] = 1},
	[699]   = {['class'] = "ThemeGoldOfTenochtitlan", 		['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 199, ['headerStyle'] = 2, ['name'] = "FORTUNE TRAIN",		 ['chooseBetId'] = 699, ['loadingId'] = 199, ["portrait"] = 0,["questScale"] = 1, ["highLimit"] = 1},
	[700]   = {['class'] = "ThemeBigThree",		            ['basebet'] = 30000, 	['scale'] = 1, ['resourceId'] = 200, ['headerStyle'] = 7, ['name'] = "BIG 3", 	             ['chooseBetId'] = 700, ['loadingId'] = 200, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 1},
	[701]   = {['class'] = "ThemeRockDisco",		        ['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 201, ['headerStyle'] = 7, ['name'] = "ROCK'N'DISCO", 	         ['chooseBetId'] = 701, ['loadingId'] = 201, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 1},
	[702]   = {['class'] = "ThemeFuDai",		            ['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 202, ['headerStyle'] = 7, ['name'] = "MEGA VAULT BILLIONAIRE", 	 ['chooseBetId'] = 702, ['loadingId'] = 202, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 1},
	[703]   = {['class'] = "ThemeSpaceCat_MainViewControl",	['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 203, ['headerStyle'] = 7, ['name'] = "SPACE CAT", 	                 ['chooseBetId'] = 703, ['loadingId'] = 203, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 1, ["isNew"] = true}, -- SpaceCat/
	[704]   = {['class'] = "ThemeFrenzy2x2Classics", 		['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 204, ['headerStyle'] = 2, ['name'] = "FRENZY 2X2 CLASSICS", 	 ['chooseBetId'] = 704, ['loadingId'] = 204, ["portrait"] = 0,["questScale"] = 1 , ["highLimit"] = 1},
	[705]   = {['class'] = "ThemeStoneAgedTreasure", 		['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 205, ['headerStyle'] = 7, ['name'] = "STONE-AGED TREASURE", 	 ['chooseBetId'] = 705, ['loadingId'] = 205, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 1},
	[706]   = {['class'] = "DragonBattle/DragonBMain", 		['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 206, ['headerStyle'] = 7, ['name'] = "DRAGON'S BATTLE", 	 	 ['chooseBetId'] = 706, ['loadingId'] = 206, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 1,["isNew2"] = true},
	[707]   = {['class'] = "ThemeFortureTrain", 	        ['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 207, ['headerStyle'] = 7, ['name'] = "FORTUNE TRAIN DELUXE", 	 ['chooseBetId'] = 707, ['loadingId'] = 207, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 1},
	[708]   = {['class'] = "ThemeSpinItGrandNew", 			['basebet'] = 5000, 	['scale'] = 1, ['resourceId'] = 208, ['headerStyle'] = 7, ['name'] = "FORTUNE BABY", 	     	 ['chooseBetId'] = 708, ['loadingId'] = 208, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 1},
	[709]   = {['class'] = "ThemeGoblin", 		            ['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 209, ['headerStyle'] = 7, ['name'] = "GOBLIN'S TREASURE", 	 		         ['chooseBetId'] = 709, ['loadingId'] = 209, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 1},
	[710]   = {['class'] = "ThemeZombieNew", 				['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 210, ['headerStyle'] = 7, ['name'] = "OCEAN CLASH", 	 	     ['chooseBetId'] = 710, ['loadingId'] = 210, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 1},
	[711]   = {['class'] = "ThemePrinceCharmingDeluxe_MainViewControl",		['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 211, ['headerStyle'] = 7, ['name'] = "PRINCE CHARMING DELUXE", 	                 ['chooseBetId'] = 711, ['loadingId'] = 211, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 1, ["isNew2"] = true},
	[712]   = {['class'] = "ThemeAliceMain",	        ['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 212, ['headerStyle'] = 7, ['name'] = "ALICE'S ADVENTURE",        ['chooseBetId'] = 712, ['loadingId'] = 212, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 1}, -- Alice/
	[713]   = {['class'] = "ThemeCashMoolah", 		        ['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 213, ['headerStyle'] = 7, ['name'] = "CASH MOOLAH", 	         ['chooseBetId'] = 713, ['loadingId'] = 213, ["portrait"] = 1,["questScale"] = 1 ,  ["highLimit"] = 1},
	[714]   = {['class'] = "ThemeHalloween_Control",	['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 214, ['headerStyle'] = 7, ['name'] = "SPOOKY HALLOWEEN",    ['chooseBetId'] = 714, ['loadingId'] = 214, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 1},
	[715]   = {['class'] = "ThemeLuckyBee_MainViewControl",	['basebet'] = 10000,	['scale'] = 1,	['resourceId'] = 215,	['headerStyle'] = 7,	['name'] = "LUCKY BEE",	['chooseBetId'] = 715,	['loadingId'] = 215,	["portrait"] = 1,	["questScale"] = 1 ,	["highLimit"] = 1,	["isNew2"] = true},
	[716]   = {['class'] = "ThemeIceQMain",    	['basebet'] = 10000,	['scale'] = 1, ['resourceId'] = 216, ['headerStyle'] = 2, ['name'] = "ICY QUEEN",	             ['chooseBetId'] = 716, ['loadingId'] = 216, ["portrait"] = 0,["questScale"] =1 , ["highLimit"] = 1},
	[717]   = {['class'] = "ThemeZombieNation",	            ['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 217, ['headerStyle'] = 7, ['name'] = "ZOMBIE NATION",    ['chooseBetId'] = 717, ['loadingId'] = 217, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 1},
	[718]   = {['class'] = "ThemeTurkeyBlast", 		        ['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 218, ['headerStyle'] = 7, ['name'] = "TURKEY BLAST", 	         ['chooseBetId'] = 718, ['loadingId'] = 218, ["portrait"] = 1,["questScale"] = 1 ,  ["highLimit"] = 1},
	[719]   = {['class'] = "ThemePirateP_MainViewControl", ['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 219, ['headerStyle'] = 7, ['name'] = "PELICAN QUEST",     ['chooseBetId'] = 719, ['loadingId'] = 219, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 1, ["isNew2"] = true},
	[720]   = {['class'] = "ThemeApollo_MainControl",['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 220, ['headerStyle'] = 7, ['name'] = "APOLLO",                   ['chooseBetId'] = 720, ['loadingId'] = 220, ["portrait"] = 1,["questScale"] =1 , ["highLimit"] = 1, ["isNew2"] = true},
	[721]   = {['class'] = "ThemeCandyClash_MainViewControl", ['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 221, ['headerStyle'] = 7, ['name'] = "CANDY CLASH",     ['chooseBetId'] = 721, ['loadingId'] = 221, ["portrait"] = 1,["questScale"] = 1, ["highLimit"] = 1, ["isNew2"] = true},
	[722]   = {['class'] = "ThemeChristmasMain",    	['basebet'] = 10000,	['scale'] = 1, ['resourceId'] = 222, ['headerStyle'] = 2, ['name'] = "SANTA MAGIC",	             ['chooseBetId'] = 722, ['loadingId'] = 222, ["portrait"] = 0,["questScale"] =1 , ["highLimit"] = 1},
	[723]   = {['class'] = "ThemeMayaM_MainViewControl",    	['basebet'] = 10000,	['scale'] = 1, ['resourceId'] = 223, ['headerStyle'] = 2, ['name'] = "MAYAN MIRACLE ",	['chooseBetId'] = 723, ['loadingId'] = 223, ["portrait"] = 0,["questScale"] = 1 ,   ["highLimit"] = 1, ["isNew2"] = true},
	[724]   = {['class'] = "ThemeFQ_Main",		['basebet'] = 10000,	['scale'] = 1, ['resourceId'] = 224, ['headerStyle'] = 7, ['name'] = "FLAMING QUEEN",	         ['chooseBetId'] = 724, ['loadingId'] = 224, ["portrait"] = 1,["questScale"] = 1 ,   ["highLimit"] = 1, ["isNew2"] = true},
	[726]   = {['class'] = "ThemeLeapinLemurs",		        ['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 226, ['headerStyle'] = 2, ['name'] = "LEAPIN' LEMURS",              ['chooseBetId'] = 726, ['loadingId'] = 226, ["portrait"] = 0,["questScale"] = 1 , ["highLimit"] = 1},
	[725]   = {['class'] = "ThemeGoldRush_MainControl",	    ['basebet'] = 10000, 	['scale'] = 1, 		['resourceId'] = 225, 	['headerStyle'] = 2, 	['name'] = "GOLD RUSH WITH ROISIN",		['chooseBetId'] = 725,	['loadingId'] = 225, 	["portrait"] = 0,	["questScale"] = 1 , ["highLimit"] = 1, ["isNew2"] = true},
	[727]   = {['class'] = "ThemeEgyptianPharaonsMain",    	['basebet'] = 10000,	['scale'] = 1, ['resourceId'] = 227, ['headerStyle'] = 7, ['name'] = "RISE OF EGYPT",	             ['chooseBetId'] = 727, ['loadingId'] = 227, ["portrait"] = 1,["questScale"] =1 , ["highLimit"] = 1},
	[728]   = {['class'] = "ThemeRisingPegasus",		    ['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 228, ['headerStyle'] = 7, ['name'] = "RISING PEGASUS",            ['chooseBetId'] = 728, ['loadingId'] = 228, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 1},
	[729]   = {['class'] = "ThemeRomanticQ_MainViewControl",	['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 229, ['headerStyle'] = 7, ['name'] = "ROMANTIC QUEEN",   ['chooseBetId'] = 729, ['loadingId'] = 229, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 1, ["isNew2"] = true},
    [730]   = {['class'] = "ThemeGRII_Main",    	['basebet'] = 10000,	['scale'] = 1, ['resourceId'] = 230, ['headerStyle'] = 7, ['name'] = "GOLD RUSH DELUXE",          ['chooseBetId'] = 730, ['loadingId'] = 230, ["portrait"] = 1,["questScale"] = 1 ,   ["highLimit"] = 1,["isNew2"] = true},
    [731]   = {['class'] = "ThemeMysteriousPixies_MainControl",    	['basebet'] = 10000,	['scale'] = 1, ['resourceId'] = 231, ['headerStyle'] = 2, ['name'] = "MYSTERIOUS PIXIES",          ['chooseBetId'] = 731, ['loadingId'] = 231, ["portrait"] = 0,["questScale"] = 1 ,   ["highLimit"] = 1, ["isNew2"] = true},
    [732]   = {['class'] = "ThemeSummerSurfingMain",    	['basebet'] = 10000,	['scale'] = 1, ['resourceId'] = 232, ['headerStyle'] = 2, ['name'] = "SURFERS PARADISE",          ['chooseBetId'] = 732, ['loadingId'] = 232, ["portrait"] = 0,["questScale"] = 1 ,   ["highLimit"] = 1},
    [733]   = {['class'] = "ThemeOrientalRiches_MainViewControl",    	['basebet'] = 10000,	['scale'] = 1, ['resourceId'] = 233, ['headerStyle'] = 2, ['name'] = "ORIENTAL RICHES",          ['chooseBetId'] = 733, ['loadingId'] = 233, ["portrait"] = 0,["questScale"] = 1 ,   ["highLimit"] = 1,["isNew2"] = true},
	[734]   = {['class'] = "ThemePengunB_MainViewControl",    	['basebet'] = 10000,	['scale'] = 1, ['resourceId'] = 234, ['headerStyle'] = 7, ['name'] = "PENGUIN'S BOUNTY",          ['chooseBetId'] = 734, ['loadingId'] = 234, ["portrait"] = 1,["questScale"] = 1 ,   ["highLimit"] = 1,["isNew2"] = true},
	[735]   = {['class'] = "ThemeWizardOfOz",		        ['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 235, ['headerStyle'] = 7, ['name'] = "LEGEND OF OZ",            ['chooseBetId'] = 735, ['loadingId'] = 235, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 1},
	[736]   = {['class'] = "EasterMain",             ['basebet'] = 10000,	['scale'] = 1, ['resourceId'] = 236, ['headerStyle'] = 2, ['name'] = "EASTER BONANZA",          ['chooseBetId'] = 736, ['loadingId'] = 236, ["portrait"] = 0,["questScale"] = 1 ,   ["highLimit"] = 1,["isNew2"] = true},
	[737]   = {['class'] = "ThemeCabinWoods_MainControl",       ['basebet'] = 10000,	['scale'] = 1, ['resourceId'] = 237, ['headerStyle'] = 2, ['name'] = "CABIN IN THE WOODS",          ['chooseBetId'] = 737, ['loadingId'] = 237, ["portrait"] = 0,["questScale"] = 1 ,   ["highLimit"] = 1,["isNew2"] = true},
	[738]   = {['class'] = "CannonBallMain",             ['basebet'] = 10000,	['scale'] = 1, ['resourceId'] = 238, ['headerStyle'] = 2, ['name'] = "PIGGY RICHES",          ['chooseBetId'] = 738, ['loadingId'] = 238, ["portrait"] = 0,["questScale"] = 1 ,   ["highLimit"] = 1,["isNew2"] = true},
	[739]   = {['class'] = "ThemePotPrizes_MainViewControl",     ['basebet'] = 10000,	['scale'] = 1, ['resourceId'] = 239, ['headerStyle'] = 7, ['name'] = "WICKED BELLE",          ['chooseBetId'] = 739, ['loadingId'] = 239, ["portrait"] = 1,["questScale"] = 1 ,   ["highLimit"] = 1,["isNew2"] = true},
	[740]   = {['class'] = "WestZoneMain",             ['basebet'] = 10000,	['scale'] = 1, ['resourceId'] = 240, ['headerStyle'] = 2, ['name'] = "WEST ZONE",          ['chooseBetId'] = 740, ['loadingId'] = 240, ["portrait"] = 0,["questScale"] = 1 ,   ["highLimit"] = 1,["isNew2"] = true},
	[741]   = {['class'] = "ThemeKingsPower_MainControl",		    ['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 241, ['headerStyle'] = 7, ['name'] = "KING'S POWER",            ['chooseBetId'] = 741, ['loadingId'] = 241, ["portrait"] = 1,["questScale"] = 1 , ["highLimit"] = 1, ["isNew2"] = true},
	[742]   = {['class'] = "ThemeOrientalFortune_MainControl",    	['basebet'] = 10000,	['scale'] = 1, ['resourceId'] = 242, ['headerStyle'] = 2, ['name'] = "ORIENTAL FORTUNE",          ['chooseBetId'] = 742, ['loadingId'] = 242, ["portrait"] = 0,["questScale"] = 1 ,   ["highLimit"] = 1, ["isNew2"] = true},
	[743]   = {['class'] = "ThreeMusketeers/ThreeMusketeersMain",    	['basebet'] = 10000,	['scale'] = 1, ['resourceId'] = 243, ['headerStyle'] = 2, ['name'] = "ORIENTAL FORTUNE",          ['chooseBetId'] = 743, ['loadingId'] = 243, ["portrait"] = 0,["questScale"] = 1 ,   ["highLimit"] = 1, ["isNew2"] = true},
	[744]   = {['class'] = "MightyC_MainViewControl",    	['basebet'] = 10000,	['scale'] = 1, ['resourceId'] = 244, ['headerStyle'] = 2, ['name'] = "RHINO RUSH",          ['chooseBetId'] = 744, ['loadingId'] = 244, ["portrait"] = 0,["questScale"] = 1 ,   ["highLimit"] = 0,["isNew2"] = true},
	[745]   = {['class'] = "BellAdamMain",    				['basebet'] = 10000,	['scale'] = 1, ['resourceId'] = 245, ['headerStyle'] = 2, ['name'] = "BELLE AND ADAM",       ['chooseBetId'] = 745, ['loadingId'] = 245, ["portrait"] = 0,["questScale"] = 1 ,   ["highLimit"] = 1,["isNew2"] = true},
	[746]   = {['class'] = "MadHatter/MadHatterMain",    			['basebet'] = 10000,	['scale'] = 1, ['resourceId'] = 246, ['headerStyle'] = 2, ['name'] = "Mr.Mad Hatter",       ['chooseBetId'] = 746, ['loadingId'] = 246, ["portrait"] = 0,["questScale"] = 1 ,   ["highLimit"] = 1,["isNew2"] = true},
	[749]   = {['class'] = "ThemeRobinHood_MainControl",    	['basebet'] = 10000,	['scale'] = 1, ['resourceId'] = 249, ['headerStyle'] = 7, ['name'] = "ROBIN HOOD",          ['chooseBetId'] = 749, ['loadingId'] = 249, ["portrait"] = 1,["questScale"] = 1 ,   ["highLimit"] = 1, ["isNew2"] = true},

    -- Quest
	-- [1101]	 = {['class'] = "ThemeElephantFortune",			['basebet'] = 7500, 	['scale'] = 1, ['resourceId'] = 101, ['headerStyle'] = 2, ['name'] = "LION TREASURE", 	         ['chooseBetId'] = 101, ['loadingId'] = 101, ["portrait"] = 0,["questScale"] = 1   , ["highLimit"] = 0},
	-- [1102]   = {['class'] = "ThemeLuckyDrums", 				['basebet'] = 8000, 	['scale'] = 1, ['resourceId'] = 102, ['headerStyle'] = 3, ['name'] = "FORTUNE GONG", 	 	     ['chooseBetId'] = 102, ['loadingId'] = 102, ["portrait"] = 1,["questScale"] = 0.9 , ["highLimit"] = 0},
	-- [1103]   = {['class'] = "ThemeBulkyLink", 		    	['basebet'] = 8000, 	['scale'] = 1, ['resourceId'] = 103, ['headerStyle'] = 2, ['name'] = "CELESTIAL DRAGON", 		 ['chooseBetId'] = 103, ['loadingId'] = 103, ["portrait"] = 0,["questScale"] = 1   , ["highLimit"] = 0},
	-- [1105]   = {['class'] = "ThemeWildFieryJackpots", 		['basebet'] = 8000, 	['scale'] = 1, ['resourceId'] = 105, ['headerStyle'] = 3, ['name'] = "HIGH POWER JACKPOTS",      ['chooseBetId'] = 105, ['loadingId'] = 105, ["portrait"] = 1,["questScale"] = 0.9 , ["highLimit"] = 0},
	-- [1106]   = {['class'] = "ThemeFuDaoCaiDao", 			['basebet'] = 8000, 	['scale'] = 1, ['resourceId'] = 106, ['headerStyle'] = 3, ['name'] = "EASTERN RICHES", 	 	     ['chooseBetId'] = 106, ['loadingId'] = 106, ["portrait"] = 1,["questScale"] = 0.9 , ["highLimit"] = 0},
	-- [1107]   = {['class'] = "ThemeCashWheelDeluxe", 	    ['basebet'] = 7500, 	['scale'] = 1, ['resourceId'] = 107, ['headerStyle'] = 4, ['name'] = "FORTUNE WHEEL DELUXE",     ['chooseBetId'] = 107, ['loadingId'] = 107, ["portrait"] = 1,["questScale"] = 0.9 , ["highLimit"] = 0},
	-- [1108]   = {['class'] = "ThemeChiefOfTheGods", 			['basebet'] = 7500, 	['scale'] = 1, ['resourceId'] = 108, ['headerStyle'] = 2, ['name'] = "THOR", 			 	     ['chooseBetId'] = 108, ['loadingId'] = 108, ["portrait"] = 0,["questScale"] = 1   , ["highLimit"] = 0},
	-- [1109]   = {['class'] = "ThemeEpicLinkCrystalDeluxe", 	['basebet'] = 5000, 	['scale'] = 1, ['resourceId'] = 109, ['headerStyle'] = 2, ['name'] = "DIAMONDS LIFE", 	 	     ['chooseBetId'] = 109, ['loadingId'] = 109, ["portrait"] = 0,["questScale"] = 1   , ["highLimit"] = 0},
	-- [1110]   = {['class'] = "ThemeHephaestusUnleashed", 	['basebet'] = 8000, 	['scale'] = 1, ['resourceId'] = 110, ['headerStyle'] = 3, ['name'] = "HEPHAESTUS", 			     ['chooseBetId'] = 110, ['loadingId'] = 110, ["portrait"] = 1,["questScale"] = 0.9 , ["highLimit"] = 0},
	-- [1111]   = {['class'] = "ThemeEpicLinkGoldReelBurst", 	['basebet'] = 5000, 	['scale'] = 1, ['resourceId'] = 111, ['headerStyle'] = 2, ['name'] = "GOLD BURST", 	 		     ['chooseBetId'] = 111, ['loadingId'] = 111, ["portrait"] = 0,["questScale"] = 1   , ["highLimit"] = 0},
	-- [1112]   = {['class'] = "ThemeRapidPayUltra", 			['basebet'] = 8000, 	['scale'] = 1, ['resourceId'] = 112, ['headerStyle'] = 3, ['name'] = "EGYPTIAN FANTASY", 	     ['chooseBetId'] = 112, ['loadingId'] = 112, ["portrait"] = 1,["questScale"] = 0.9 , ["highLimit"] = 0},
	-- [1113]   = {['class'] = "ThemeQuickHitPlatinumPlus", 	['basebet'] = 8000, 	['scale'] = 1, ['resourceId'] = 113, ['headerStyle'] = 3, ['name'] = "RAPID PAY PLATINUM", 	     ['chooseBetId'] = 113, ['loadingId'] = 113, ["portrait"] = 1,["questScale"] = 0.9 , ["highLimit"] = 0},
	-- [1114]   = {['class'] = "ThemeCandyMagic", 	        	['basebet'] = 5000, 	['scale'] = 1, ['resourceId'] = 114, ['headerStyle'] = 5, ['name'] = "CANDY MAGIC", 	 	     ['chooseBetId'] = 114, ['loadingId'] = 114, ["portrait"] = 0,["questScale"] = 1   , ["highLimit"] = 0},
	-- [1115]   = {['class'] = "ThemeMajesticPanda", 			['basebet'] = 8000, 	['scale'] = 1, ['resourceId'] = 115, ['headerStyle'] = 3, ['name'] = "REGAL TIGER", 	 	     ['chooseBetId'] = 115, ['loadingId'] = 115, ["portrait"] = 1,["questScale"] = 0.87, ["highLimit"] = 0},
	-- [1116]   = {['class'] = "ThemeHaidiBierHaus", 			['basebet'] = 8000, 	['scale'] = 1, ['resourceId'] = 116, ['headerStyle'] = 3, ['name'] = "LEPRECHAUN'S COINS", 	     ['chooseBetId'] = 116, ['loadingId'] = 116, ["portrait"] = 1,["questScale"] = 0.9 , ["highLimit"] = 0},
	-- [1117]   = {['class'] = "ThemeFiveTreasures", 			['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 117, ['headerStyle'] = 3, ['name'] = "BRILLIANT TREASURES", 	 ['chooseBetId'] = 117, ['loadingId'] = 117, ["portrait"] = 1,["questScale"] = 0.9 , ["highLimit"] = 0},
	-- [1118]   = {['class'] = "ThemeMammothGrand", 			['basebet'] = 8000, 	['scale'] = 1, ['resourceId'] = 118, ['headerStyle'] = 3, ['name'] = "MAMMOTH GRAND", 	 	     ['chooseBetId'] = 118, ['loadingId'] = 118, ["portrait"] = 1,["questScale"] = 0.9 , ["highLimit"] = 0},
	-- [1119]   = {['class'] = "ThemeCandyMagicGrand", 		['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 119, ['headerStyle'] = 3, ['name'] = "CANDY MAGIC GRAND", 	     ['chooseBetId'] = 119, ['loadingId'] = 119, ["portrait"] = 1,["questScale"] = 0.9 , ["highLimit"] = 0},
	-- [1120]   = {['class'] = "ThemeSpinItGrand", 			['basebet'] = 8000, 	['scale'] = 1, ['resourceId'] = 120, ['headerStyle'] = 3, ['name'] = "WINNER'S PARADISE", 	     ['chooseBetId'] = 120, ['loadingId'] = 120, ["portrait"] = 1,["questScale"] = 0.9 , ["highLimit"] = 0},
	-- [1121]   = {['class'] = "ThemeFortuneKitty", 		    ['basebet'] = 5000, 	['scale'] = 1, ['resourceId'] = 121, ['headerStyle'] = 5, ['name'] = "FORTUNE KITTY", 	         ['chooseBetId'] = 121, ['loadingId'] = 121, ["portrait"] = 0,["questScale"] = 1   , ["highLimit"] = 0},
 --    [1122]   = {['class'] = "ThemeBigMoney", 		        ['basebet'] = 8000, 	['scale'] = 1, ['resourceId'] = 122, ['headerStyle'] = 2, ['name'] = "BIG MONEY FRENZY", 	     ['chooseBetId'] = 122, ['loadingId'] = 122, ["portrait"] = 0,["questScale"] = 1   , ["highLimit"] = 0},
	-- [1123]   = {['class'] = "ThemeMermaid", 		    	['basebet'] = 8000, 	['scale'] = 1, ['resourceId'] = 123, ['headerStyle'] = 2, ['name'] = "POWER OF SEA", 	         ['chooseBetId'] = 123, ['loadingId'] = 123, ["portrait"] = 0,["questScale"] = 1   , ["highLimit"] = 0},
	-- [1124]   = {['class'] = "ThemeSmashPinata", 	    	['basebet'] = 8000, 	['scale'] = 1, ['resourceId'] = 124, ['headerStyle'] = 2, ['name'] = "HAPPY PIÑATA FIESTA",      ['chooseBetId'] = 124, ['loadingId'] = 124, ["portrait"] = 0,["questScale"] = 1   , ["highLimit"] = 0},
	-- [1125]   = {['class'] = "ThemeSplendidIsland", 			['basebet'] = 8000, 	['scale'] = 1, ['resourceId'] = 125, ['headerStyle'] = 3, ['name'] = "SPLENDID ISLAND", 	     ['chooseBetId'] = 125, ['loadingId'] = 125, ["portrait"] = 1,["questScale"] = 0.9 , ["highLimit"] = 0},
	-- [1126]   = {['class'] = "ThemeMagicJackpotVault", 		['basebet'] = 8000, 	['scale'] = 1, ['resourceId'] = 126, ['headerStyle'] = 2, ['name'] = "MAGIC JACKPOT VAULT",      ['chooseBetId'] = 126, ['loadingId'] = 126, ["portrait"] = 0,["questScale"] = 1   , ["highLimit"] = 0},
	-- [1127]   = {['class'] = "ThemeMrCashFrenzy", 		    ['basebet'] = 8000, 	['scale'] = 1, ['resourceId'] = 127, ['headerStyle'] = 2, ['name'] = "MR. Golden Slots", 	     ['chooseBetId'] = 127, ['loadingId'] = 127, ["portrait"] = 0,["questScale"] = 1   , ["highLimit"] = 0},
 -- 	[1128]   = {['class'] = "ThemeRoyalPuppies", 			['basebet'] = 8000, 	['scale'] = 1, ['resourceId'] = 128, ['headerStyle'] = 3, ['name'] = "ROYAL PUPPIES", 	 	     ['chooseBetId'] = 128, ['loadingId'] = 128, ["portrait"] = 1,["questScale"] = 0.9 , ["highLimit"] = 0},
 -- 	[1129]   = {['class'] = "ThemeBigMoneyHolidayFrenzy", 	['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 129, ['headerStyle'] = 3, ['name'] = "BIG MONEY HOLIDAY FRENZY", ['chooseBetId'] = 129, ['loadingId'] = 129, ["portrait"] = 1,["questScale"] = 0.9 , ["highLimit"] = 0},
	-- [1130]   = {['class'] = "ThemeMammothGrandGems", 		['basebet'] = 8000, 	['scale'] = 1, ['resourceId'] = 130, ['headerStyle'] = 3, ['name'] = "MAMMOTH GRAND GEMS", 		 ['chooseBetId'] = 130, ['loadingId'] = 130, ["portrait"] = 1,["questScale"] = 0.9 , ["highLimit"] = 0},
	-- [1131]   = {['class'] = "ThemeDiamondsLifeDeluxe", 		['basebet'] = 5000, 	['scale'] = 1, ['resourceId'] = 131, ['headerStyle'] = 3, ['name'] = "DIAMONDS LIFE DELUXE", 	 ['chooseBetId'] = 131, ['loadingId'] = 131, ["portrait"] = 1,["questScale"] = 0.9 , ["highLimit"] = 0},
	-- [1132]   = {['class'] = "ThemeHexoGems", 				['basebet'] = 8000, 	['scale'] = 1, ['resourceId'] = 132, ['headerStyle'] = 3, ['name'] = "MAJESTIC PANDA", 		 	 ['chooseBetId'] = 132, ['loadingId'] = 132, ["portrait"] = 1,["questScale"] = 0.9 , ["highLimit"] = 0},
	-- [1133]   = {['class'] = "ThemeMagicForest", 			['basebet'] = 8000, 	['scale'] = 1, ['resourceId'] = 133, ['headerStyle'] = 2, ['name'] = "SPIRITS OF PIXIES", 	 	 ['chooseBetId'] = 133, ['loadingId'] = 133, ["portrait"] = 0,["questScale"] = 1   , ["highLimit"] = 0},
	-- [1134]   = {['class'] = "ThemeTwinFireFrenzy", 			['basebet'] = 8000, 	['scale'] = 1, ['resourceId'] = 134, ['headerStyle'] = 3, ['name'] = "TWIN FIRE FRENZY", 	 	 ['chooseBetId'] = 134, ['loadingId'] = 134, ["portrait"] = 1,["questScale"] = 0.9 , ["highLimit"] = 0},
	-- [1135]   = {['class'] = "ThemeJinSeDao", 		        ['basebet'] = 8000, 	['scale'] = 1, ['resourceId'] = 135, ['headerStyle'] = 3, ['name'] = "CHILLI CHILLI HOT", 	     ['chooseBetId'] = 135, ['loadingId'] = 135, ["portrait"] = 1,["questScale"] = 0.8 , ["highLimit"] = 0},
	-- [1136]   = {['class'] = "ThemeFortuneGongV", 			['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 136, ['headerStyle'] = 3, ['name'] = "HOT HOT DRUMS", 	         ['chooseBetId'] = 136, ['loadingId'] = 136, ["portrait"] = 1,["questScale"] = 0.9 , ["highLimit"] = 0},
	-- Activity
	[2001]   = {['class'] = "ThemeSmokinHotRespin", 		['basebet'] = 5000, 	['scale'] = 1, ['resourceId'] = 2001, ['headerStyle'] = 5, ['name'] = "SMOKIN HOT RESPIN", 	       ['chooseBetId'] = 2001, ['loadingId'] = 2001, ["portrait"] = 0, ["highLimit"] = 0},
	[2002]   = {['class'] = "ThemeLuckyPuzzle", 		    ['basebet'] = 5000, 	['scale'] = 1, ['resourceId'] = 2002, ['headerStyle'] = 3, ['name'] = "LUCKY PUZZLE", 	           ['chooseBetId'] = 2002, ['loadingId'] = 2002, ["portrait"] = 1,["questScale"] = 0.9,["highLimit"] = 0},
	[2003]   = {['class'] = "ThemeLuckyDiceBonus", 		    ['basebet'] = 8000, 	['scale'] = 1, ['resourceId'] = 2003, ['headerStyle'] = 2, ['name'] = "LUCKY 7 BONUS", 	           ['chooseBetId'] = 2003, ['loadingId'] = 2003, ["portrait"] = 0, ["highLimit"] = 0},
	[2004]   = {['class'] = "ThemeBlazingChallengeRespin", 	['basebet'] = 5000, 	['scale'] = 1, ['resourceId'] = 2004, ['headerStyle'] = 5, ['name'] = "BLAZING CHALLENGE RESPIN",  ['chooseBetId'] = 2004, ['loadingId'] = 2004, ["portrait"] = 0, ["highLimit"] = 0},
	[2005]   = {['class'] = "ThemeLuckyPuzzle2", 		    ['basebet'] = 5000, 	['scale'] = 1, ['resourceId'] = 2005, ['headerStyle'] = 3, ['name'] = "LUCKY PUZZLE 2", 	       ['chooseBetId'] = 2005, ['loadingId'] = 2005, ["portrait"] = 1,["questScale"] = 0.9,["highLimit"] = 0},
	[2006]   = {['class'] = "ThemeLevelUpGame", 		    ['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 2006, ['headerStyle'] = 5, ['name'] = "LEVEL UP GAME", 	           ['chooseBetId'] = 2006, ['loadingId'] = 2006, ["portrait"] = 0, ["highLimit"] = 0},
	[2007]   = {['class'] = "ThemeLuckyPuzzle2Horizon", 	['basebet'] = 5000, 	['scale'] = 1, ['resourceId'] = 2007, ['headerStyle'] = 5, ['name'] = "LUCKY PUZZLE 2", 	       ['chooseBetId'] = 2007, ['loadingId'] = 2007, ["portrait"] = 0,["questScale"] = 0.85,["highLimit"] = 0,["useThemeID"]= 2005 },
	[2010]   = {['class'] = "TCGroillaMain",				['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 2010, ['headerStyle'] = 11, ['name'] = "LUCKY PUZZLE 2", 	       ['chooseBetId'] = 2010, ['loadingId'] = 2010, ["portrait"] = 0,["questScale"] = 1,["highLimit"] = 0 ,["isNew2"] = true},
	[2013]   = {['class'] = "TCWickedBelleMain", 	   		['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 2013, ['headerStyle'] = 11, ['name'] = "WICKED BELLE", 	       ['chooseBetId'] = 2013, ['loadingId'] = 2013, ["portrait"] = 0,["questScale"] = 1,["highLimit"] = 0 ,["isNew2"] = true},
	[2014]   = {['class'] = "TCMegaVaultMain", 	   		['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 2014, ['headerStyle'] = 11, ['name'] = "MEGA VAULT BILLIONAIRE",   ['chooseBetId'] = 2014, ['loadingId'] = 2014, ["portrait"] = 0,["questScale"] = 1,["highLimit"] = 0 ,["isNew2"] = true},
 
	-- 直接进入主题bonus 活动
	[3142]   = {['class'] = "ThemeActivityMammon", 		    ['basebet'] = 8000, 	['scale'] = 1, ['resourceId'] = 3142, ['headerStyle'] = 2, ['name'] = "ACTIVITY MAMMON", 	     ['chooseBetId'] = 3142, ['loadingId'] = 3142, ["portrait"] = 0, ["highLimit"] = 0},
	[3128]   = {['class'] = "ThemeActivityRoyalPuppies", 	['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 3128, ['headerStyle'] = 3, ['name'] = "ACTIVITY ROYAL PUPPIES",  ['chooseBetId'] = 3128, ['loadingId'] = 3128, ["portrait"] = 1, ["questScale"] = 0.82 , ["highLimit"] = 0},
	[3137]   = {['class'] = "ThemeActivityBalloonBonus",    ['basebet'] = 5000, 	['scale'] = 1, ['resourceId'] = 3137, ['headerStyle'] = 3, ['name'] = "BALLOON BONUS", 	         ['chooseBetId'] = 3137, ['loadingId'] = 3137, ["portrait"] = 1, ["highLimit"] = 0},
	[3139]   = {['class'] = "ThemeActivityHeadsOrTails",    ['basebet'] = 10000, 	['scale'] = 1, ['resourceId'] = 3139, ['headerStyle'] = 2, ['name'] = "HEADS OR TAILS BONUS", 	 ['chooseBetId'] = 3139, ['loadingId'] = 3139, ["portrait"] = 0, ["highLimit"] = 0},
} 

THEME_LIST[1101] = THEME_LIST[101]
THEME_LIST[1102] = THEME_LIST[102]
THEME_LIST[1103] = THEME_LIST[103]
THEME_LIST[1104] = THEME_LIST[104]
THEME_LIST[1105] = THEME_LIST[105]
THEME_LIST[1106] = THEME_LIST[106]
THEME_LIST[1107] = THEME_LIST[107]
THEME_LIST[1108] = THEME_LIST[108]
THEME_LIST[1109] = THEME_LIST[109]
THEME_LIST[1110] = THEME_LIST[110]
THEME_LIST[1111] = THEME_LIST[111]
THEME_LIST[1112] = THEME_LIST[112]
THEME_LIST[1113] = THEME_LIST[113]
THEME_LIST[1114] = THEME_LIST[114]
THEME_LIST[1115] = THEME_LIST[115]
THEME_LIST[1116] = THEME_LIST[116]
THEME_LIST[1117] = THEME_LIST[117]
THEME_LIST[1118] = THEME_LIST[118]
THEME_LIST[1119] = THEME_LIST[119]
THEME_LIST[1120] = THEME_LIST[120]
THEME_LIST[1121] = THEME_LIST[121]
THEME_LIST[1122] = THEME_LIST[122]
THEME_LIST[1123] = THEME_LIST[123]
THEME_LIST[1124] = THEME_LIST[124]
THEME_LIST[1125] = THEME_LIST[125]
THEME_LIST[1126] = THEME_LIST[126]
THEME_LIST[1127] = THEME_LIST[127]
THEME_LIST[1128] = THEME_LIST[128]
THEME_LIST[1129] = THEME_LIST[129]
THEME_LIST[1130] = THEME_LIST[130]
THEME_LIST[1131] = THEME_LIST[131]
THEME_LIST[1132] = THEME_LIST[132]
THEME_LIST[1133] = THEME_LIST[133]
THEME_LIST[1134] = THEME_LIST[134]
THEME_LIST[1135] = THEME_LIST[135]
THEME_LIST[1136] = THEME_LIST[136]
THEME_LIST[1137] = THEME_LIST[137]
THEME_LIST[1138] = THEME_LIST[138]
THEME_LIST[1139] = THEME_LIST[139]
THEME_LIST[1140] = THEME_LIST[140]
THEME_LIST[1141] = THEME_LIST[141]
THEME_LIST[1142] = THEME_LIST[142]
THEME_LIST[1143] = THEME_LIST[143]
THEME_LIST[1144] = THEME_LIST[144]
THEME_LIST[1145] = THEME_LIST[145]
THEME_LIST[1146] = THEME_LIST[146]
THEME_LIST[1147] = THEME_LIST[147]
THEME_LIST[1148] = THEME_LIST[148]
THEME_LIST[1149] = THEME_LIST[149]
THEME_LIST[1150] = THEME_LIST[150]
THEME_LIST[1151] = THEME_LIST[151]
THEME_LIST[1152] = THEME_LIST[152]
THEME_LIST[1153] = THEME_LIST[153]
THEME_LIST[1154] = THEME_LIST[154]
THEME_LIST[1155] = THEME_LIST[155]
THEME_LIST[1156] = THEME_LIST[156]
THEME_LIST[1157] = THEME_LIST[157]
THEME_LIST[1158] = THEME_LIST[158]
THEME_LIST[1159] = THEME_LIST[159]
THEME_LIST[1160] = THEME_LIST[160]
THEME_LIST[1161] = THEME_LIST[161]
THEME_LIST[1162] = THEME_LIST[162]
THEME_LIST[1163] = THEME_LIST[163]
THEME_LIST[1164] = THEME_LIST[164]
THEME_LIST[1165] = THEME_LIST[165]
THEME_LIST[1166] = THEME_LIST[166]
THEME_LIST[1167] = THEME_LIST[167]
THEME_LIST[1168] = THEME_LIST[168]
THEME_LIST[1169] = THEME_LIST[169]
THEME_LIST[1170] = THEME_LIST[170]
THEME_LIST[1171] = THEME_LIST[171]
THEME_LIST[1172] = THEME_LIST[172]
THEME_LIST[1174] = THEME_LIST[174]
THEME_LIST[1175] = THEME_LIST[175]
THEME_LIST[1176] = THEME_LIST[176]
THEME_LIST[1177] = THEME_LIST[177]
THEME_LIST[1178] = THEME_LIST[178]
THEME_LIST[1179] = THEME_LIST[179]
THEME_LIST[1180] = THEME_LIST[180]
THEME_LIST[1181] = THEME_LIST[181]
THEME_LIST[1182] = THEME_LIST[182]
THEME_LIST[1183] = THEME_LIST[183]
THEME_LIST[1184] = THEME_LIST[184]
THEME_LIST[1185] = THEME_LIST[185]
THEME_LIST[1186] = THEME_LIST[186]
THEME_LIST[1187] = THEME_LIST[187]
THEME_LIST[1188] = THEME_LIST[188]
THEME_LIST[1189] = THEME_LIST[189]
THEME_LIST[1190] = THEME_LIST[190]
THEME_LIST[1191] = THEME_LIST[191]
THEME_LIST[1193] = THEME_LIST[193]
THEME_LIST[1194] = THEME_LIST[194]
THEME_LIST[1195] = THEME_LIST[195]
THEME_LIST[1196] = THEME_LIST[196]
THEME_LIST[1197] = THEME_LIST[197]
THEME_LIST[1198] = THEME_LIST[198]
THEME_LIST[1199] = THEME_LIST[199]
THEME_LIST[1200] = THEME_LIST[200]
THEME_LIST[1201] = THEME_LIST[201]
THEME_LIST[1202] = THEME_LIST[202]
THEME_LIST[1203] = THEME_LIST[203]
THEME_LIST[1204] = THEME_LIST[204]
THEME_LIST[1205] = THEME_LIST[205]
THEME_LIST[1207] = THEME_LIST[207]
THEME_LIST[1208] = THEME_LIST[208]
THEME_LIST[1209] = THEME_LIST[209]
THEME_LIST[1210] = THEME_LIST[210]
THEME_LIST[1211] = THEME_LIST[211]
THEME_LIST[1212] = THEME_LIST[212]
THEME_LIST[1213] = THEME_LIST[213]
THEME_LIST[1214] = THEME_LIST[214]
THEME_LIST[1215] = THEME_LIST[215]
THEME_LIST[1217] = THEME_LIST[217]
THEME_LIST[1218] = THEME_LIST[218]
THEME_LIST[1219] = THEME_LIST[219]
THEME_LIST[1220] = THEME_LIST[220]
THEME_LIST[1221] = THEME_LIST[221]
THEME_LIST[1222] = THEME_LIST[222]
THEME_LIST[1223] = THEME_LIST[223]
THEME_LIST[1226] = THEME_LIST[226]
THEME_LIST[1227] = THEME_LIST[227]
THEME_LIST[1228] = THEME_LIST[228]
THEME_LIST[1231] = THEME_LIST[231]
THEME_LIST[1232] = THEME_LIST[232]
THEME_LIST[1233] = THEME_LIST[233]
THEME_LIST[1235] = THEME_LIST[235]
THEME_LIST[1237] = THEME_LIST[237]
THEME_LIST[1240] = THEME_LIST[240]
THEME_LIST[1241] = THEME_LIST[241]
THEME_LIST[1242] = THEME_LIST[242]
THEME_LIST[1243] = THEME_LIST[243]
THEME_LIST[1246] = THEME_LIST[246]

