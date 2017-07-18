--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:a22d59f81282095e4a39f718f0421922:cf23b83ce32a51850789d7e0c8e070f0:ab52e9980b5a0fa33f71f4820e991d6a$
--
-- local sheetInfo = require("mysheet")
-- local myImageSheet = graphics.newImageSheet( "mysheet.png", sheetInfo:getSheet() )
-- local sprite = display.newSprite( myImageSheet , {frames={sheetInfo:getFrameIndex("sprite")}} )
--

local SheetInfo = {}

SheetInfo.sheet =
{
    frames = {
    
        {
            -- enemyBlue4
            x=102,
            y=251,
            width=82,
            height=84,

        },
        {
            -- enemyRed1
            x=99,
            y=165,
            width=93,
            height=84,

        },
        {
            -- joystickFireA
            x=163,
            y=1,
            width=80,
            height=80,

        },
        {
            -- joystickFireB
            x=163,
            y=83,
            width=80,
            height=80,

        },
        {
            -- joystickMain
            x=1,
            y=1,
            width=160,
            height=160,

        },
        {
            -- joystickThumb
            x=1,
            y=163,
            width=96,
            height=97,

        },
        {
            -- laserBlue01
            x=194,
            y=165,
            width=9,
            height=54,

        },
        {
            -- laserGreen11
            x=205,
            y=165,
            width=9,
            height=54,

        },
        {
            -- laserRed01
            x=216,
            y=165,
            width=9,
            height=54,

        },
        {
            -- playerShip1_blue
            x=1,
            y=262,
            width=99,
            height=75,

        },
    },
    
    sheetContentWidth = 244,
    sheetContentHeight = 338
}

SheetInfo.frameIndex =
{

    ["enemyBlue4"] = 1,
    ["enemyRed1"] = 2,
    ["joystickFireA"] = 3,
    ["joystickFireB"] = 4,
    ["joystickMain"] = 5,
    ["joystickThumb"] = 6,
    ["laserBlue01"] = 7,
    ["laserGreen11"] = 8,
    ["laserRed01"] = 9,
    ["playerShip1_blue"] = 10,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
