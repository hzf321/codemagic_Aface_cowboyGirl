
JackpotControl = class("JackpotControl")

local jackpot_sync_duration = 30
local jackpot_keep_alive_duration = 5
local jackpot_sync_win_duration = 3
local action_tag_jp_roll = 666666


-------------------------------------初始化-------------------------------
local JP_INCREASE_THEME_INFINITY = 0.00000112121312312321312312312311
local JP_INCREASE_RATE_THEME_MUTILIST = {10,20,50,100,200,500,1000,5000}
local JP_INCREASE_RATE_THEME_LOBBY = {[10]=0.0051213212321,[20]=0.002123212321211,[50]=0.0015123212321211,[100]=0.00111231312311231231311,[200]=0.00051231312311231231312,[500]=0.000212313123123123131121221123,[1000]=0.0000712121312312321312312312311,[5000]=0.00000312121312312321312312312311}
local JP_INCREASE_RATE_THEME_INTHEME = {[10]=0.0011213212321,[20]=0.000523212321211,[50]=0.0003123212321211,[100]=0.00021231312311231231311,[200]=0.00011231312311231231312,[500]=0.00005112313123123123131121221123,[1000]=0.0000212121312312321312312312311,[5000]=0.0000032121312312321312312312311}

local JP_INCREASE_BONUS_INFINITY = 0.00000112121312312321312312312311
local JP_INCREASE_RATE_BONUS_MUTILIST = {20,50,100,200,500,1000,5000}
local JP_INCREASE_RATE_BONUS = {
grand = {[20]=0.0000112312313,[50]=0.000008131231231,[100]=0.00000532123212112,[200]=0.00000231312311231231311,[500]=0.00000111312311231231312,[1000]=0.0000008123131231231231311212211,[5000]=0.00000042121312312321312312312311},
major = {[20]=0.0000512132123,[50]=0.000043212321211,[100]=0.00002223212321211,[200]=0.00000931312311231231311,[500]=0.00000551312311231231312,[1000]=0.0000035313123123123131121221123,[5000]=0.00000181121312312321312312312311},
minor = {[20]=0.0000952342342,[50]=0.000078212321211,[100]=0.00005232123212112,[200]=0.00002231312311231231311,[500]=0.00001131312311231231312,[1000]=0.0000062313123123123131121221123,[5000]=0.00000333121312312321312312312311}
}

local JACKPOT_RESET_DATA =
{
    [999] =
    {
        grand = 25000000,
        major = 15000000,
        minor = 5000000,
    },
    [101] =
    {
        major = 600,
        minor = 60,
        mini  = 20,
    },
    [102] =
    {
        grand = 10000,
        major = 300,
        minor = 20,
        mini  = 5,
    },
    [103] =
    {
        grand = 5000,
        major = 1250,
        maxi = 625,
    },
    [105] =
    {
        grand = 166.6,
        major = 33.3,
        maxi  = 16.6,
        minor = 10,
        mini  = 5,
    },
    [106] =
    {
        grand = 10000,
        major = 300,
        minor = 20,
        mini  = 5,
        mystery = 100 ,
    },
    [107] =
    {
        grand = 5000,
        major = 1000,
        minor = 60,
        mini  = 10,
    },
    [108] =
    {
        zeus  = 6666.6,
        mega  = 666.6,
        major = 133.3,
        minor = 10,
        mini  = 4,
    },
    [109] =
    {
        grand = 5000,
        major = 800,
    },
    [110] =
    {
        hephaestus = 5000,
        mega  = 500,
        major = 100,
        minor = 7.5,
        mini  = 3,
    },
    [111] =
    {
        grand = 5000,
        major = 1000,
        minor = 40,
        mini  = 10,
    },
    [112] =
    {
        grand = 1500,
        major = 400,
        maxi  = 100,
        minor = 40,
        mini  = 10,
    },
    [113] =
    {
        platinum = 5000,
        grand = 2000,
        major = 650,
        maxi  = 100,
        minor = 50,
        mini  = 10,
    },
    [114] =
    {
        grand = 1000,
        major = 200,
        minor = 10,

    },
    [115] =
    {
        grand = 5000,
        major = 200,
        minor = 50,
        mini  = 10,
    },
    [116] =
    {
        grand = 5000,
        major = 1000,
        minor = 200,
        mini  = 10
    },
    [118] =
    {
        grand = 5000,
        major = 1000,
        minor = 100,
    },
    [119] =
    {
        grand = 1000,
        major = 200,
        minor = 10,
    },
    [120] =
    {
        grand = 5000,
        major = 100,
        minor = 10,
    },
    [121] =
    {
        grand = 5000,
        major = 1000,
        minor = 40,
        mini  = 10,
    },
    [122] =
    {
        grand = 5000,
        major = 200,
        minor = 50,
        mini  = 10,
    },
    [123] =
    {
        grand = 1000,
        major = 100,
        minor = 10,
        mini  = 5,
    },
    [124] =
    {
        grand = 1000,
        major = 50,
        minor = 5,
    },
    [125] =
    {
        grand = 1000,
        major = 100,
        minor = 10,
        mini  = 5,
    },
    [126] =
    {
        rapid9 = 2000,
        rapid8 = 650,
        rapid7 = 100,
        rapid6 = 50,
        rapid5 = 10,
        grand  = 2000,
        major  = 650,
        maxi   = 100,
        minor  = 50,
        mini   = 10,
    },
    [127] =
    {
        grand = 1000,
        major = 100,
        minor = 50,
        mini  = 10,
    },
    [128] =
    {
        grand = 1000,
        major = 50,
        minor = 10,
        mini  = 5,
    },
    [129] =
    {
        grand = 5000,
        major = 100,
        minor = 20,
        mini  = 10,
    },
    [130] =
    {
        grand = 5000,
        major = 800,

        minor = 50,
    },
    [131] =
    {
        super = 8000,
        grand = 5000,
        major = 800,
        minor = 40,
        mini  = 8,
    },
    [132] =
    {
        grand = 1000,
        major = 200,
        minor = 50,
        mini  = 10,
    },
    [133] =
    {
        grand = 5000,
        major = 500,
        minor = 100,
        mini  = 20,
    },
    [134] =
    {
        grand  = 5000,
        rapid9 = 2000,
        rapid8 = 650,
        rapid7 = 100,
        rapid6 = 50,
        rapid5 = 10,
    },
    [135] =
    {
        grand = 5000,
        major = 500,
        minor = 100,
        mini  = 10,

    },
    [136] =
    {
        grand = 5000,
        major = 1000,
        minor = 40,
        mini  = 10,
    },
    [137] =
    {
        grand = 10000,
        major = 300,
        minor = 20,
        mini  = 5,

    },
    [138] =
    {
        grand = 3000,
        maxi  = 1000,
        major = 400,
        minor = 20,
        mini  = 10,

    },
    [139] =
    {
        grand = 5000,
        major = 500,
        minor = 50,
        mini  = 10,
    },
    [140] =
    {
        pot15 = 5000,
        pot14 = 2000,
        pot13 = 1000,
        pot12 = 500,
        pot11 = 100,
        pot10 = 50,
        pot9 = 30,
        pot8 = 20,
        pot7 = 15,
        pot6 = 10,
        pot5 = 5,
    },
    [141] = -- [5000, 500, 50, 10]
    {
        grand = 5000,
        major = 500,
        minor = 50,
        mini  = 10,
    },
    [142] =
    {
        grand = 5000,
        major = 500,
        minor = 50,
        mini  = 10,
    },
    [143] =
    {
        grand = 5000,
        major = 500,
        minor = 50,
        mini  = 10,

    },
    [144] =
    {
        grand = 5000,
        major = 500,
        minor = 20,
        mini  = 10,

    },
    [145] =
    {
        grand = 1000,
        major = 100,
        minor = 20,
        mini  = 10,
    },
    [146] =
    {
        grand = 5000,
        major = 500,
        minor = 20,
        mini  = 10,
    },
    [147] =
    {
        grand = 5000,
        major = 1000,
        minor = 20,
    },
    [148] =
    {
        grand = 5000,
        major = 500,
        minor = 20,
        mini  = 10,
    },
    [149] =
    {
        grand = 5000,
        major = 500,
        minor = 20,
        mini  = 10,
    },
    [150] =
    {
        grand = 5000,
        major = 250,
        minor = 20,
        mini = 10,
    },
    [151] =
    {
        grand = 5000,
        major = 500,
        minor = 20,
        mini  = 10,
    },
    [152] =
    {
        grand = 5000,
        maxi = 500,
        major = 100,
        minor = 20,
        mini  = 10,
    },
    [153] =
    {
        grand = 5000,
        major = 1000,
        minor = 20,
        mini  = 10,
    },
    [154] = -- 5000,100,5,2
    {
        grand = 5000,
        major = 100,
        minor = 5,
        mini  = 2,
    },
    [155] =
    {
        grand = 5000,
        major = 500,
        minor = 20,
        mini  = 10,
    },
    [156] =
    {
        grand = 5000,
        major = 100,
        minor = 20,
    },
    [157] =
    {
        grand = 5000,
        major = 200,
        minor = 20,
        mini  = 5,
    },
    [158] =
    {
        grand = 5000,
        major = 1250,
        maxi = 625,
        minor = 10,
        mini  = 5,
    },
    [159] =
    {
        grand = 10000,
        major = 300,
        minor = 20,
        mini  = 5,
    },
    [160] =
    {
        grand = 5000,
        major = 500,
        minor = 10,
    },
    [161] =
    {
        grand = 5000,
        major = 1000,
        minor = 100,
        mini = 20
    },
    [162] =
    {
        grand = 10000,
        major = 300,
        minor = 20,
        mini = 5
    },
    [163] =
    {
        grand = 5000,
        major = 500,
        minor = 50,
    },
    [164] =
    {
        grand = 5000,
        major = 1250,
        maxi = 625,
        minor = 20,
        mini = 10
    },
    [165] =
    {
        grand = 10000,
        major = 300,
        minor = 20,
        mini = 5
    },
    [166] =
    {
        grand = 5000,
        major = 500,
        minor = 20,
        mini = 10
    },
    [167] =
    {
        grand = 5000,
        maxi  = 500,
        major = 100,
        minor = 10,
        mini = 5
    },
    [168] =
    {
        grand = 5000,
        major = 500,
        minor = 20,
        mini = 10
    },
    [169] =
    {
        grand = 5000,
        major = 200,
        minor = 10,
    },
    [170] =
    {
        grand = 5000,
        major = 500,
        minor = 10,

    },
    [171] =
    {
        grand = 5000,
        maxi  = 1000,
        major = 100,
        minor = 20,
        mini  = 10
    },
    [172] =
    {
        grand = 5000,
        major = 200,
        minor = 50,
        mini = 10
    },
    [173] =
    {
        rapid10 = 5000,
        rapid9 = 2500,
        rapid8 = 1000,
        rapid7 = 500,
        rapid6 =  50,
        rapid5 =  10,
    },
    [174] =
    {
        grand = 5000,
        major = 500,
        minor = 20,
        mini =  10
    },
    [175] =
    {
        grand = 5000,
        mega = 500,
        maxi = 50,
        major = 20,
        minor = 10,
        mini = 5
    },
    [176] =
    {
        grand = 5000,
        mega = 1000,
        maxi = 100,
        major = 20,
        minor = 10,
        mini = 5
    },
    [177] =
    {
        grand = 5000,
        maxi = 1250,
        major = 500,
        minor = 20,
        mini = 10,
    },
    [178] =
    {
        grand = 5000,
        major = 500,
        minor = 20,
    },
    [179] =
    {
        grand = 5000,
        major = 500,
        minor = 20,
        mini = 10
    },
    [180] =
    {
        grand = 5000,
        major = 500,
        maxi = 50,
        minor = 20,
        mini = 10
    },
    [181] =
    {
        grand = 5000,
        mega = 1000,
        major = 500,
        minor = 50,
        mini = 5,
    },
    [182] =
    {
        grand = 5000,
        major = 500,
        minor = 20,
    },
    [183] =
    {
        grand = 5000,
        major = 500,
        minor = 10,
        mini = 5
    },
    [184] =
    {
        grand = 5000,
        major = 500,
        minor = 10,
    },
    [185] =
    {
        grand = 5000,
        major = 500,
        minor = 50,
        mini = 10,
    },
    [186] =
    {
        grand = 5000,
        mega = 1000,
        major = 200,
        minor = 20,
        mini = 10,
    },
    [187] =
    {
        grand = 5000,
        major = 500,
        minor = 20,
        mini = 5,
    },
    [188] =
    {
        grand = 5000,
        major = 300,
        minor = 20,
    },
    [189] =
    {
        grand = 5000,
        mega = 1000,
        maxi = 100,
        major = 20,
        minor = 10,
        mini = 5
    },
    [190] =
    {
        grand = 5000,
        mega = 1000,
        maxi = 150,
        major = 50,
        minor = 20,
        mini = 5,
    },
    [191] =
    {
        grand = 5000,
        maxi = 1000,
        major = 100,
        minor = 20,
        mini = 5,
    },
    [192] =
    {
        grand = 5000,
        major = 100,
        minor = 10,
        mini = 5,
    },
    [193] =
    {
        rapid9 = 2000,
        rapid8 = 500,
        rapid7 = 100,
        rapid6 =  50,
        rapid5 =  10,
    },
    [194] =
    {
        grand = 5000,
        mega = 500,
        major = 100,
        minor = 20,
        mini = 10,
    },
    [195] =
    {
        grand = 5000,
        major = 500,
        minor = 20,
        mini = 10,
    },
    [196] =
    {
        grand = 5000,
        major = 300,
        minor = 20,
    },
    [197] =
    {
        grand = 10000,
        major = 300,
        minor = 20,
        mini  = 5,
    },
    [198] =
    {
        grand = 5000,
        maxi =  500,
        major = 50,
        minor = 15,
        mini =  5,
    },
    [199] =
    {
        grand = 5000,
        major = 100,
        minor = 20,
        mini = 5,
    },
    [200] =
    {
        grand = 5000,
        major = 500,
        minor = 50,
        mini  = 10,
    },
    [201] =
    {
        grand   = 5000,
        maxi    = 500,
        major   = 50,
        minor   = 20,
        mini    = 10,
    },
    [202] =
    {
        grand = 5000,
        major = 300,
        minor = 20,
        mini = 5
    },
    [203] =
    {
        grand = 5000,
        major = 300,
        minor = 10,
    },
    [204] =
    {
        grand = 5000,
        major = 500,
        minor = 20,
        mini  = 10,
    },
    [205] =
    {
        grand = 5000,
        major = 250,
        minor = 25,
        mini  = 10,
    },
    [206] = {
        grand = 5000,
        ultra = 1000,
        maxi  = 500,
        major = 100,
        minor = 25,
        mini  = 5,
    },
    [207] =
    {
        grand = 5000,
        major = 300,
        minor = 20,
        mini = 5,
    },
    [208] =
    {
        grand = 5000,
        major = 100,
        minor = 10,
    },
    [209] =
    {
        grand = 1000,
        major = 20,
        minor = 5,
    },
    [210] =
    {
        grand = 5000,
        major = 500,
        minor = 50,
        mini  = 10,
    },
    [211] =
    {
        grand = 1000,
        major = 200,
        minor = 50,
        mini  = 20,
    },
    [212] =
    {
        grand = 1000,
        major = 100,
        minor = 25,
        mini  = 10,
    },
    [214] =
    {
        grand = 1000,
        major = 200,
        minor = 30,
        mini  = 5,
    },
    [213] =
    {
        grand = 1000,
        major = 100,
        minor = 15
    },
    [215] =
    {
        grand   = 1000,
        mega    = 100,
        major   = 50,
        minor   = 25,
        mini    = 10,
    },
    [216] =
    {
        grand   = 1000,
        major   = 200,
        minor   = 50,
        mini    = 20,
    },
    [217] =
    {
        grand = 1000,
        major = 200,
        minor = 50,
        mini  = 10,
    },
    [218] =
    {
        grand = 1000,
        mega = 300,
        maxi = 100,
        major = 20,
        minor = 10,
        mini = 5
    },
    [219] =
    {
        grand = 1000,
        major = 100,
        minor = 25,
        mini = 10
    },
    [220] =
    {
        grand = 1000,
        major = 200,
        minor = 50,
        mini = 20
    },
    [221] =
    {
        grand   = 1000,
        maxi    = 400,
        major   = 100,
        minor   = 40,
        mini    = 10,
    },
    [222] =
    {
        grand   = 1000,
        major   = 300,
        minor   = 20,
        mini    = 5,
    },
    [223] =
    {
        rapid9_yang = 1000,
        rapid8_yang = 200,
        rapid7_yang = 50,
        rapid6_yang = 20,
        rapid5_yang = 10,
        rapid9_yin  = 1000,
        rapid8_yin  = 200,
        rapid7_yin  = 50,
        rapid6_yin  = 20,
        rapid5_yin  = 10,
        rapid10     = 2000,
    },
    [224] =
    {
        grand = 1000,
        major = 100,
        minor =  10,
    },
    [226] =
    {
        grand = 1000,
        major = 100,
        minor = 25,
        mini = 10
    },
    [225] =
    {
        gold_jackpot    = 500,
        blue_jackpot    = 100,
        red_jackpot     = 25,
    },
    [227] =
    {
        grand   = 1000,
        maxi    = 100,
        major   = 25,
        minor   = 10,
        mini    = 5,
    },
    [228] =
    {
        grand   = 1000,
        major   = 100,
        minor   = 20,
    },
    [229] =
    {
        grand   = 1000,
        major   = 100,
        maxi    = 25,
    },
    [230] =
    {
        grand   = 1000,
        major   = 25,
        minor   = 15,
    },
    [231] =
    {
        grand   = 1000,
        major   = 50,
        minor   = 10,
    },
    [232] =
    {
        grand   = 1000,
        major   = 100,
        minor   = 25,
        mini    = 10,
    },
    [233] =
    {
        grand   = 1000,
        major   = 100,
        minor   = 20,
    },
    [234] =
    {
        grand   = 1000,
        mega    = 100,
        major   = 50,
        minor   = 25,
        mini    = 10,
    },
    [235] =
    {
        grand   = 1000,
        mega    = 100,
        major   = 25,
        minor   = 10,
        mini    = 5,
    },
    [236] =
    {
        grand   = 1000,
        major   = 50,
        minor   = 10,
    },
    [237] =
    {
        grand   = 1000,
        mega    = 100,
        maxi    = 50,
        major   = 25,
        minor   = 10,
        mini    = 5,
    },
    [238] =
    {
        grand   = 1000,
        major   = 100,
        minor   = 20,
        mini    = 5,
    },
    [239] =
    {
        grand   = 1000,
        major   = 100,
        minor   = 10,
    },
    [240] =
    {
        grand   = 1000,
        major   = 50,
        minor   = 10,
    },
    [241] =
    {
        grand   = 1000,
        mega    = 100,
        major   = 50,
        minor   = 25,
        mini    = 10,
    },
    [242] =
    {
        grand   = 1000,
        maxi    = 100,
        major   = 50,
        minor   = 25,
        mini    = 10,
    },
    [243] =
    {
        grand   = 1000,
        maxi    = 100,
        major   = 50,
        minor   = 25,
        mini    = 10,
    },
    [244] =
    {
        grand   = 1000,
        maxi    = 500,
        major   = 100,
        minor   = 25,
        mini    = 10,
    },
    [245] =
    {
        grand   = 1000,
        major   = 100,
        minor   = 25,
        mini   = 10,
    },
    [246] =
    {
        grand   = 1000,
        major   = 100,
        minor   = 25,
        mini   = 10,
    },
    [249] =
    {
        grand   = 1000,
        mega    = 100,
        major   = 50,
        minor   = 25,
        mini    = 10,
    },
    [325] =
    {
        rapid9_yang = 1000,
        rapid8_yang = 200,
        rapid7_yang = 50,
        rapid6_yang = 20,
        rapid5_yang = 10,
        rapid9_yin  = 1000,
        rapid8_yin  = 200,
        rapid7_yin  = 50,
        rapid6_yin  = 20,
        rapid5_yin  = 10,
        rapid10     = 2000,
    },
    [2001] =
    {
        grand = 5000,
        major = 100,
        minor = 10,
    },

    [2004] =
    {
        grand = 5000,
    },
    [2006] =
    {
        grand = 200,
        major = 50,
        minor = 10,
    },
    [2007] =
    {
        grand = 200,
        major = 50,
        minor = 10,
    },
}


local theme_jackpot_reset_config =
{
    -- bonus
    [999] = 999,
    -- 普通房游戏
    [101] = 101,
    [102] = 102,
    [103] = 103,
    [104] = 103,
    [105] = 105,
    [106] = 106,
    [107] = 107,
    [108] = 108,
    [109] = 109,
    [110] = 110,
    [111] = 111,
    [112] = 112,
    [113] = 113,
    [114] = 114,
    [115] = 115,
    [116] = 116,
    [117] = 102,
    [118] = 118,
    [119] = 119,
    [120] = 120,
    [121] = 121,
    [122] = 122,
    [123] = 123,
    [124] = 124,
    [125] = 125,
    [126] = 126,
    [127] = 127,
    [128] = 128,
    [129] = 129,
    [130] = 130,
    [131] = 131,
    [132] = 132,
    [133] = 133,
    [134] = 134,
    [135] = 135,
    [136] = 136,
    [137] = 137,
    [138] = 138,
    [139] = 139,
    [140] = 140,
    [141] = 141,
    [142] = 142,
    [143] = 143,
    [144] = 144,
    [145] = 145,
    [146] = 146,
    [147] = 147,
    [148] = 148,
    [149] = 149,
    [150] = 150,
    [151] = 151,
    [152] = 152,
    [153] = 153,
    [154] = 154,
    [155] = 155,
    [156] = 156,
    [157] = 157,
    [158] = 158,
    [159] = 159,
    [160] = 160,
    [161] = 161,
    [162] = 162,
    [163] = 163,
    [164] = 164,
    [165] = 165,
    [166] = 166,
    [167] = 167,
    [168] = 168,
    [169] = 169,
    [170] = 170,
    [171] = 171,
    [172] = 172,
    [173] = 173,
    [174] = 174,
    [175] = 175,
    [176] = 176,
    [177] = 177,
    [178] = 178,
    [179] = 179,
    [180] = 180,
    [181] = 181,
    [182] = 182,
    [183] = 183,
    [184] = 184,
    [185] = 185,
    [186] = 186,
    [187] = 187,
    [188] = 188,
    [189] = 189,
    [190] = 190,
    [191] = 191,
    [192] = 192,
    [193] = 193,
    [194] = 194,
    [195] = 195,
    [196] = 196,
    [197] = 197,
    [198] = 198,
    [199] = 199,
    [200] = 200,
    [201] = 201,
    [202] = 202,
    [203] = 203,
    [204] = 204,
    [205] = 205,
    [206] = 206,
    [207] = 207,
    [208] = 208,
    [209] = 209,
    [210] = 210,
    [211] = 211,
    [212] = 212,
    [213] = 213,
    [214] = 214,
    [215] = 215,
    [216] = 216,
    [217] = 217,
    [218] = 218,
    [219] = 219,
    [220] = 220,
    [221] = 221,
    [222] = 222,
    [223] = 223,
    [224] = 224,
    [226] = 226,
    [225] = 225,
    [227] = 227,
    [228] = 228,
    [229] = 229,
    [230] = 230,
    [231] = 231,
    [232] = 232,
    [233] = 233,
    [234] = 234,
    [235] = 235,
    [236] = 236,
    [237] = 237,
    [238] = 238,
    [239] = 239,
    [240] = 240,
    [241] = 241,
    [242] = 242,
    [243] = 243,
    [244] = 244,
    [245] = 245,
    [246] = 246,
    [249] = 249,

    [325] = 325,

    -- 高级房游戏
    [601] = 101,
    [602] = 102,
    [603] = 103,
    [604] = 103,
    [605] = 105,
    [606] = 106,
    [609] = 109,
    [607] = 107,
    [608] = 108,
    [610] = 110,
    [611] = 111,
    [612] = 112,
    [613] = 113,
    [614] = 114,
    [615] = 115,
    [616] = 116,
    [617] = 102,
    [618] = 118,
    [619] = 119,
    [620] = 120,
    [621] = 121,
    [622] = 122,
    [623] = 123,
    [624] = 124,
    [625] = 125,
    [626] = 126,
    [627] = 127,
    [628] = 128,
    [629] = 129,
    [630] = 130,
    [631] = 131,
    [632] = 132,
    [633] = 133,
    [634] = 134,
    [635] = 135,
    [636] = 136,
    [637] = 137,
    [638] = 138,
    [639] = 139,
    [640] = 140,
    [641] = 141,
    [642] = 142,
    [643] = 143,
    [644] = 144,
    [645] = 145,
    [646] = 146,
    [647] = 147,
    [648] = 148,
    [649] = 149,
    [650] = 150,
    [651] = 151,
    [652] = 152,
    [653] = 153,
    [654] = 154,
    [655] = 155,
    [656] = 156,
    [657] = 157,
    [658] = 158,
    [659] = 159,
    [660] = 160,
    [661] = 161,
    [662] = 162,
    [663] = 163,
    [664] = 164,
    [665] = 165,
    [666] = 166,
    [667] = 167,
    [668] = 168,
    [669] = 169,
    [670] = 170,
    [671] = 171,
    [672] = 172,
    [673] = 173,
    [674] = 174,
    [675] = 175,
    [676] = 176,
    [677] = 177,
    [678] = 178,
    [679] = 179,
    [680] = 180,
    [681] = 181,
    [682] = 182,
    [683] = 183,
    [684] = 184,
    [685] = 185,
    [686] = 186,
    [687] = 187,
    [688] = 188,
    [689] = 189,
    [690] = 190,
    [691] = 191,
    [692] = 192,
    [693] = 193,
    [694] = 194,
    [695] = 195,
    [696] = 196,
    [697] = 197,
    [698] = 198,
    [699] = 199,
    [700] = 200,
    [701] = 201,
    [702] = 202,
    [703] = 203,
    [704] = 204,
    [705] = 205,
    [706] = 206,
    [707] = 207,
    [708] = 208,
    [709] = 209,
    [710] = 210,
    [711] = 211,
    [712] = 212,
    [713] = 213,
    [714] = 214,
    [715] = 215,
    [716] = 216,
    [717] = 217,
    [718] = 218,
    [719] = 219,
    [720] = 220,
    [721] = 221,
    [722] = 222,
    [723] = 223,
    [724] = 224,
    [726] = 226,
    [725] = 225,
    [727] = 227,
    [728] = 228,
    [729] = 229,
    [730] = 230,
    [731] = 231,
    [732] = 232,
    [733] = 233,
    [734] = 234,
    [735] = 235,
    [736] = 236,
    [737] = 237,
    [738] = 238,
    [739] = 239,
    [740] = 240,
    [741] = 241,
    [742] = 242,
    [743] = 243,
    [744] = 244,
    [745] = 245,
    [746] = 246,
    [749] = 249,
    
    [825] = 325,

    -- Quest
    [1101] = 101,
    [1102] = 102,
    [1103] = 103,
    [1105] = 105,
    [1106] = 106,
    [1107] = 107,
    [1108] = 108,
    [1109] = 109,
    [1110] = 110,
    [1111] = 111,
    [1112] = 112,
    [1113] = 113,
    [1114] = 114,
    [1115] = 115,
    [1116] = 116,
    [1117] = 102,
    [1118] = 118,
    [1119] = 119,
    [1120] = 120,
    [1121] = 121,
    [1122] = 122,
    [1123] = 123,
    [1124] = 124,
    [1125] = 125,
    [1126] = 126,
    [1127] = 127,
    [1128] = 128,
    [1129] = 129,
    [1130] = 130,
    [1131] = 131,
    [1132] = 132,
    [1133] = 133,
    [1134] = 134,
    [1135] = 135,
    [1136] = 136,
    [1137] = 137,
    [1138] = 138,
    [1139] = 139,
    [1140] = 140,
    [1141] = 141,
    [1142] = 142,
    [1143] = 143,
    [1144] = 144,
    [1145] = 145,
    [1146] = 146,
    [1147] = 147,
    [1148] = 148,
    [1149] = 149,
    [1150] = 150,
    [1151] = 151,
    [1152] = 152,
    [1153] = 153,
    [1154] = 154,
    [1155] = 155,
    [1156] = 156,
    [1157] = 157,
    [1158] = 158,
    [1159] = 159,
    [1160] = 160,
    [1161] = 161,
    [1162] = 162,
    [1163] = 163,
    [1164] = 164,
    [1165] = 165,
    [1166] = 166,
    [1167] = 167,
    [1168] = 168,
    [1169] = 169,
    [1170] = 170,
    [1171] = 171,
    [1172] = 172,
    [1173] = 173,
    [1174] = 174,
    [1175] = 175,
    [1176] = 176,
    [1177] = 177,
    [1178] = 178,
    [1179] = 179,
    [1180] = 180,
    [1181] = 181,
    [1182] = 182,
    [1183] = 183,
    [1184] = 184,
    [1185] = 185,
    [1186] = 186,
    [1187] = 187,
    [1188] = 188,
    [1189] = 189,
    [1190] = 190,
    [1191] = 191,
    [1192] = 192,
    [1193] = 193,
    [1194] = 194,
    [1195] = 195,
    [1197] = 197,
    [1198] = 198,
    [1199] = 199,
    [1200] = 200,
    [1201] = 201,
    [1202] = 202,
    [1203] = 203,
    [1204] = 204,
    [1205] = 205,
    [1207] = 207,
    [1208] = 208,
    [1209] = 209,
    [1210] = 210,
    [1211] = 211,
    [1212] = 212,
    [1213] = 213,
    [1214] = 214,
    [1215] = 215,
    [1216] = 216,
    [1217] = 217,
    [1218] = 218,
    [1219] = 219,
    [1220] = 220,
    [1221] = 221,
    [1222] = 222,
    [1223] = 223,
    [1224] = 224,
    [1226] = 226,
    [1225] = 225,
    [1227] = 227,
    [1228] = 228,
    [1229] = 229,
    [1231] = 231,
    [1232] = 232,
    [1233] = 233,
    [1234] = 234,
    [1235] = 235,
    [1237] = 237,
    [1238] = 238,
    [1240] = 240,
    [1241] = 241,
    [1242] = 242,
    [1243] = 243,
    [1246] = 246,
    [1249] = 249,

    [1325] = 325,

    -- special game
    [2001] = 2001,
    [2004] = 2004,
    [2006] = 2006,

}

-- 构造函数
function JackpotControl:ctor ()
    -- self:initPotpCmd()
    self:reset()
    -- 每隔5s从服务器请求一次是否中奖数据
    -- self.requestTime = 0
    -- cc.Director:getInstance():getScheduler():scheduleScriptFunc(function ()
    --     if User:getInstance().user_id then
    --         bole.potp:send(KEEP_ALIVE,{})
    --         -- self.requestTime = os.time()

    --     end
    -- end, jackpot_keep_alive_duration, false)
end

function JackpotControl:reset()
	self.jackpotsData = {}
	self.preJackpotData = {}
	self.jackpotNotificationQueue = BoleQueueStack.new()
	self.selfNotificationQueue = BoleQueueStack.new()
	self.updateTime = 0


    -- self.jpNotificationDialog = nil
    -- self.notificationStayTime = nil
    -- self.preScheduleID = nil
    -- self.ui = nil
end

-- 单例
function JackpotControl:getInstance (...)
	if not self._instance then
		self._instance = JackpotControl.new()
	end
	return self._instance
end


-------------------------------------数据处理-------------------------------
-- 从服务器请求jackpot数据
-- theme_id = -1，请求大厅jackpot数据
-- theme_id = XXX，请求主题jackpot数据（包括大厅数据）
function JackpotControl:updateJackpot()
    -- bole.potp:send(JACKPOT_DATA, {theme_id = LobbyThemeControl:getInstance().currentThemeId})
end

-- 注册通信事件
function JackpotControl:initPotpCmd ()
	local function callback (cmd, data)
		if cmd == JACKPOT_WIN_INFO then
			--self:setCoins(data.idx, data.jackpot_init_pool)
			if 1 == cc.UserDefault:getInstance():getIntegerForKey("announcement", 1) and self.ui.receiveWinner then
				self.ui:receiveWinner(data.idx, data.winner)
			end
		elseif cmd == JACKPOT_DATA then
			self:setJackpot(data)
		-- elseif cmd == KEEP_ALIVE then
		-- 	local themeId = LobbyThemeControl:getInstance().currentThemeId
		-- 	if themeId ~= -1 and data.refresh_jackpot then
		-- 		-- 如果有中奖，提前请求jackpot数据
		-- 		self:updateJackpot()
		-- 	end
		end
	end
	bole.potp:registerCmd(JACKPOT_WIN_INFO, callback)
	bole.potp:registerCmd(JACKPOT_DATA, callback)
end

function JackpotControl:onKeepAlive (data)
	local themeId = LobbyThemeControl:getInstance().currentThemeId
	if themeId ~= -1 and data.refresh_jackpot then
		-- 如果有中奖，提前请求jackpot数据
		self:updateJackpot()
	elseif data.broadcast_jackpot then
        if not SettingControl:getInstance():canNotifyJackPort() then
            return
        end
		-- 处理broadcast
		local function getFacebookInfo(data)
			if data then
                local broadcast_data = {}
				broadcast_data.themeid  = data.tid
				broadcast_data.wincoins = data.credits
                broadcast_data.name     = data.facebook_name
                broadcast_data.picture  = Facebook:getInstance():getFbIconPic(nil, nil, data.facebook)
				-- local user_info = Facebook:getInstance():getUserById(data.facebook)
				-- if user_info then
				-- 	broadcast_data.name     = user_info.name
				-- 	broadcast_data.picture  = user_info.picture -- 通过ID获得pic
				if data.is_self then
					self.selfNotificationQueue:enQueue(broadcast_data)
				else
                    local function complete_func( ... )
                        JackpotControl:getInstance().jackpotNotificationQueue:enQueue(broadcast_data)
                    end
                    DownloadController:getInstance():downloadSingleFile(broadcast_data.picture, complete_func)
				end
			end
		end

		for _, broadcast_item in pairs(data.broadcast_jackpot) do
			if broadcast_item.facebook then
				-- Facebook:getInstance():getUserById(broadcast_item.facebook)

				TimerCallFunc:getInstance():addCallFunc(getFacebookInfo, 10, broadcast_item)

			else
				--  匿名玩家中奖
				local broadcast_data    = {}
				broadcast_data.name     = "A Player"
				broadcast_data.themeid  = broadcast_item.tid
				broadcast_data.wincoins = broadcast_item.credits
				broadcast_data.icon_id  = broadcast_item.icon_id

				if broadcast_item.is_self then
					self.selfNotificationQueue:enQueue(broadcast_data)
				else
					self.jackpotNotificationQueue:enQueue(broadcast_data)
				end
			end
		end
	end

	self:showJackpotNotification()
end

-- 间隔30s向服务器请求数据
function JackpotControl:requestJackpot ()
	if self.preScheduleID then
		cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.preScheduleID)
		self.preScheduleID = nil
	end
    self.preScheduleID = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function ()
    		self:updateJackpot()
    	end, jackpot_sync_duration, false)
end

-- 间隔30s向服务器请求数据
function JackpotControl:stopJackpotRequest ()
    if self.preScheduleID then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.preScheduleID)
        self.preScheduleID = nil
    end
end

-- 进入主题和返回主题时重置之前的数据
function JackpotControl:resetPreJackpotData()
	self.preJackpotData = {}
end

-- 更新本地jackpot数据并每隔30秒在获取一次
function JackpotControl:setJackpot(data)
	-- 收到数据后，隔30s请求一次
	-- self:requestJackpot()
    self:setJackpotData(data)
end

-- 更新本地jackpot数据
function JackpotControl:setJackpotData(data)
    -- 更新本地jackpot数据
    self.jackpotsData = self.jackpotsData or {}
    self.originalData = self.originalData or {}
    -- self.preJackpotData = table.copy(self.jackpotsData)
    for themeId, themeData in pairs(data) do
        if type(themeId) == "string" then
            themeId = tonumber(themeId)
        end
        self.originalData[themeId] = themeData
        self.jackpotsData[themeId] = self.jackpotsData[themeId] or {}
        -- 确保themeid是数值型
        -- print("zhf setJackpotData ",themeId,tool.lua_to_json(themeData))
        for level, leveData in pairs(themeData) do
            self.jackpotsData[themeId][level] = self.jackpotsData[themeId][level] or {}
            -- print("zhf leveData ",themeId,level,tool.lua_to_json(leveData))
            for _, mulData in pairs(leveData) do
                -- print("zhf mulData ",themeId,tool.lua_to_json(mulData))
                self.jackpotsData[themeId][level][mulData[1]] = self.jackpotsData[themeId][level][mulData[1]] or {}
                self.jackpotsData[themeId][level][mulData[1]].mul = mulData[1]
                self.jackpotsData[themeId][level][mulData[1]].aimIncrement = mulData[2]
                self.jackpotsData[themeId][level][mulData[1]].isUpdated = true
            end
        end
    end
    -- print("zhf: setJackpotData jpData", tool.lua_to_json(self.jackpotsData))
    -- self.updateTime = os.time()
end

-- 获取本地jackpot reset数据
function JackpotControl:getResetValue(themeId, level, betMul)
	return betMul*self:getBaseResetValue(themeId,level)
end

-- 获取本地jackpot reset数据
function JackpotControl:getBaseResetValue(themeId, level)
    if theme_jackpot_reset_config and theme_jackpot_reset_config[themeId] and JACKPOT_RESET_DATA[theme_jackpot_reset_config[themeId]] then
        local resetValue = JACKPOT_RESET_DATA[theme_jackpot_reset_config[themeId]][level]
        if resetValue then
            if THEME_LIST[themeId] then
                return THEME_LIST[themeId]["basebet"]*resetValue
            else
                return resetValue
            end
        end
    end
    return 0
end

-- 获取本地jackpot reset数据
function JackpotControl:getIncreaseRate(themeId, level, inTheme)
    if themeId == 999 then
        local rate = JP_INCREASE_BONUS_INFINITY
        local userLevel = User:getInstance().level or 100
        for _,mul in pairs(JP_INCREASE_RATE_BONUS_MUTILIST) do
            if userLevel <= mul then
                rate = JP_INCREASE_RATE_BONUS[level][mul]
                break
            end
        end
        return rate/16
    else
        local jpMuti = JACKPOT_RESET_DATA[theme_jackpot_reset_config[themeId]][level]
        local rate = JP_INCREASE_THEME_INFINITY
        for index,mul in ipairs(JP_INCREASE_RATE_THEME_MUTILIST) do
            if jpMuti <= mul then
                if inTheme then
                    rate = JP_INCREASE_RATE_THEME_INTHEME[mul]
                else
                    rate = JP_INCREASE_RATE_THEME_LOBBY[mul]
                end
                break
            end
        end
        return rate/16
    end
end

-- 获取本地jackpot数据  betMul 当前 bet 的倍数 ， jpMul当前 bet 对应的 jp increment的级别
function JackpotControl:getJackportData(themeId, level , betMul, jpMul)
    local jpData = self.jackpotsData
    if jpData and jpData[themeId] and jpData[themeId][level] then
        local tempData = jpData[themeId][level]
        local resultData = tempData[jpMul]
        -- if not resultData.resetValue then
        --     resultData.resetValue = self:getResetValue(themeId, level, betMul)
        -- end
        resultData.resetValue = self:getResetValue(themeId, level, betMul)
        if not resultData.increment then
            if resultData.aimIncrement then
                resultData.increment = resultData.aimIncrement
                resultData.aimIncrement = nil
            else
                resultData.increment = self:getSimulatedIncrementValue(resultData.resetValue)
            end
        end
        -- print("zhf getJackportData ",themeId,level,betMul,jpMul,tool.lua_to_json(resultData)
        return resultData
    end
    return nil
end

-- 客户端随机模拟一个jackpot increment zhf
function JackpotControl:getSimulatedIncrementValue(resetValue)
    local increment = math.floor(math.random()*resetValue*1.1111111111111111111)
    return increment
end

-- 解析increment 对应的Multiplier
function JackpotControl:getJackpotMultiplier(themeId, level, betMul)
	local jpMul
    -- libDebug.printTable("zhf getJackpotMultiplier ",self.originalData)
	if betMul == nil then
		local jpData = self.originalData
		if jpData and jpData[themeId] and jpData[themeId][level] then

			local incrementData = jpData[themeId][level]
			jpMul = tonumber(incrementData[#incrementData][1])
            -- print("zhf getJackpotMultiplier 1 ",themeId, level,jpMul,tool.lua_to_json(incrementData))
		end
	else
		local jpData = self.originalData
		if jpData and jpData[themeId] and jpData[themeId][level] then

			local incrementData = jpData[themeId][level]
			for i=1, #incrementData do
				local mul = tonumber(incrementData[i][1])
				if betMul <= mul then
					jpMul = mul
					break
				end
			end
            if not jpMul then
                jpMul = incrementData[#incrementData][1]
            end
            -- print("zhf getJackpotMultiplier 2 ",themeId, level,betMul,jpMul,tool.lua_to_json(incrementData))
		end
	end

	return (jpMul or 1)
end

-------------------------------------UI显示------------------------------

function JackpotControl:configJackpotUI (themeId, level, betMul, ui, allowK, inTheme,lobbyCall)
	-- 初始化jackpot label
	inherit(ui, JackpotUpdateClass)
	ui:initial(allowK)

	ui.ctl    = self
	-- 记录bet
    local jpMul = self:getJackpotMultiplier(themeId, level, betMul)
	ui.betMul = betMul or jpMul
    ui.jpMul = jpMul
	ui.lock   = false
	ui.mul    = 1
    local resetValue = self:getResetValue(themeId, level, ui.betMul)

    -- local increment = self:getIncrementValue(themeId, level, betMul,resetValue)
    local jpData = self:getJackportData(themeId, level,ui.betMul,ui.jpMul)
    if not jpData then
        print("zhf jackpot did not config ", themeId)
        return
    end
    local rate = self:getIncreaseRate(themeId, level, inTheme)
    jpData.increaseRate = resetValue*rate

	-- 用与更新滚动jackpot label
	local startRoll = function ()
		-- local startValue = resetValue*ui.mul + increment
		-- local endValue = self:getJackpotValue(themeId, level, ui.betMul, ui.mul)

        if inTheme then
            ui:startRoll(jpData)
        else
            ui:startRoll(jpData)
        end
	end

	-- local updateRollData = function ()
	-- 	local startValue = self:getStartValue(themeId, level, ui.betMul, ui.mul)
	-- 	-- local endValue = self:getJackpotValue(themeId, level, ui.betMul, ui.mul)
	-- 	ui:updateRollData(startValue)
	-- end

	-- 停止RollAction
	local stopRollAction = function ()
		-- ui:stopActionByTag(action_tag_jp_roll)
	end

	-- 每隔30s roll一次
	local startRollAction = function ()
  --       local cAction = ui:getActionByTag(action_tag_jp_roll)
		-- -- stopRollAction()
  --       if cAction then
  --           updateRollData()
  --           updateJackpotScale()
  --           return
  --       end
	 --    local action = cc.RepeatForever:create(cc.Sequence:create(
	 --    		cc.CallFunc:create(function ()
	 --    			updateRollData()
	 --    			updateJackpotScale()
		-- 		end),
	 --    		cc.DelayTime:create(jackpot_sync_duration)))

	 --    action:setTag(action_tag_jp_roll)
	 --    ui:runAction(action)
	end

	-- 启动，每隔30s更新一次
	startRoll()

    -- if inTheme then
    --     startRollAction()
    -- else
    --     updateJackpotScale()
    -- end

	-- 在游戏中设置mul
	function ui:updateMul(newMul)
		if newMul ~= ui.mul then
			-- 更新bet
			ui.mul = newMul
            local jpMul = ui.ctl:getJackpotMultiplier(themeId, level, ui.mul*ui.betMul)
            ui.jpMul = jpMul
            local jpData = ui.ctl:getJackportData(themeId, level, ui.mul*ui.betMul, ui.jpMul)
            if not jpData then
                print("zhf jackpot did not config ", themeId)
                return
            end
            local rate = ui.ctl:getIncreaseRate(themeId, level, inTheme)
            jpData.increaseRate = jpData.resetValue*rate
            -- jpData.isUpdated = true
            ui:updateRollData(jpData,true)
		end
	end

    -- zhf 更新jackport数据，暂时用于大厅选 Bet 界面高级房普通房通过按钮切换,直接切换jackport值问题。
    function ui:resetJPByThemeId(newThemeId)
        if newThemeId then
            -- 更新bet
            local jpMul = ui.ctl:getJackpotMultiplier(newThemeId, level, nil)
            ui.betMul = jpMul
            ui.jpMul = jpMul
            local jpData = ui.ctl:getJackportData(newThemeId, level, ui.betMul, ui.jpMul)
            if not jpData then
                print("zhf jackpot did not config ", newThemeId)
                return
            end
            local rate = ui.ctl:getIncreaseRate(newThemeId, level, false)
            jpData.increaseRate = jpData.resetValue*rate
            -- jpData.isUpdated = true
            ui:updateRollData(jpData,true)
        end
    end

	if inTheme then

		-- 需要锁住jackpot
		function ui:lockJackpotMeter(lock)
			if ui.lock == lock then return end
			ui.lock = lock

			if ui.lock then
				-- 停止30s更新action
				-- stopRollAction()
				-- 停止滚动
				ui:pauseRoll()
			else
				-- 启动，每隔30s更新一次
				ui:resumeRoll()
				-- startRollAction()
			end
		end

		-- 在主题中切换bet
		function ui:updateBet(newBetMul,callback)
			if newBetMul ~= ui.betMul then
				-- 更新bet
				ui.betMul = newBetMul
                local jpMul = ui.ctl:getJackpotMultiplier(themeId, level, ui.betMul)
                ui.jpMul = jpMul
                local jpData = ui.ctl:getJackportData(themeId, level, ui.betMul, ui.jpMul)
                if not jpData then
                    print("zhf jackpot did not config ", themeId)
                    return
                end
                local rate = ui.ctl:getIncreaseRate(themeId, level, inTheme)
                jpData.increaseRate = jpData.resetValue*rate
                -- jpData.isUpdated = true
                ui:updateRollData(jpData,true)
			end

		end
	end
end

function JackpotControl:configBlazingChallengeJackpotUI (themeId, level, betMul, ui, allowK)
    -- 初始化jackpot label
    inherit(ui, JackpotUpdateClass)

    ui:initial(allowK)

    ui.ctl    = self
    -- 记录bet
    -- ui.betMul = betMul
    -- ui.lock   = false
    -- ui.mul    = 1


    local jpMul = self:getJackpotMultiplier(themeId, level, betMul)
    ui.betMul = betMul or jpMul
    ui.jpMul = jpMul
    ui.lock   = false
    ui.mul    = 1
    local resetValue = self:getResetValue(themeId, level, ui.betMul)
    local jpData = self:getJackportData(themeId, level,ui.betMul,ui.jpMul)
    jpData.increaseRate = resetValue*self:getIncreaseRate(themeId, level,false)


    -- local startValue = self:getResetValue(themeId, level, ui.betMul, ui.mul)
    -- ui:startRoll(startValue * 0.95, startValue, jackpot_sync_duration * 10)
    ui:startRoll(jpData)
end

-----------------------------------Jackpot Notification---------------------
function JackpotControl:showJackpotNotification()

	if not PopupController:getInstance():isAllowPopup() then return end

	self.notificationStayTime = self.notificationStayTime or 0
	if self.jpNotificationDialog then
		self.notificationStayTime = self.notificationStayTime + 1
		if self.notificationStayTime == 5 then
			self.jpNotificationDialog = nil
		end
		return
	end

	self.notificationStayTime = 0
	if self.jackpotNotificationQueue and not self.jackpotNotificationQueue:isEmpty() then
        
		if DownloadController:getInstance():needDownload(2, "jackpot_notification") then 
            return 
        end

		local data = self.jackpotNotificationQueue:deQueue()
		if data then
			local function callback( ... )
				self.jpNotificationDialog = nil
			end

            if data.themeid and THEME_LIST[data.themeid] then
                if not DownloadController:getInstance():needDownload(2, "jackpot_notification") then
                    local Header_Theme_Jackpot_Tip = require "Systems/HeaderFooter/Header_Theme_Jackpot_Tip"
                    self.jpNotificationDialog = Header_Theme_Jackpot_Tip.new(data)
                    if self.jpNotificationDialog then self.jpNotificationDialog:show() end
                end
            end
		end
	end
end

function JackpotControl:showSelfJackpotNotification()
	if not self.selfNotificationQueue:isEmpty() then
		local broadcast_data = self.selfNotificationQueue:deQueue()
		self.jackpotNotificationQueue:enQueue(broadcast_data)
	end
end

function JackpotControl:clearJackpotNotification()
    self.selfNotificationQueue:clear()
    self.jackpotNotificationQueue:clear()
end


function JackpotControl:getJackpotMulti(themeid,level)
    if theme_jackpot_reset_config and theme_jackpot_reset_config[themeid] and JACKPOT_RESET_DATA[theme_jackpot_reset_config[themeid]] then
        local resetValue = JACKPOT_RESET_DATA[theme_jackpot_reset_config[themeid]][level]
        return resetValue
    end
    return 0
end
