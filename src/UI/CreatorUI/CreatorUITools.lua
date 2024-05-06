local BLNode = require("UI/CreatorUI/BLNode")
local BLSprite = require("UI/CreatorUI/BLSprite")
local BLScale9Sprite = require("UI/CreatorUI/BLScale9Sprite")
local BLButton = require("UI/CreatorUI/BLButton")
local BLLabel = require("UI/CreatorUI/BLLabel")
local BLScrollView = require("UI/CreatorUI/BLScrollView")
local BLLayout = require("UI/CreatorUI/BLLayout")

---@class CreatorUITools
CreatorUITools = class("CreatorUITools")
function CreatorUITools:ctor()
    self._instance = nil;
    self.matchTable = {};
    
    self.matchTable["BLSprite"] = {
        create = handler(self, self._createSpriteNode),
        attriRender = handler(self, self._renderNode)
    }

    self.matchTable["BLHSLSprite"] = {
        create = handler(self, self._createHSLSpriteNode),
        attriRender = handler(self, self._renderNode)
    }

    
    self.matchTable["BLScale9Sprite"] = {
        create = handler(self, self._createScale9SpriteNode),
        attriRender = handler(self, self._renderNode)
    }

    self.matchTable["BLNode"] = {
        create = handler(self, self._createNode),
        attriRender = handler(self, self._renderNode)
    }

    self.matchTable["BLButton"] = {
        create = handler(self, self._createButtonNode),
        attriRender = handler(self, self._renderNode)
    }

    self.matchTable["BLSpine"] = {
        create = handler(self, self._createSpineNode),
        attriRender = handler(self, self._renderSpine)
    }

    self.matchTable["BLProgressBar"] = {
        create = handler(self, self._createProgressBarNode),
        attriRender = handler(self, self._renderNode)
    }

    self.matchTable["BLSpriteBar"] = {
        create = handler(self, self.createSpriteBarNode),
        attriRender = handler(self, self._renderNode)
    }

    self.matchTable["BLLabel"] = {
        create = handler(self, self._createLabelNode),
        attriRender = handler(self, self._renderLabelNode)
    }

    self.matchTable["BLRichText"] = {
        create = handler(self, self._createRichTextNode),
        attriRender = handler(self, self._renderLabelNode)
    }

    self.matchTable["BLBMFont"] = {
        create = handler(self, self._createBMFontNode),
        attriRender = handler(self, self._renderLabelNode)
    }

    self.matchTable["BLTTFFont"] = {
        create = handler(self, self._createTTFFontNode),
        attriRender = handler(self, self._renderLabelNode)
    }

    self.matchTable["BLParticle"] = {
        create = handler(self, self._createParticleNodes),
        attriRender = handler(self, self._renderNode)
    }

    self.matchTable["BLClipNode"] = {
        create = handler(self, self._createClipNodes),
        attriRender = handler(self, self._renderNode)
    }

    self.matchTable["BLScrollView"] = {
        create = handler(self, self._createScrollView),
        attriRender = handler(self, self._renderScrollView)
    }

    self.matchTable["BLPageView"] = {
        create = handler(self, self._createPageView),
        attriRender = handler(self, self._renderPageView)
    }

    self.matchTable["BLPanel"] = {
        create = handler(self, self._createPanelNode),
        attriRender = handler(self, self._renderNode)
    }

    self.matchTable["BLSlider"] = {
        create = handler(self, self._createSliderNode),
        attriRender = handler(self, self._renderNode)
    }

    self.matchTable["BLEditBox"] = {
        create = handler(self, self._createEditBox),
        attriRender = handler(self, self._renderEditBox)
    }

    self.matchTable["UI_FILE"] = {
        create = handler(self, self._createUIFile),
        attriRender = handler(self, self._renderNode)
    }
end

---@return CreatorUITools
function CreatorUITools:getInstance()
    if not self._instance then
        self._instance = CreatorUITools.new()
    end
    return self._instance
end

---@return Node @注意返回值是parent
function CreatorUITools:createUi(fileName, parent)
    if fileName and not bole.isCreatorFileExist(fileName) then
        -- 检测luac文件不存在
        if parent == nil then
            parent = BLNode:create()
        end
        return parent
    end
    local uiTable = require(fileName)
    local un = uiTable[1]
    self:addUiFrameCache(uiTable[1].plist)
    if parent == nil then
        parent = BLNode:create()
    end

    for i = 2, #uiTable do
        if uiTable[i].name then
            parent[uiTable[i].name] = self:makeNode(parent, uiTable[i], parent)
        elseif uiTable[i].ui_file_name then
            parent[uiTable[i].ui_file_name] = self:makeNode(parent, uiTable[i], parent)
        else
            self:makeNode(parent, uiTable[i], parent)
        end
    end
    self:_addControllers(parent, parent, uiTable[1], parent)
    parent.uiTbl = uiTable[1]
    return parent
end

-- 为了跟libUI.createCsb层级关系保持一致
---@param parent Node @不能为空
---@return Node @返回值是创建的节点
function CreatorUITools:createUiNode(fileName, parent)
    local node = self:createUi(fileName)
    if parent then
        parent:addChild(node)
    end
    return node
end

function CreatorUITools:createUiByNode(fileName, parent)
    local new_parent = self:createUi(fileName)
    parent:addChild(new_parent)
    return new_parent
end

function CreatorUITools:addUiFrameCache(resList)
    local spriteFrameCache = cc.SpriteFrameCache:getInstance()
    for i = 1, #resList do
        -- print("ok add plist" .. resList[i])
        spriteFrameCache:addSpriteFrames(resList[i]);
    end
end

function CreatorUITools:makeNode(parent, uiTbl, rootNode)
    local config = self.matchTable[uiTbl.type];
    if config then
        local node = config.create(parent, uiTbl, rootNode)
        config.attriRender(node, uiTbl, rootNode)
        if uiTbl.children then
            for i, v in ipairs(uiTbl.children) do
                if v.name then
                    node[v.name] = self:makeNode(node, v, rootNode)
                elseif v.ui_file_name then
                    node[v.ui_file_name] = self:makeNode(node, v, rootNode)
                else
                    self:makeNode(node, v, rootNode)
                end
            end
        end
        local _ = uiTbl.controllerList and self:_addControllers(node, parent, uiTbl, rootNode)
        return node
    end
end

function CreatorUITools:_createScrollView(parent, uiTbl, rootNode)

    local scrollView = BLScrollView:create();
    scrollView:setInnerContainerSize(uiTbl.scrollView.viewSize)
    scrollView:setContentSize(uiTbl.content_size)
    
    parent:addChild(scrollView)
    return scrollView
end

function CreatorUITools:_createPageView(parent, uiTbl, rootNode)
    local pageView = ccui.PageView:create();
    pageView:setDirection(uiTbl.pageView.direction);
    pageView:setContentSize(uiTbl.content_size);
    local page = nil;
    local subTbl = nil;
    if uiTbl.pageView.children then
        for i = 1, #uiTbl.pageView.children do
            subTbl = uiTbl.pageView.children[i]
            page = ccui.Widget:create();
            page:setContentSize(uiTbl.content_size);
            pageView:addPage(page);
            pageView[subTbl.name] = page
            if subTbl.children then
                local pageSubNode = nil
                for sunIndex = 1, #subTbl.children do
                    page[subTbl.children[sunIndex].name] = self:makeNode(page, subTbl.children[sunIndex], rootNode)
                end
            end
        end
    end
    parent:addChild(pageView);
    return pageView
end

function CreatorUITools:_createPanelNode(parent, uiTbl, rootNode)
    local panelTbl = uiTbl.panelNode;
    local panelNode = ccui.Layout:create();
    panelNode:setContentSize(uiTbl.content_size);
    if panelTbl.clipAble then
        panelNode:setClippingEnabled(true)
    else
        panelNode:setClippingEnabled(false)
    end
    if panelTbl.singleColor then
        panelNode:setBackGroundColorType(1);
        panelNode:setBackGroundColor(cc.c3b(panelTbl.singleColor[1], panelTbl.singleColor[2], panelTbl.singleColor[3]))
    end
    if bole.isWinRT() then
        if uiTbl.opacity then
            panelNode:setBackGroundColorOpacity(uiTbl.opacity)
        end
    end
    parent:addChild(panelNode)
    return panelNode;
end

function CreatorUITools:_createSliderNode(parent, uiTbl, rootNode)
    local sliderTbl = uiTbl.slider;
    local sliderNode = nil;
    -- sliderNode:setContentSize(uiTbl.content_size);
    if sliderTbl.bg_texture then
        sliderNode = ccui.Slider:create(sliderTbl.bg_texture, sliderTbl.bg_texture, 0);
        sliderNode:loadSlidBallTextures(sliderTbl.handle_texture, sliderTbl.handle_texture, sliderTbl.handle_texture, 0)
    else
        -- sliderNode:setClippingEnabled(false)
        sliderNode = ccui.Slider:create(sliderTbl.handle_sp, sliderTbl.bg_sp, 1);
    end
    
    if uiTbl.texture_bg then
        sliderNode = ccui.Slider:create(uiTbl.texture_bg, uiTbl.texture_bg, 0);
        sliderNode:loadSlidBallTextures(uiTbl.texture_handle, uiTbl.texture_handle, uiTbl.texture_handle, 0)
    elseif uiTbl.frame_bg then
        sliderNode = ccui.Slider:create(uiTbl.frame_bg, uiTbl.frame_bg, 1);
        sliderNode:loadSlidBallTextures(uiTbl.frame_handle, uiTbl.frame_handle, uiTbl.frame_handle, 1)
    end

    -- if libDebug.checkUISlider(sliderNode) then
    --     libDebug.showErrorTip({
    --         "slider error: creator use plist",
    --         libDebug.getNodePath(sliderNode),
    --     }, false)
    -- end
    

    sliderNode:setContentSize(uiTbl.content_size);
    parent:addChild(sliderNode)
    return sliderNode;
end

function CreatorUITools:_createLayoutView(parent, uiTbl, rootNode)

end

function CreatorUITools:_createClipNodes(parent, uiTbl, rootNode)
    local clipNodeTbl = uiTbl;
    local clipNode = nil;
    if clipNodeTbl.clipType == 2 then
        local clipStencil = cc.Sprite:create()
        if clipNodeTbl.frame then
            local spriteFramePath = clipNodeTbl.frame
            if cc.SpriteFrameCache:getInstance():getSpriteFrame(spriteFramePath) then
                clipStencil:setSpriteFrame(spriteFramePath)
            else
                local res_info = DownloadController:getInstance():getResInfoByResPath(spriteFramePath)
                libDebug.reportClientError(REPORT_CLIENT_ERROR.SPRITE_FRAME, res_info)
            end
        else
            clipStencil:setTexture(clipNodeTbl.texture)
        end
        clipStencil:setContentSize(uiTbl.content_size);
        clipNode = cc.ClippingNode:create(clipStencil)
        if clipNodeTbl.clipNode.alphaThreshold then
            clipNode:setAlphaThreshold(clipNodeTbl.clipNode.alphaThreshold)
        end
        
        clipNode.clipStencil = clipStencil
    
    elseif clipNodeTbl.clipNode.type == 2 then
        local clipStencil = cc.Sprite:create()
        if clipNodeTbl.clipNode.frame then
            local spriteFramePath = clipNodeTbl.clipNode.frame
            if cc.SpriteFrameCache:getInstance():getSpriteFrame(spriteFramePath) then
                clipStencil:setSpriteFrame(spriteFramePath)
            else
                local res_info = DownloadController:getInstance():getResInfoByResPath(spriteFramePath)
                libDebug.reportClientError(REPORT_CLIENT_ERROR.SPRITE_FRAME, res_info)
            end
        else
            clipStencil:setTexture(clipNodeTbl.clipNode.texture)
        end
        clipStencil:setContentSize(uiTbl.content_size);
        clipNode = cc.ClippingNode:create(clipStencil)
        
        clipNode:setAlphaThreshold(clipNodeTbl.clipNode.alphaThreshold)

        if clipNodeTbl.clipNode.inverted then
            clipNode:setInverted(clipNodeTbl.clipNode.inverted)
        end
        clipNode.clipStencil = clipStencil
    else
        clipNode = BLLayout:create();
        clipNode:setClippingEnabled(true)
    end
    clipNode:setContentSize(uiTbl.content_size);
    parent:addChild(clipNode)
    return clipNode
end

function CreatorUITools:_createParticleNodes(parent, uiTbl, rootNode)
    local node = nil;
    local particle = uiTbl.particle
    if cc.FileUtils:getInstance():isFileExist(particle.path) then
        node = cc.ParticleSystemQuad:create(particle.path)
        if particle.texture and particle.texture ~= "" then
            local textureCache = cc.Director:getInstance():getTextureCache()
            local tex = textureCache:addImage(particle.texture)
            node:setTexture(tex)
        end
        node:resetSystem()
    else
        node = cc.Node:create()
    end
    local _ = node.resetSystem and node:resetSystem();
    node:setPosition({
        x = 0,
        y = 0
    })
    parent:addChild(node)
    return node
end

function CreatorUITools:_createSpriteNode(parent, uiTbl, rootNode)
    local sprite = BLSprite:create();
    if uiTbl.frame then
        local spriteFramePath = uiTbl.frame
        if cc.SpriteFrameCache:getInstance():getSpriteFrame(spriteFramePath) then
            sprite:setSpriteFrame(spriteFramePath)
        else
            local res_info = DownloadController:getInstance():getResInfoByResPath(spriteFramePath)
            libDebug.reportClientError(REPORT_CLIENT_ERROR.SPRITE_FRAME, res_info)
        end
    elseif uiTbl.texture and cc.FileUtils:getInstance():isFileExist(uiTbl.texture) then
        sprite:setTexture(uiTbl.texture)
    end
    parent:addChild(sprite)
    return sprite
end

function CreatorUITools:_createHSLSpriteNode( parent, uiTbl, rootNode)
    local sprite = self:_createSpriteNode(parent, uiTbl, rootNode);
    local vertShaderByteArray = [[
        attribute vec4 a_position; 
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
        }
    ]];
    local flagShaderByteArray = [[
        #ifdef GL_ES 
            precision mediump float; 
        #endif 
        varying vec4 v_fragmentColor; 
        varying vec2 v_texCoord; 


        uniform float u_dH; 
        uniform float u_dS; 
        uniform float u_dL; 

        void main(void) 
        { 
            vec4 texColor = texture2D(CC_Texture0, v_texCoord); 
            float r=texColor.r;
            float g=texColor.g;
            float b=texColor.b;
            float a=texColor.a;

            float h;
            float s;
            float l;
            
            float maxN=max(max(r,g),b);
            float minN=min(min(r,g),b);
            //----h
            if(maxN==minN){
                h=0.0;
            }else if(maxN==r&&g>=b){
                h=60.0*(g-b)/(maxN-minN)+0.0;
            }else if(maxN==r&&g<b){
                h=60.0*(g-b)/(maxN-minN)+360.0;
            }else if(maxN==g){
                h=60.0*(b-r)/(maxN-minN)+120.0;
            }else if(maxN==b){
                h=60.0*(r-g)/(maxN-minN)+240.0;
            }
            //----l
            l=0.5*(maxN+minN);
            //----s
            if(l==0.0||maxN==minN){
                s=0.0;
            }else if(0.0<=l&&l<=0.5){
                s=(maxN-minN)/(2.0*l);
            }else if(l>0.5){
                s=(maxN-minN)/(2.0-2.0*l);
            }

            h=h+u_dH;
            s=min(1.0,max(0.0,s+u_dS));
            l=l;//do not use HSL model to adjust lightness, because the effect is not good
            //convert (h,s,l) to rgb and got final color
            vec4 finalColor;
            {
                float q;
                if(l<0.5){
                    q=l*(1.0+s);
                }else if(l>=0.5){
                    q=l+s-l*s;
                }
                float p=2.0*l-q;
                float hk=h/360.0;
                float t[3];
                t[0]=hk+1.0/3.0;t[1]=hk;t[2]=hk-1.0/3.0;
                for(int i=0;i<3;i++){
                    if(t[i]<0.0)t[i]+=1.0;
                    if(t[i]>1.0)t[i]-=1.0;
                }//got t[i]
                float c[3];
                for(int i=0;i<3;i++){
                    if(t[i]<1.0/6.0){
                        c[i]=p+((q-p)*6.0*t[i]);
                    }else if(1.0/6.0<=t[i] && t[i]<0.5){
                        c[i]=q;
                    }else if(0.5<=t[i] && t[i]<2.0/3.0){
                        c[i]=p+((q-p)*6.0*(2.0/3.0-t[i]));
                    }else{
                        c[i]=p;
                    }
                }
                finalColor=vec4(c[0],c[1],c[2],a);
            }
            //actually, it is not final color. the lightness has not been adjusted
            //adjust lightness use the simplest method
            finalColor+=vec4(u_dL,u_dL,u_dL,0.0);
            
            gl_FragColor = finalColor;
        }
    ]]

    local glProgram = cc.GLProgram:createWithByteArrays(vertShaderByteArray, flagShaderByteArray)
    glProgram:link()
    glProgram:updateUniforms()
    local glprogramstate = cc.GLProgramState:getOrCreateWithGLProgram(glProgram)
    glprogramstate:setUniformFloat('u_dH', uiTbl.HSL.H)
    glprogramstate:setUniformFloat('u_dS', uiTbl.HSL.S)
    glprogramstate:setUniformFloat('u_dL', uiTbl.HSL.L)
    sprite:setGLProgramState(glprogramstate)
    return sprite
end

function CreatorUITools:_createScale9SpriteNode(parent, uiTbl, rootNode)
    local sprite = nil

    local rect = uiTbl.cap_insets
    local capInsets = cc.rect(rect.x, rect.y, rect.width, rect.height)

    if capInsets.width == 0 or capInsets.height == 0 then
        if appDebugMode then
            print("capInsets contains zero")
            print(a.b)
        else
            if uiTbl.frame then
                local res_info = DownloadController:getInstance():getResInfoByResPath(uiTbl.frame)
                libDebug.reportClientError(REPORT_CLIENT_ERROR.SPRITE_FRAME, res_info)
            end
        end
    end

    if uiTbl.frame then
        sprite = BLScale9Sprite:create();
        local spriteFrameCache = cc.SpriteFrameCache:getInstance()
        local spriteFrame = spriteFrameCache:getSpriteFrame(uiTbl.frame)
        if spriteFrame then
            sprite:setSpriteFrame(spriteFrame, capInsets) 
        else
            local res_info = DownloadController:getInstance():getResInfoByResPath(uiTbl.frame)
            libDebug.reportClientError(REPORT_CLIENT_ERROR.SPRITE_FRAME, res_info)
        end
    elseif uiTbl.texture and cc.FileUtils:getInstance():isFileExist(uiTbl.texture) then
        sprite = BLScale9Sprite:create(uiTbl.texture,cc.rect(0,0,0,0),capInsets)
    else
        sprite = BLScale9Sprite:create()
    end
    parent:addChild(sprite)
    return sprite
end

function CreatorUITools:_createNode(parent, uiTbl, rootNode)
    local node = BLNode:create()
    parent:addChild(node)

    return node
end

function CreatorUITools:_addControllers(currNode, parent, uiTbl, rootNode)
    local controllerList = uiTbl.controllerList
    if controllerList and #controllerList > 0 and currNode.addController then
        for _, ctrlInfo in ipairs(controllerList) do
            currNode:addController(ctrlInfo, rootNode)
        end
    end

    if currNode.onAfterControllerAdded then
        currNode:onAfterControllerAdded()
    end

end

function CreatorUITools:_createLabelNode(parent, uiTbl, rootNode)
    local label = BLLabel:create(0, uiTbl.text, "Arial", uiTbl.font_size)
    parent:addChild(label)
    return label
end

function CreatorUITools:_createRichTextNode(parent, uiTbl, rootNode)
    local richText = ccui.RichText:create()
    local richTextTbl = uiTbl.richText
    richText:initWithXML(richTextTbl.text, {
        KEY_FONT_SIZE = richTextTbl.fontSize,
        KEY_FONT_COLOR_STRING = richTextTbl.color,
        KEY_VERTICAL_SPACE = richTextTbl.lineHeight,
        KEY_FONT_FACE = richTextTbl.fontNname
    });
    parent:addChild(richText)
    return richText
end

function CreatorUITools:_createBMFontNode(parent, uiTbl, rootNode)
    local fontNode = BLLabel:create(1, uiTbl.font_name, uiTbl.text);
    fontNode:setBMFontSize(uiTbl.font_size)
    parent:addChild(fontNode)
    return fontNode
end

function CreatorUITools:_createTTFFontNode(parent, uiTbl, rootNode)
    if not cc.FileUtils:getInstance():isFileExist(uiTbl.font_name) then
        uiTbl.font_name = "commonfonts/inbox_main.TTF"
    end
    -- cc.Label:createWithTTF(txt, fname, size)
    local fontNode = BLLabel:create(2, uiTbl.text, uiTbl.font_name, uiTbl.font_size)
    if uiTbl.stroke_color then
        fontNode:enableOutline(cc.c4b(uiTbl.stroke_color[1], uiTbl.stroke_color[2], uiTbl.stroke_color[3],
            uiTbl.stroke_color[4]), uiTbl.stroke_size)
    end
    if uiTbl.shadow_color then
        local c = uiTbl.shadow_color
        local p = uiTbl.shadow_offset
        fontNode:enableShadow(cc.c4b(c[1], c[2], c[3],c[4]), cc.size(p.x, p.y), uiTbl.shadow_blur)
        -- print("ok in enableShadow")
    end
    
    parent:addChild(fontNode)
    return fontNode
end

function CreatorUITools:_createButtonNode(parent, uiTbl, rootNode)
    local node = BLButton:create();
    if uiTbl.frame_normal then
        node:loadTextures(uiTbl.frame_normal, uiTbl.frame_down, uiTbl.frame_disable, ccui.TextureResType.plistType)
    elseif uiTbl.texture_normal then
        node:loadTextures(uiTbl.texture_normal, uiTbl.texture_down, uiTbl.texture_disable, ccui.TextureResType.localType)
    end
    if uiTbl.cap_insets ~= nil then
        node:setScale9Enabled(true)
        local rect = uiTbl.cap_insets
        local capInsets = cc.rect(rect.x, rect.y, rect.width, rect.height)
        node:setCapInsetsNormalRenderer(capInsets)
        node:setCapInsetsPressedRenderer(capInsets)
        node:setCapInsetsDisabledRenderer(capInsets)
    end
    parent:addChild(node)
    return node
end

function CreatorUITools:_createProgressBarNode(parent, uiTbl, rootNode)
    local progress_bar_sp = nil
    local progressBar = uiTbl.progressBar
    if uiTbl.cap_insets ~= nil then
        local rect = uiTbl.cap_insets
        local capInsets = cc.rect(rect.x, rect.y, rect.width, rect.height)

        if progressBar.frame then
            progress_bar_sp = cc.Scale9Sprite:createWithSpriteFrameName(progressBar.frame, capInsets)
        elseif progressBar.texture and cc.FileUtils:getInstance():isFileExist(progressBar.texture) then
            progress_bar_sp = cc.Scale9Sprite:create(capInsets, progressBar.texture)
        else
            progress_bar_sp = cc.Sprite:create()
        end
        progress_bar_sp:setScale9Enabled(true)
        progress_bar_sp:setContentSize(uiTbl.content_size)
    else
        progress_bar_sp = cc.Sprite:create()
        if progressBar.frame then
            local spriteFramePath = progressBar.frame
            if cc.SpriteFrameCache:getInstance():getSpriteFrame(spriteFramePath) then
                progress_bar_sp:setSpriteFrame(spriteFramePath)
            else
                local res_info = DownloadController:getInstance():getResInfoByResPath(spriteFramePath)
                libDebug.reportClientError(REPORT_CLIENT_ERROR.SPRITE_FRAME, res_info)
            end
        elseif progressBar.texture then
            progress_bar_sp:setTexture(progressBar.texture)
        end
       
    end

    local node = cc.ProgressTimer:create(progress_bar_sp)
    node:setType(cc.PROGRESS_TIMER_TYPE_BAR)
    node:setMidpoint(cc.p(0,0))
    node:setBarChangeRate(cc.p(1,0))
    node:setPercentage(progressBar.percentage)
    node.progress_bar_sp = progress_bar_sp
    parent:addChild(node)
    return node
end

function CreatorUITools:createSpriteBarNode(parent, uiTbl, rootNode)
    local progress_bar_sp = nil
    local isScale9 = false
    local clipStencil 
    local content_size = uiTbl.content_size
    if content_size then
        uiTbl.copy_content_size = content_size
    elseif  uiTbl.copy_content_size then 
        content_size =  uiTbl.copy_content_size
    end
   
    if uiTbl.cap_insets ~= nil then
        local rect = uiTbl.cap_insets
        clipStencil =cc.Node:create()
        local capInsets = cc.rect(rect.x, rect.y, rect.width, rect.height)

        if uiTbl.frame then
            progress_bar_sp = cc.Scale9Sprite:createWithSpriteFrameName(uiTbl.frame, capInsets)
            clipStencil = cc.Scale9Sprite:createWithSpriteFrameName(uiTbl.frame, capInsets)
        elseif uiTbl.texture and cc.FileUtils:getInstance():isFileExist(uiTbl.texture) then
            progress_bar_sp =  cc.Scale9Sprite:create(capInsets, uiTbl.texture)
            clipStencil =   cc.Scale9Sprite:create(capInsets, uiTbl.texture)
        else
            clipStencil =  cc.Sprite:create()
            progress_bar_sp = cc.Sprite:create()
        end
        -- progress_bar_sp:setScale9Enabled(true)
        progress_bar_sp:setContentSize(content_size)
        clipStencil:setContentSize(content_size)
       
    else
        progress_bar_sp = cc.Sprite:create()
        clipStencil = cc.Sprite:create()
        if uiTbl.frame then
            progress_bar_sp:setSpriteFrame(uiTbl.frame)
            clipStencil:setSpriteFrame(uiTbl.frame)
             

        elseif uiTbl.texture then
            progress_bar_sp:setTexture(uiTbl.texture)
            clipStencil:setTexture(uiTbl.texture)
        end
       
    end
    local node
    if clipStencil then
        node = cc.Node:create()
        local clip = cc.ClippingNode:create(clipStencil)
        clip:setAlphaThreshold( 0.7)
        clip:addChild(progress_bar_sp)
        node:addChild(clip)
        node.__progress_bar = progress_bar_sp
        node.stencil_node = clipStencil
        node.__progress_width = content_size.width

        node.getProgressBar = function(obj)
           return  obj.__progress_bar
        end

        node.getPercentage = function(obj)
            return  obj.__percent
         end

        node.setPercentage = function(obj,percent)
            if not libUI.isValidNode(obj.__progress_bar) then return end

            percent = percent < 0 and 0 or percent
            percent = percent > 100 and 100 or percent
            local width = obj.__progress_width or 0
            obj.__progress_bar:setPositionX((percent/100.0 - 1)*width)
            obj.__percent = percent
        end
        uiTbl.content_size = nil 
        node:setPercentage(0)
    else
        node= cc.ProgressTimer:create(progress_bar_sp)
        node:setType(cc.PROGRESS_TIMER_TYPE_BAR)
        node:setMidpoint(cc.p(0,0))
        node:setBarChangeRate(cc.p(1,0))
        node:setPercentage(0)
        node.progress_bar_sp = progress_bar_sp
    end

    node.__progress_to_tag = 2105271612
	
	node.progressTo = function ( obj, time, percent )
		if not libUI.isValidNode(obj) then return end
		if not time or not percent then return end

		local tag = node.__progress_to_tag or 0
		obj:stopActionByTag(tag)

		if time == 0 then
			obj:setPercentage(percent)
		else
            if libUI.isValidNode(obj.spine) then
                obj.spine:setVisible(true)
            end
			local frameRate = 30.0
			local diff = (percent - obj.__percent)/(time*frameRate)
			local isUp = percent > obj.__percent
			local action = cc.RepeatForever:create(
				cc.Sequence:create(
					cc.DelayTime:create(1/frameRate),
					cc.CallFunc:create(function ()
						local tmpPercent = obj.__percent + diff
						local over = false
						if tmpPercent == percent then
							-- 结束
							over = true
						elseif isUp and tmpPercent > percent then
							over = true
						elseif not isUp and tmpPercent < percent then
							over = true
						end

						if over then
							obj:stopActionByTag(tag)
							obj:setPercentage(percent)
                            if libUI.isValidNode(obj.spine) then
                                obj.spine:setVisible(false)
                            end
						else
							obj:setPercentage(tmpPercent)
						end
					end)
				)
			)
			action:setTag(tag)
			obj:runAction(action)
		end
	end
    node.loadTexture=function(obj,fileName,texType)
        if not fileName then
            return 
        end
        if texType ==  ccui.TextureResType.localType then
            -- self:initWithFile(fileName,consept);
            local rect =  obj.__progress_bar:getCapInsets()
            local size =  obj.__progress_bar:getContentSize()
            obj.__progress_bar:setTexture(fileName)
            obj.__progress_bar:setContentSize(size)
        elseif texType ==  ccui.TextureResType.plistType then
            local spriteFrameCache = cc.SpriteFrameCache:getInstance()
            local rect =  obj.__progress_bar:getCapInsets()
            local size =  obj.__progress_bar:getContentSize()
            obj.__progress_bar:setSpriteFrame(spriteFrameCache:getSpriteFrame(fileName), rect)
            obj.__progress_bar:setContentSize(size)
        end
    end
    parent:addChild(node)
    node:setName("progress_bar_tag789")
    return node
end

function CreatorUITools:_createSpineNode(parent, uiTbl, rootNode)
    local p = cc.p(0, 0);
    if uiTbl.position ~= nil then
        p = cc.p(uiTbl.position.x, uiTbl.position.y);
    end
    local _, spine = bole.addSpineAnimationInTheme(parent, 0, uiTbl.spine.name, p, uiTbl.spine.animation, nil, nil, nil, true, uiTbl.spine.isLoop, uiTbl.spine.timeScale or 1)
    -- local spine =  sp.SkeletonAnimation:create(uiTbl.spine.name..".json", uiTbl.spine.name..".atlas", 1)
    -- parent:addChild(spine)
    -- spine:setPosition(p)
    -- spine:setTimeScale(uiTbl.spine.timeScale or 1)
    -- if uiTbl.spine.animation ~= "" then
    --     spine:setAnimation(0, uiTbl.spine.animation, uiTbl.spine.isLoop)
    -- end
    
    return spine
end

function CreatorUITools:_createEditBox(parent, uiTbl, rootNode)
    local node = nil;
    local editBox = uiTbl.editBox
    if editBox.frame then
        node = ccui.EditBox:create(uiTbl.content_size, editBox.frame, 1)
    else
        node = ccui.EditBox:create(uiTbl.content_size, editBox.texture, 0)
    end
    parent:addChild(node)
    return node;
end

function CreatorUITools:_createUIFile(parent, uiTbl, rootNode)
    -- self:createUi(uiTbl.uiPath, parent)
    local new_parent = self:createUi(uiTbl.uiPath)
    parent:addChild(new_parent)

    return new_parent
end

function CreatorUITools:_renderNode(node, uiTbl)
    if uiTbl.position and node.setPosition then
        node:setPosition(cc.p(uiTbl.position.x, uiTbl.position.y))
    end
    if node.setAnchorPoint then
        if uiTbl.anchor then
            node:setAnchorPoint(cc.p(uiTbl.anchor.x, uiTbl.anchor.y))
        else
            node:setAnchorPoint(cc.p(0.5, 0.5))
        end
    end
    
    if uiTbl.scale and node.setScaleX then
        local scale = uiTbl.scale;
        node:setScaleX(scale.x)
        node:setScaleY(scale.y)
    end
    if uiTbl.visible ~= nil and node.setVisible then
        node:setVisible(uiTbl.visible)
    end
    if uiTbl.opacity and node.setOpacity then
        node:setOpacity(uiTbl.opacity)
    end
    if uiTbl.rotation and node.setRotation then
        node:setRotation(uiTbl.rotation)
    end
    if uiTbl.z_order and node.setZOrder then
        node:setZOrder(uiTbl.z_order)
    end

    if uiTbl.color and node.setColor then
        if uiTbl.type == "BLLabel" or uiTbl.type == "BLTTFFont" then
            node:setTextColor(cc.c3b(uiTbl.color[1], uiTbl.color[2], uiTbl.color[3]))
        else
            node:setColor(cc.c3b(uiTbl.color[1], uiTbl.color[2], uiTbl.color[3]))
        end
    end

    
    

    if uiTbl.name then
        local _ = node.setName and node:setName(uiTbl.name)
        node.name = uiTbl.name
    end
    if uiTbl.ui_file_name then
        local _ = node.setName and node:setName(uiTbl.ui_file_name)
        node.ui_file_name = uiTbl.ui_file_name
    end
    if uiTbl.skew then
        if node.setSkewX then
            node:setSkewX(uiTbl.skew.x)
        end
        if node.setSkewY then
            node:setSkewY(uiTbl.skew.y)
        end
    end
    if uiTbl.content_size and node.setContentSize then
        node:setContentSize(uiTbl.content_size)
    end
end

function CreatorUITools:_renderLabelNode(node, uiTbl)
    self:_renderNode(node, uiTbl)
    
    if node.setAlignment ~= nil then
        node:setAlignment(uiTbl.horizontal_align, uiTbl.vertical_align)
    end
    
    local stroke_color = uiTbl.stroke_color
    if stroke_color and node.enableStroke then
        node:enableStroke(stroke_color, uiTbl.stroke_size)
    end

    if uiTbl.overflow ~= nil and node.setOverflow then
        node:setOverflow(uiTbl.overflow)
        if uiTbl.overflow == cc.LabelOverflow.RESIZE_HEIGHT then -- RESIZE_HEIGHT
            node:setDimensions(uiTbl.content_size.width, uiTbl.content_size.height)
            node:setMaxLineWidth(uiTbl.content_size.width)
        elseif uiTbl.overflow == cc.LabelOverflow.SHRINK then
            node:setDimensions(uiTbl.content_size.width, uiTbl.content_size.height)
        end
    end

    if uiTbl.font_size and node.setFontSize then
        node:setFontSize(uiTbl.font_size) 
    end

    if uiTbl.type ~= "BLBMFont" and uiTbl.type ~= "BLLabel" and uiTbl.lineHeight ~= nil and node.setLineHeight ~= nil then
        node:setLineHeight(uiTbl.lineHeight)
    end

    -- if uiTbl.type ~= "BLBMFont" and uiTbl.line_height ~= nil and node.setLineHeight ~= nil then
    --     node:setLineHeight(uiTbl.line_height)
    -- end
end

function CreatorUITools:_renderSpine(node, uiTbl)
    if uiTbl.anchor and node.setAnchorPoint then
        local anchor = uiTbl.anchor;
        node:setAnchorPoint(anchor.x, anchor.y)
    end
    if uiTbl.scale and node.setScaleX then
        local scale = uiTbl.scale;
        node:setScaleX(scale.x)
        node:setScaleY(scale.y)
    end

    if uiTbl.visible ~= nil and node.setVisible then
        node:setVisible(uiTbl.visible)
    end

    if uiTbl.opacity and node.setOpacity then
        node:setOpacity(uiTbl.opacity)
    end
    if uiTbl.rotation and node.setRotation then
        node:setRotation(uiTbl.rotation)
    end
    if uiTbl.z_order and node.setZOrder then
        node:setZOrder(uiTbl.z_order)
    end
    if uiTbl.color and node.setColor then
        node:setColor(uiTbl.color)
    end

    if uiTbl.name and node.setName then
        node:setName(uiTbl.name)
    end
    if uiTbl.skew then
        if node.setSkewX then
            node:setSkewX(uiTbl.skew.x)
        end
        if node.setSkewY then
            node:setSkewY(uiTbl.skew.y)
        end
    end
end

function CreatorUITools:_renderScrollView(node, uiTbl)
    self:_renderNode(node, uiTbl)
    
    if uiTbl.scrollView.direction ~= nil and node.setDirection then
        node:setDirection(uiTbl.scrollView.direction)
    end

    if uiTbl.scrollView.inertia ~= nil and node.setInertiaScrollEnabled then
        node:setInertiaScrollEnabled(uiTbl.scrollView.inertia)
    end

    if uiTbl.scrollView.elastic and node.setBounceEnabled then
        node:setBounceEnabled(uiTbl.scrollView.elastic)
    end
    node:setScrollBarEnabled(false)
end

function CreatorUITools:_renderPageView(node, uiTbl)
    self:_renderNode(node, uiTbl)
end

function CreatorUITools:_renderEditBox(node, uiTbl)
    self:_renderNode(node, uiTbl)
    local editBox = uiTbl.editBox;
    if editBox.inputFlag ~= nil and node.setInputFlag then
        node:setInputFlag(editBox.inputFlag)
    end

    if editBox.inputMode ~= nil and node.setInputMode then
        node:setInputMode(editBox.inputMode)
    end

    if editBox.inputMode ~= nil and node.setInputMode then
        node:setInputMode(editBox.inputMode)
    end

    if editBox.maxLength ~= nil and node.setMaxLength then
        node:setMaxLength(editBox.maxLength)
    end

    if editBox.label then
        if editBox.label.font_name then
            node:setFont(editBox.label.font_name, editBox.label.font_size)
        end

        if editBox.label.color then
            node:setFontColor(cc.c3b(editBox.label.color[1], editBox.label.color[2], editBox.label.color[3]))
        end

        node:setText(editBox.string)
    end

    if editBox.placeholderLabel then
        if editBox.placeholderLabel.font_name then
            node:setPlaceholderFont(editBox.placeholderLabel.font_name, editBox.placeholderLabel.font_size)
        end

        if editBox.placeholderLabel.color then
            node:setPlaceholderFontColor(cc.c3b(editBox.placeholderLabel.color[1], editBox.placeholderLabel.color[2], editBox.placeholderLabel.color[3]))
        end

        node:setPlaceHolder(editBox.placeholder)
    end
end

return CreatorUITools
