local ui = {}

function ui.Node()
	return cc.Node:create()
end

function ui.Scene()
	return cc.Scene:create()
end

function ui.Layer()
	return cc.Layer:create()
end

function ui.LayerColor(color)
    return cc.LayerColor:create(color)
end


function ui.GrayLayer()
    return cc.LayerColor:create(cc.c4b(0,0,0,150))
end

function ui.Sprite(image)
	return cc.Sprite:create(image)
end

function ui.LabelTTF(default, fontFamily, size)
    return cc.LabelTTF:create(default, fontFamily, size)
end

function ui.SpriteBg(file)
	local sp = cc.Sprite:create("bg/" .. file)
	local size = sp:getContentSize()
	sp:setScaleX(director.width / size.width)
	sp:setScaleX(director.height / size.height)
    sp:setAnchorPoint(cc.p(0,0))
    sp:setPosition(cc.p(0,0))
	return sp
end

function ui.ProgressTimer(sprite)
    return cc.ProgressTimer:create(sprite)
end

-- widgets
function ui.Layout()
    return ccui.Layout:create()
end

function ui.Widget()
	return ccui.Widget:create()
end

function ui.binWidget(file)
    return ccs.GUIReader:getInstance():widgetFromBinaryFile(file)
end

function ui.jsonWidget(file)
    return ccs.GUIReader:getInstance():widgetFromJsonFile(file)
end

function ui.Button()
    return ccui.Button:create()
end

function ui.CheckBox(image)
	local cbox = image or ccui.ImageView:create()

    local tab = { isSelected = false }
    function tab.cBoxOnTouch(sender,eventType)
        local self = tab
        if eventType == ccui.TouchEventType.began then
            if self.moving then
                cbox:loadTexture(self.moving, self.isFrame)
            elseif self.isSelected then
                cbox:loadTexture(self.unselected, self.isFrame)
            else
                cbox:loadTexture(self.selected, self.isFrame)
            end
        elseif eventType == ccui.TouchEventType.moved then

        elseif eventType == ccui.TouchEventType.ended then
            self.isSelected = (not self.isSelected)
            if self.isSelected then
                cbox:loadTexture(self.selected, self.isFrame)
                self.listner(sender, ccui.CheckBoxEventType.selected)
            else
                cbox:loadTexture(self.unselected, self.isFrame)
                self.listner(sender, ccui.CheckBoxEventType.unselected)
            end
        elseif eventType == ccui.TouchEventType.canceled then
            if self.isSelected then
                cbox:loadTexture(self.selected, self.isFrame)
            else
                cbox:loadTexture(self.unselected, self.isFrame)
            end
        end
        
    end
    function tab:loadTextures(unselected, selected, moving, isFrame)
        self.unselected  = unselected
        self.selected = selected
        if moving and moving ~= "" then
            self.moving = moving 
        else
            self.moving = nil
        end
        
        self.isFrame = isFrame or 0

        cbox:loadTexture(self.unselected, self.isFrame)
    end
    function tab:addTouchEventListener(listner)
        self.listner = listner
    end
    function tab:setSelectedState(state)
        if self.isSelected ~= state then
            self.isSelected = state
            if self.isSelected then
                cbox:loadTexture(self.selected, self.isFrame)
            else
                cbox:loadTexture(self.unselected, self.isFrame)
            end
        end
    end

    cbox:setTouchEnabled(true)
    cbox:addTouchEventListener(tab.cBoxOnTouch)
    
    tolua.setpeer(cbox, tab)

    return cbox
end

function ui.CheckBox2()
    local cboxBg = ccui.ImageView:create()
    local cboxText = ccui.ImageView:create()
    cboxBg:addChild(cboxText)

    local tab = { isSelected = false }
    function tab.cBoxOnTouch(sender,eventType)
        local self = tab

        if eventType == ccui.TouchEventType.began then
            if self.isSelected then
                cboxBg:loadTexture(self.bgNorm, self.isFrame)
                cboxText:loadTexture(self.textNorm, self.isFrame)
            else
                cboxBg:loadTexture(self.bgSelected, self.isFrame)
                cboxText:loadTexture(self.textSelected, self.isFrame)
            end
        elseif eventType == ccui.TouchEventType.moved then
            
        elseif eventType == ccui.TouchEventType.ended then
            self.isSelected = (not self.isSelected)
            if self.isSelected then
                self.listner(sender, ccui.CheckBoxEventType.selected)
            else
                self.listner(sender, ccui.CheckBoxEventType.unselected)
            end
        elseif eventType == ccui.TouchEventType.canceled then
            if self.isSelected then
                cboxBg:loadTexture(self.bgSelected, self.isFrame)
                cboxText:loadTexture(self.textSelected, self.isFrame)
            else
                cboxBg:loadTexture(self.bgNorm, self.isFrame)
                cboxText:loadTexture(self.textNorm, self.isFrame)
            end
        end
    end
    function tab:loadTextures(bgNorm, bgSelected, textNorm, textSelected, isFrame)
        self.bgNorm  = bgNorm
        self.bgSelected = bgSelected
        self.textNorm  = textNorm
        self.textSelected = textSelected
        
        self.isFrame = isFrame or 0

        cboxBg:loadTexture(self.bgNorm, self.isFrame)
        cboxText:loadTexture(self.textNorm, self.isFrame)
        
        local bgSize = cboxBg:getContentSize()
        cboxText:setPosition(cc.p(bgSize.width/2, bgSize.height/2))
    end
    function tab:addTouchEventListener(listner)
        self.listner = listner
    end

    function tab:setSelectedState(state)
        if self.isSelected ~= state then
            self.isSelected = state
            if self.isSelected then
                cboxBg:loadTexture(self.bgSelected, self.isFrame)
                cboxText:loadTexture(self.textSelected, self.isFrame)
            else
                cboxBg:loadTexture(self.bgNorm, self.isFrame)
                cboxText:loadTexture(self.textNorm, self.isFrame)
            end
        end
    end

    cboxBg:setTouchEnabled(true)
    cboxBg:addTouchEventListener(tab.cBoxOnTouch)
    
    tolua.setpeer(cboxBg, tab)

    return cboxBg
end

function ui.ImageView(file, isFrame)
    if file then
    	local image = ccui.ImageView:create()
        isFrame = isFrame or 0
        image:loadTexture(file, isFrame)
        return image
    else
        return ccui.ImageView:create()
    end
end

function ui.RichText()
	return ccui.RichText:create()
end
  
function ui.HtmlText(text, ...)
    if #{...} > 0 then
        text = string.format(text, ...)
    end

    local richText = ui.RichText()

    local defaultSize = 26
    local defaultFont = "Helvetica"
    local defaultColor = cc.c3b(0x00,0x00,0x00) --cc.c3b(0xFF,0xFF,0xFF)
    local defaultImgColor = cc.c3b(0xFF,0xFF,0xFF)

    local head_font = "<font"
    local tail_font = "</font>"
    local head_img = "<img"
    local tail_img = "/>"
    local head_norm = "<"
    local tail_norm = ">"

    local type_norm = 1
    local type_font = 2
    local type_img = 3

    local texts = {}
    local elements = {}

    local pbegin, pend, s1, s2, s3, count, elementNum

    local function parse_norm(s)
        elementNum = #elements + 1
        local richElementText = ccui.RichElementText:create(elementNum, defaultColor, 255, s, defaultFont, defaultSize)
        richText:pushBackElement(richElementText)
        elements[elementNum] = richElementText
    end
    local function parse_img(s)
        elementNum = #elements + 1
        pbegin = string.find(s, 'src="') + 5
        s = string.sub(s, pbegin)
        pend = string.find(s, '"') - 1
        s = string.sub(s, 1, pend)
        local richElementImage = ccui.RichElementImage:create(elementNum, defaultImgColor, 255, s)
        richText:pushBackElement(richElementImage)
        elements[elementNum] = richElementImage
    end
    local function parse_font(s)
        local size, color
        pend = string.find(s, tail_norm)
        s1 = string.sub(s, 1, pend)
        pbegin = string.find(s1, 'size="')
        if pbegin then
            s2 = string.sub(s1, pbegin+6)
            pend = string.find(s2, '"')
            size = string.sub(s2, 1, pend-1)
            size = tonumber(size)
        else
            size = defaultSize
        end
        pbegin = string.find(s1, 'color="#')
        if pbegin then
            local r, g, b
            s2 = string.sub(s1, pbegin+8)
            pend = string.find(s2, '"')
            color = tonumber("0x" .. string.sub(s2, 1, pend-1))
            r = math.floor(color/0x00FFFF)
            g = math.floor((color-r)/0x0000FF)
            b = color-r-g
            color = cc.c3b(r,g,b)
        else
            color = defaultColor
        end
        pend = string.find(s, tail_norm)
        s = string.sub(s, pend+1)
        repeat
            pbegin = string.find(s, head_img)
            if not pbegin then
                
                pbegin = string.find(s, tail_font)
                s = string.sub(s, 1, pbegin-1)
                elementNum = #elements + 1
                local richElementText = ccui.RichElementText:create(elementNum, color, 255, s, defaultFont, size)
                richText:pushBackElement(richElementText)
                elements[elementNum] = richElementText
                return
            else
                if pbegin == 1 then
                    pend = string.find(s, tail_norm)
                    s2 = string.sub(s, 1, pend)
                    parse_img(s2)
                else
                    s1 = string.sub(s, 1, pbegin-1)
                    elementNum = #elements + 1
                    local richElementText = ccui.RichElementText:create(elementNum, color, 255, s1, defaultFont, size)
                    richText:pushBackElement(richElementText)
                    elements[elementNum] = richElementText

                    s2 = string.sub(s, pbegin)
                    pend = string.find(s2, tail_norm)
                    s = string.sub(s2, pend+1)
                    s2 = string.sub(s2, 1, pend)
                    parse_img(s2)
                end
            end
        until(not pbegin)
    end
    
    local function split(s)
        if string.len(s) == 0 then return end
        count = #texts + 1
        if string.sub(s, 1, 5) == "<font" then
            pend = string.find(s, tail_font) + 6
            texts[count] = type_font
            texts[count+1] = string.sub(s, 1, pend)
            if pend+1 ~= string.len(s)then
                s = string.sub(s, pend+1)
            else
                return
            end
        elseif string.sub(s, 1, 4) == "<img" then
            pend = string.find(s, tail_img) + 1
            texts[count] = type_img
            texts[count+1] = string.sub(s, 1, pend)
            if pend+1 ~= string.len(s)then
                s = string.sub(s, pend+1)
            else
                return
            end
        else
            texts[count] = type_norm
            pbegin = string.find(s, head_norm)
            if pbegin then
                texts[count+1] = string.sub(s, 1, pbegin-1)
                s = string.sub(s, pbegin)
            else
                texts[count+1] = s
                return
            end
            
        end
        split(s)
    end
    split(text)
    for i=1, (#texts)/2 do
        if texts[i*2-1] == type_norm then
            parse_norm(texts[i*2])
        elseif texts[i*2-1] == type_font then
            parse_font(texts[i*2])
        else
            parse_img(texts[i*2])
        end
    end
    
    return richText
end

function ui.Slider()
	return ccui.Slider:create()
end

function ui.Text(text)
    local t = ccui.Text:create()
    if text then
        t:setString(text)
    end
    return t
end

function ui.Text2()
    local t = ccui.Text:create()
    if text then
        t:setString(text)
    end
    return t
end

function ui.Text3()
    local t = ccui.Text:create()
    if text then
        t:setString(text)
    end
    return t
end

function ui.TextAtlas()
	return ccui.TextAtlas:create()
end

function ui.TextBMFont()
	return ccui.TextBMFont:create()
end

function ui.TextField()
	return ccui.UICCTextField:create()
end

-- scroll widgets
function ui.ScrollView()
	return ccui.ScrollView:create()
end

function ui.PageView()
	return ccui.PageView:create()
end

function ui.ListView()
	return ccui.ListView:create()
end


function ui.BagView()
    --local layer = ui.Layer()
    local bag = ui.ScrollView()
    bag:setBounceEnabled(true)
    bag:setTouchEnabled(true)
    bag:setInnerContainerSize(cc.size(0,0))

    local tab = 
    {
        scrollDirection = ccui.ScrollViewDir.vertical,
        putDirection = ccui.ScrollViewDir.horizontal,
        itemNum = 0,
        numInRow = 1,
        numInColumn = 1,
        rowInternal = 0,
        columnInternal = 0,
        model = nil,
        modelSize = cc.size(0,0),
    }
    --layer:addChild(bag)
    function tab:setSize(size)
        self.size = size
        self:setContentSize(size)
        self:setInnerContainerSize(size)
    end
    function tab:setScrollDirection(direction)
        self.scrollDirection  = direction
        self:setDirection(direction)
    end
    function tab:setPutDirection(direction)
        self.putDirection  = direction
    end
    function tab:setItemNumInRow(num)
        self.numInRow = num
    end
    function tab:setRowInternal(internal)
        self.rowInternal = internal
    end
    function tab:setItemNumInColumn(num)
        self.numInColumn = num
    end
    function tab:setColumnInternal(internal)
        self.columnInternal = internal
    end
    function tab:setModel(model)
        self.model = model
        local scalex = model:getScaleX()
        local scaley = model:getScaleY()
        self.modelSize = model:getContentSize()
        self.modelSize.width = self.modelSize.width * scalex
        self.modelSize.height = self.modelSize.height * scaley
    end
    function tab:setModelSize(size)
        self.modelSize = size
    end
    function tab:autoInternal(model)
        if self.putDirection == ccui.ScrollViewDir.horizontal then
            self.rowInternal = (self.size.height - self.modelSize.height*self.numInColumn) / (self.numInColumn-1)
            self.columnInternal = (self.size.width - self.modelSize.width*self.numInRow) / (self.numInRow-1)
        else
            self.rowInternal = (self.size.height - self.modelSize.height*self.numInColumn) / (self.numInColumn-1)
            self.columnInternal = (self.size.width - self.modelSize.width*self.numInRow) / (self.numInRow-1)
        end
    end
    function tab:resize()
        if self.putDirection == ccui.ScrollViewDir.horizontal then
            local rowIdx = self.itemNum % self.numInRow
            if rowIdx == 0 then
                rowIdx = self.numInRow
            end
            local rowNum = math.floor((self.itemNum-1)/self.numInRow) + 1
            local newHeight = self.modelSize.height*rowNum + self.rowInternal*(rowNum-1)
            if newHeight < self.size.height then
                newHeight = self.size.height
            end
            local innerSize = self:getInnerContainerSize()
            if newHeight ~= innerSize.height then
                local heightAdd = newHeight - innerSize.height
                innerSize.height = newHeight
                self:setInnerContainerSize(innerSize)
                local pos
                for i=1, self.itemNum do
                    pos = cc.p(self.items[i]:getPosition())
                    pos.y = pos.y + heightAdd
                    self.items[i]:setPosition(pos)
                end
            end
        else
            local innerSize = self:getInnerContainerSize()
            local rowNum = self.itemNum/self.numInColumn
            if self.itemNum%self.numInColumn > 0 then
                rowNum = math.floor(rowNum+1)
            end
            innerSize.width = self.modelSize.width*rowNum + self.columnInternal*(rowNum-1)
            self:setInnerContainerSize(innerSize)
        end
    end
    function tab:addItem(item)
        self:addChild(item)
        
        self.items = self.items or {}
        self.itemNum = self.itemNum + 1
        self.items[self.itemNum] = item

        local itemInfo = { idx = self.itemNum }
        tolua.setpeer(item, itemInfo)

        local itemPos = cc.p(0,0)
        local innerSize = self:getInnerContainerSize()

        if self.putDirection == ccui.ScrollViewDir.horizontal then
            local rowIdx = self.itemNum % self.numInRow
            if rowIdx == 0 then
                rowIdx = self.numInRow
            end
            
            itemPos.x = self.modelSize.width*(rowIdx-0.5) + self.columnInternal*(rowIdx-1)
            if self.itemNum % self.numInRow == 1 then
                local rowNum = math.floor((self.itemNum-1)/self.numInRow) + 1
                local newHeight = self.modelSize.height*rowNum + self.rowInternal*(rowNum-1)
                if newHeight > innerSize.height then
                    local heightAdd = newHeight - innerSize.height
                    innerSize.height = newHeight
                    self:setInnerContainerSize(innerSize)
                    local preItem, prePos
                    for i=1, self.itemNum-1 do      
                        preItem = self.items[i]
                        prePos = cc.p(preItem:getPosition())
                        prePos.y = prePos.y + heightAdd--self.modelSize.height + self.rowInternal
                        preItem:setPosition(prePos)
                    end
                end
            end
            if self.itemNum == 1 then
                itemPos.y = self.size.height - self.modelSize.height/2
            else
                if self.itemNum % self.numInRow == 1 then
                    _, itemPos.y = self.items[self.itemNum-1]:getPosition()
                    itemPos.y = itemPos.y - (self.modelSize.height+self.rowInternal)
                else
                    _, itemPos.y = self.items[self.itemNum-1]:getPosition()
                end
            end
        else
            local rowIdx = math.floor((self.itemNum-1)/self.numInColumn) + 1
            local columnIdx = self.itemNum%self.numInColumn
            if columnIdx == 0 then
                columnIdx = self.numInColumn
            end
            itemPos.x = self.modelSize.width*(rowIdx-0.5) + self.columnInternal*(rowIdx-1)
            itemPos.y = self.size.height - (self.modelSize.height*(columnIdx-0.5) + self.rowInternal*(columnIdx-1))
            if self.itemNum % self.numInColumn == 1 then
                local rowNum = math.floor(self.itemNum/self.numInColumn) + 1
                innerSize.width = self.modelSize.width*rowNum + self.columnInternal*(rowNum-1)
                self:setInnerContainerSize(innerSize)
            end
        end
        item:setPosition(itemPos)
    end
    function tab:removeItem(idx)
        local x, y
        local maxIdx = self.itemNum
        
        if idx > maxIdx then return end

        for i = maxIdx, idx+1, -1 do
            x, y = self.items[i-1]:getPosition()
            if y then
                self.items[i]:setPosition(cc.p(x,y))
            else
                self.items[i]:setPosition(x)
            end
            self.items[i].idx = i-1
        end
        self.items[idx]:removeFromParent()
        table.remove(self.items, idx)
        self.itemNum = self.itemNum - 1
        
        self:resize()
    end
    function tab:removeAllItem()
        local itemNum = self.itemNum
        for i=1, itemNum do
            self:removeItem(1)
        end
    end
    function tab:getItemNum()
        return self.itemNum
    end
    function tab:getItem(idx)
        return self.items[idx]
    end

    tolua.setpeer(bag, tab)

    return bag
end

function ui.maskLayer()
    local layer = ui.Layer()
    layer:setTouchEnabled(true)
    layer:registerScriptTouchHandler(function (event, x, y)
        return true
    end)

    return layer
end

function ui.callbackLayer(callback)
    local layer = ui.Layer()
    layer:setTouchEnabled(true)
    layer:registerScriptTouchHandler(function (event, x, y)
        local _x, _y = layer:getPosition()
        if event == "ended" then 
            if callback then
                if _x == 0 and _y == 0 then
                    callback()
                end
            end
        end
        if _x == 0 and _y == 0 then
            return true
        else
            return false
        end
    end)

    return layer
end

function ui.messageBox(msg, callback)
    local layer = ui.Layer()
    local box = ui.binWidget("messageBox.csb")
    box:setTouchEnabled(false)
    layer:addChild(box)
    layer:setTouchEnabled(true)

    local text = box:getChildByName("text")
    text:setString(msg)

    local function layerOnTouch(event, x, y)
        if event == "ended" then
            if callback then
                callback()
            end
            layer:removeFromParent()
        end
        return true
    end
    layer:registerScriptTouchHandler(layerOnTouch)
    return layer
end

--[[
function ui.messageBox(message, okCallBack, cancelCallBack)
    local mask = ui.Layer()
    local widget = ccs.GUIReader:getInstance():widgetFromJsonFile(res.ccs_messageBox)
    local layer = cc.Layer:create()
    layer:addChild(mask)
    layer:addChild(widget)

    local okBtn = widget:getChildByName("okBtn")
    okBtn:setScaleY(0.6)
    local cancelBtn = widget:getChildByName("cancelBtn")
    cancelBtn:setScaleY(0.6)
    
    local textArea = widget:getChildByName("textArea")
    local boxBg = widget:getChildByName("boxBg")
    local boxSize = boxBg:getContentSize()
    boxBg:loadTexture("Battle_choose_background_1.png")
    local currBoxSize = boxBg:getContentSize()
    boxBg:setScaleX(boxSize.width/currBoxSize.width)
    boxBg:setScaleY(0.85)
    textArea:setText(message)
    mask:setTouchEnabled(true)
    okBtn:setTouchEnabled(true)
    cancelBtn:setTouchEnabled(true)
    boxBg:setTouchEnabled(true)
    
    local function maskOnTouch(event, x, y)
        if event == "began" then
            return true
        elseif event == "ended" then
            if(okCallBack and (not cancelCallBack))then
                layer:removeFromParent()
                okCallBack()    
            elseif(okCallBack and cancelCallBack)then
                layer:removeFromParent()
                cancelCallBack()
            end
            return true
        end
    end
    local function okHandler(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
            layer:removeFromParent()
            if(okCallBack)then
                okCallBack()
            end
        end
    end
    local function cancelHandler(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
            layer:removeFromParent()
            if(cancelCallBack)then
                cancelCallBack()
            elseif(okCallBack)then
                okCallBack()
            end
        end
    end
    local function maskOnly(sender,eventType)
    end
    
    mask:registerScriptTouchHandler(maskOnTouch)
    okBtn:addTouchEventListener(okHandler)
    cancelBtn:addTouchEventListener(cancelHandler)
    boxBg:addTouchEventListener(maskOnly)
    
    return layer
end
--]]

function ui.layerMgr()
    local lmgr = { currLayer = nil }
    
    function lmgr:add(layer)
        self[layer] = layer
    end
    function lmgr:remove(layer)
        if self.currLayer == layer then
            self.currLayer = nil
        end
        self[layer] = nil
    end
    -- all layers will be set out of window when layer == nil 
    function lmgr:set(layer)
        if self.currLayer and self.currLayer ~= layer then
            self.currLayer:setPosition(director.out)
            if self.currLayer.onHide then
                self.currLayer:onHide()
            end
        end
        if self[layer] then
            layer:setPosition(cc.p(0,0))
            if layer.onShow then
                layer:onShow()
            end
            self.currLayer = layer
        end
    end

    return lmgr
end

function ui.getSpriteFrame(file)
    return cc.SpriteFrameCache:getInstance():getSpriteFrameByName(file)
end

function ui.spriteWithFrame(file)
    local frame = cc.SpriteFrameCache:getInstance():getSpriteFrameByName(file)
    return cc.Sprite:createWithSpriteFrame(frame)
end

function ui.scale9SpriteWithFrame(file)
    local frame = cc.SpriteFrameCache:getInstance():getSpriteFrameByName(file)
    return cc.Scale9Sprite:createWithSpriteFrame(frame)
end
--[[
function ui.pushWindow(mbox)
    director.getRunningScene():addChild(mbox, 1000)
end

function util.getRingListOnTouchEndedFunc()
    local flag = false
    local function isTouchEnded()
        return flag
    end
    local function setTouchEnded(ended)
        flag = ended
    end

    return isTouchEnded, setTouchEnded
end

function util.RichTextOfNum(n, imgName)
    local text = util.RichText()
    local revertN = 0

    repeat
        revertN = revertN*10 + n%10
        n = math.floor(n/10)
    until(n==0)
    repeat
        local subText = ccui.RichElementImage:create(6, cc.c3b(255, 255, 255), 255, imgName .. revertN%10 .. ".png")
        revertN = math.floor(revertN/10)
        text:pushBackElement(subText)
    until(revertN==0)
    return text
end
--]]


--[[
local icon = ui.Icon({bg = "whiteIconBg.png", head = "107400025.png", border = "whiteFrame.png"}, function(icon) 
    print(icon.bg, icon.head, icon.border)
end)
icon:setPosition(director.center)
local layer = ui.Layer()
layer:addChild(self.icon)
]]


function ui.Utf8Text(s, fontName, fontsize, color, width)
    local mathFloor = require("math").floor
    local stringSub = require("string").sub
    local utf8Sub = utf8.sub
    local utf8Len = utf8.len
    local strs = {}
    local text = ui.Text()
    text:setFontName(fontName)
    text:setFontSize(fontsize)
    text:setColor(color)
    
    local function getSubStr(ss)
        local subs = ss
        text:setString(subs)
        local currWidth = text:getContentSize().width
        local idx = 0
        if currWidth > width then
            idx = mathFloor(utf8Len(subs)/(currWidth/width+1))
            subs = utf8Sub(s, 1, idx)
            text:setString(subs)
            if text:getContentSize().width > width then
                repeat
                    idx = idx-1
                    subs = utf8Sub(s, 1, idx)
                    text:setString(subs)
                until(text:getContentSize().width <= width)
            elseif text:getContentSize().width < width then
                repeat
                    idx = idx+1
                    subs = utf8Sub(s, 1, idx)
                    text:setString(subs)
                until(text:getContentSize().width > width)
                idx = idx-1
                subs = utf8Sub(s, 1, idx)
            end
        end
        if idx ~= 0 then
            return subs, utf8Sub(s, idx+1)
        end
        return subs
    end
    local subStr
    local strs = {}
    while s do
        subStr, s = getSubStr(s)
        strs[#strs+1] = subStr

    end
    local textWidth = text:getContentSize().width
    local textHeight = text:getContentSize().height
    if #strs == 1 then
        text:setAnchorPoint(cc.p(0,1))
        return text, textWidth, textHeight
    end
    local subText
    local node = ui.Node()
    local currHeight = 0
    
    for i=1, #strs do
        if i==1 then
            subText = text
        else
            subText = ui.Text()
            subText:setFontName(fontName)
            subText:setFontSize(fontsize)
            subText:setColor(color)
        end
        subText:setString(strs[i])
        subText:setAnchorPoint(cc.p(0,1))
        subText:setPosition(cc.p(0, currHeight))
        node:addChild(subText)
        currHeight = currHeight - textHeight
    end

    return node, width, -currHeight
end

function ui.FlyPromptText(str, flyY, flyTime, color, size)
    flyY = flyY or 120
    flyTime = flyTime or 1
    size = size or 22
    color = color or cc.c3b(200,0,0)

    local text = ui.Text(str)
    text:setFontSize(size)
    text:setColor(color)
    text:setAnchorPoint(cc.p(0.5,0.5))

    local moveBy = cc.MoveBy:create(3, cc.p(0, flyY))
    local fadeout = cc.FadeOut:create(flyTime)

    local seq = cc.Sequence:create(fadeout, cc.CallFunc:create(function()
        text:removeFromParent()
    end))

    text:runAction(moveBy)
    text:runAction(seq)

    return text
end

return ui
