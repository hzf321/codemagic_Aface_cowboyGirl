ShaderUtil={}
local class=ShaderUtil
local greyvsh=
[[attribute vec4 a_position;
attribute vec2 a_texCoord;
attribute vec4 a_color;

#ifdef GL_ES
varying lowp vec4 v_fragmentColor;
varying mediump vec2 v_texCoord;
#else
varying vec4 v_fragmentColor;
varying vec2 v_texCoord;
#endif

void main()
{
    gl_Position = CC_PMatrix * a_position;
    v_fragmentColor = a_color;
    v_texCoord = a_texCoord;
}]]
local greyfsh=
[[
#ifdef GL_ES
precision mediump float;
#endif

varying vec4 v_fragmentColor;
varying vec2 v_texCoord;

void main(void)
{
    vec4 c = texture2D(CC_Texture0, v_texCoord);
    gl_FragColor.xyz = vec3(0.2126*c.r + 0.7152*c.g + 0.0722*c.b);
    gl_FragColor.w = c.w;
}
]]

local darkfsh=
[[
#ifdef GL_ES
precision mediump float;
#endif

varying vec4 v_fragmentColor;
varying vec2 v_texCoord;

void main(void)
{
    vec4 c = texture2D(CC_Texture0, v_texCoord);
    gl_FragColor.xyz = vec3(0.3*c.r, 0.3*c.g, 0.3*c.b);
    gl_FragColor.w = c.w;
}
]]

-- 初始位置直线方程 Ax+By+C=0
-- dx, dy 每秒直线移动位移
-- duration 周期
-- radius 半径
-- shineFactor 亮度增加倍数
local swipefsh=
[[
#ifdef GL_ES
precision mediump float;
#endif

varying vec4 v_fragmentColor;
varying vec2 v_texCoord;

uniform float scene_time;
uniform float opacity;

void main(void)
{
    float A = %f;
    float B = %f;
    float C = %f;
    float dx = %f;
    float dy = %f;
    float radius = %f;
    float shineFactor = %f;

    float time = scene_time;
    // new line formula : A * (x - dx*time) + B * (y - dy*time) + C = 0
    C = -A * dx * time - B * dy * time + C;

    float x = v_texCoord.x;
    float y = v_texCoord.y;
    float dist = abs(A*x + B*y + C) / sqrt(A*A + B*B);

    vec4 c = texture2D(CC_Texture0, v_texCoord);
    float multi = 1.0;
    float extraMulti = 0.0;
    float extra = 0.0;
    float factor = 1.0 - dist / radius;
    if (dist < radius) {
        extraMulti = (shineFactor - 1.0) * factor * factor * factor;
        if (c.w > 0.5)
            extra = extraMulti * 0.2;
        multi = 1.0 + extraMulti;
        gl_FragColor.xyz = vec3(multi*c.r+extra, multi*c.g+extra, multi*c.b+extra);
    } else
        gl_FragColor.xyz = vec3(c.r, c.g, c.b);
        // gl_FragColor.xyz = vec3(1, 1, 1);
    gl_FragColor.w = c.w * opacity;

    // floor() in android shader might cause some problem
}
]]

-- line formula : Ax + By + C = 0
-- scheduleNode 主要针对button，定时对象和texture对象不一致，注意一个问题，如果要换texture，记得重新调用此函数，否则会出错
-- xOy  move along x-axis or y-axis, true means x
-- d_xOy  speed, 1 means 1 run per second
function ShaderUtil:setSwipeShader (sprite, scheduleNode, A, B, C, xOy, d_xOy, duration, radius, shineFactor)
    scheduleNode = scheduleNode or sprite
    A = A or 1
    B = B or 1
    C = C or 0.3
    if nil == xOy then xOy = true end
    d_xOy = d_xOy or 1
    dx = xOy and d_xOy or 0
    dy = xOy and 0 or d_xOy
    -- radius = xOy and radius / sz.width or radius / sz.height
    duration = duration or 5
    radius = radius or 0.18
    shineFactor = shineFactor or 2

    local beginTime = os.time()

    local fsh = string.format(swipefsh, A, B, C, dx, dy, radius, shineFactor)
    sprite:setGLProgramState(ShaderUtil:getShader(fsh, greyvsh))

    -- TODO, what if duplicate
    -- 注意sprite可能不在了
    local function _gameLogic (dt)
        local t = os.time() - beginTime
        t = t % duration
        -- sprite:getGLProgramState():setUniformFloat('scene_time', cnt * 0.01)
        sprite:getGLProgramState():setUniformFloat('scene_time', t)
        -- 兼容fadeIn/Out的动画，注意，用的是scheduleNode的透明度
        sprite:getGLProgramState():setUniformFloat('opacity', scheduleNode:getOpacity() / 256)
        -- local loc = gl.getUniformLocation(sprite:getGLProgram(), 'scene_time')
        -- sprite:getGLProgram():setUniformLocationF32(loc, t)
    end
    scheduleNode:scheduleUpdateWithPriorityLua(_gameLogic, 0)

    sprite:getGLProgramState():setUniformFloat('scene_time', 0)
end


function class:getShader(fragmentString,vertexString)
    local fileUtiles = cc.FileUtils:getInstance()
    local fragSource = fragmentString
    local vertSource = vertexString
    local glProgram = cc.GLProgram:createWithByteArrays(vertSource, fragSource)
    glProgram:link()
    glProgram:updateUniforms()
    local glprogramstate = cc.GLProgramState:getOrCreateWithGLProgram(glProgram)
    glprogramstate:setUniformFloat('scene_time', 0.5)
    return glprogramstate
end

function class:setGreyShader(sprite)
	 sprite:setGLProgramState(self:getShader(greyfsh,greyvsh))
end

function class:setDarkShader(sprite)
     sprite:setGLProgramState(self:getShader(darkfsh,greyvsh))
end

function class:cleanShaderForSprite(sprite)
    sprite:setGLProgramState(cc.GLProgramState:getOrCreateWithGLProgramName("ShaderPositionTextureColor_noMVP"))

end

