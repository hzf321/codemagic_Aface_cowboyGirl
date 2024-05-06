local EaseNormal = require("UI/CreatorUI/EaseNormal")

local QuadBez = {}
function QuadBez:Interp( --[[Vector3]] st, --[[Vector3]] en, --[[Vector3]] ctrl, --[[float]] t)
    local d = 1 - t;
    return d * d * st + 2 * d * t * ctrl + t * t * en;
end

local CubicBez = {}
function CubicBez:Interp( --[[Vector3]] st, --[[Vector3]] en, --[[Vector3]] ctrl1, --[[Vector3]] ctrl2, --[[float]] t)
    local d = 1 - t;
    return d * d * d * st + 3 * d * d * t * ctrl1 + 3 * d * t * t * ctrl2 + t * t * t * en;
end

local CRSpline = {}
function CRSpline:Interp( --[[Vector3 tabl]] pts, --[[float]] t)
    local numSections = #pts - 3;
    local currPt = math.min(math.floor(t * numSections), numSections - 1);
    local u = t * numSections - currPt;

    local a = pts[currPt];
    local b = pts[currPt + 1];
    local c = pts[currPt + 2];
    local d = pts[currPt + 3];
    return .5 * ((-a + 3 * b - 3 * c + d) * (u * u * u) + (2 * a - 5 * b + 4 * c - d) * (u * u) + (-a + c) * u + 2 * b)
end

-- reference code, cocos bezier.js
local function bezier(C1, C2, C3, C4, t)
    local t1 = 1 - t;
    return C1 * t1 * t1 * t1 + C2 * 3 * t1 * t1 * t + C3 * 3 * t1 * t * t + C4 * t * t * t;
end
local Math = math

local cos = Math.cos
local acos = Math.acos
local max = Math.max
local pi = Math.pi
local tau = 2 * pi
local sqrt = Math.sqrt

local function crt(v)
    if v < 0 then
        return -Math.pow(-v, 1 / 3)
    else
        return Math.pow(v, 1 / 3)
    end
end

local function cardano(curve, x)
    local pa = x - 0;
    local pb = x - curve[1];
    local pc = x - curve[3];
    local pd = x - 1;

    -- to [t^3 + at^2 + bt + c] form:
    local pa3 = pa * 3;
    local pb3 = pb * 3;
    local pc3 = pc * 3;
    local d = (-pa + pb3 - pc3 + pd)
    local rd = 1 / d
    local r3 = 1 / 3
    local a = (pa3 - 6 * pb + pc3) * rd
    local a3 = a * r3
    local b = (-pa3 + pb3) * rd
    local c = pa * rd
    -- then, determine p and q:
    local p = (3 * b - a * a) * r3
    local p3 = p * r3
    local q = (2 * a * a * a - 9 * a * b + 27 * c) / 27
    local q2 = q / 2
    -- and determine the discriminant:
    local discriminant = q2 * q2 + p3 * p3 * p3
    -- and some reserved variables
    local u1, v1, x1, x2, x3;

    -- If the discriminant is negative, use polar coordinates
    -- to get around square roots of negative numbers
    if (discriminant < 0) then
        local mp3 = -p * r3
        local mp33 = mp3 * mp3 * mp3
        local r = sqrt(mp33)
        -- compute cosphi corrected for IEEE float rounding:
        local t = -q / (2 * r)
        local cosphi = t < -1 and -1 or (t > 1 and 1 or t)
        local phi = acos(cosphi)
        local crtr = crt(r)
        local t1 = 2 * crtr

        x1 = t1 * cos(phi * r3) - a3;
        x2 = t1 * cos((phi + tau) * r3) - a3;
        x3 = t1 * cos((phi + 2 * tau) * r3) - a3;

        -- choose best percentage
        if (0 <= x1 and x1 <= 1) then
            if (0 <= x2 and x2 <= 1) then
                if (0 <= x3 and x3 <= 1) then
                    return max(x1, x2, x3);
                else
                    return max(x1, x2);
                end
            elseif (0 <= x3 and x3 <= 1) then
                return max(x1, x3);
            else
                return x1;
            end
        else
            if (0 <= x2 and x2 <= 1) then
                if (0 <= x3 and x3 <= 1) then
                    return max(x2, x3);
                else
                    return x2;
                end
            else
                return x3;
            end
        end
    elseif (discriminant == 0) then
        u1 = q2 < 0 and crt(-q2) or -crt(q2);
        x1 = 2 * u1 - a3;
        x2 = -u1 - a3;

        -- choose best percentage
        if (0 <= x1 and x1 <= 1) then
            if (0 <= x2 and x2 <= 1) then
                return max(x1, x2);
            else
                return x1;
            end
        else
            return x2;
        end
        -- one real root, and two imaginary roots
    else
        local sd = sqrt(discriminant);
        u1 = crt(-q2 + sd);
        v1 = crt(q2 + sd);
        x1 = u1 - v1 - a3;

        return x1;
    end
end

local function bezierByTime(controlPoints, x)
    local percent = cardano(controlPoints, x); -- t
    local p0y = 0; -- a
    local p1y = controlPoints[2]; -- b
    local p2y = controlPoints[4]; -- c
    local p3y = 1; -- d
    local t1 = 1 - percent;

    return
        p0y * t1 * t1 * t1 + p1y * 3 * percent * t1 * t1 + p2y * 3 * percent * percent * t1 + p3y * percent * percent *
            percent;
end

function CubicBez.Interp_(t, b, c, d, ctrl1, ctrl2)
    local t = t / d
    local z = 1 - t;

    return z * z * z * b + 3 * z * z * t * ctrl1 + 3 * z * t * t * ctrl2 + t * t * t * (b + c);
end

-- t = elapsed time
-- b = begin
-- c = change == ending - beginning
-- d = duration (total time)
local function __constant(t, b, c, d)
    return b
end

local curvFunc = {

    linear = EaseNormal.linear,
    constant = __constant,
    cubicBez = CubicBez.Interp_,
    -- 
    quadIn = EaseNormal.inQuad,
    quadOut = EaseNormal.outQuad,
    quadInOut = EaseNormal.inOutQuad,
    quadOutIn = EaseNormal.outInQuad,

    cubicIn = EaseNormal.inCubic,
    cubicOut = EaseNormal.outCubic,
    cubicInOut = EaseNormal.inOutCubic,
    cubicOutIn = EaseNormal.outInCubic,

    quartIn = EaseNormal.inQuart,
    quartOut = EaseNormal.outQuart,
    quartInOut = EaseNormal.inOutQuart,
    quartOutIn = EaseNormal.outInQuart,

    quintIn = EaseNormal.inQuint,
    quintOut = EaseNormal.outQuint,
    quintInOut = EaseNormal.inOutQuint,
    quintOutIn = EaseNormal.outInQuint,

    sineIn = EaseNormal.inSine,
    sineOut = EaseNormal.outSine,
    sineInOut = EaseNormal.inOutSine,
    sineOutIn = EaseNormal.outInSine,

    expoIn = EaseNormal.inExpo,
    expoOut = EaseNormal.outExpo,
    expoInOut = EaseNormal.inOutExpo,
    expoOutIn = EaseNormal.outInExpo,

    circIn = EaseNormal.inCirc,
    circOut = EaseNormal.outCirc,
    circInOut = EaseNormal.inOutCirc,
    circOutIn = EaseNormal.outInCirc,

    elasticIn = EaseNormal.inElastic,
    elasticOut = EaseNormal.outElastic,
    elasticInOut = EaseNormal.inOutElastic,
    elasticOutIn = EaseNormal.outInElastic,

    backIn = EaseNormal.inBack,
    backOut = EaseNormal.outBack,
    backInOut = EaseNormal.inOutBack,
    backOutIn = EaseNormal.outInBack,

    bounceIn = EaseNormal.inBounce,
    bounceOut = EaseNormal.outBounce,
    bounceInOut = EaseNormal.inOutBounce,
    bounceOutIn = EaseNormal.outInBounce
}

local AnimeEase = {}
function AnimeEase:create()
end

function AnimeEase:interp(curveData, v1, v2, total, segElapse)

    curveData = curveData or "linear"

    local t = type(curveData)
    if t == "string" then
        local func = curvFunc[curveData]
        if func then
            return func(segElapse, v1, v2 - v1, total)
        else
            -- dump( curveData )
            print("not supported curve")
            return 0
        end

    elseif t == "table" then
        -- curvFunc.cubicBez( segElapse, v1, v2-v1, total )
        local v = bezierByTime(curveData, segElapse / total)
        return v1 + (v2 - v1) * v
    end
end
return AnimeEase
