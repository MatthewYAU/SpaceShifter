Card = class{}

function Card:init(action, space, x, y, deck)
    self.action = action
    self.space = space
    
    self.tweenWidth = 0
    self.isShowAction = true
    
    self.deck = deck
    
    x = x or screenWidth/2-cardWidth/2
    y = y or -cardHeight
    self.x = x
    self.y = y
end

function Card:draw()
    if self.isShowAction then
        self:drawCardAsAction()
    else
        self:drawCardAsSpace()
    end
end

function Card:drawCardAsAction()
    setColor(white)
    -- bg
    local imgBg
    if table.contains(self.action.type, 'special') then
        imgBg = imgSpecialCard
    else
        imgBg = imgCardActionBg
    end
    love.graphics.draw(imgBg, self.x+self.tweenWidth/2, self.y, 0,
        1-(self.tweenWidth/cardWidth), 1)

    -- icon
    love.graphics.draw(self.action.icon, self.x+self.tweenWidth/2+4, self.y+4, 0,
            1-(self.tweenWidth/cardWidth), 1)

    -- effect
    love.graphics.draw(self.action.effectIcon, self.x+self.tweenWidth/2+4, self.y+40, 0,
            1-(self.tweenWidth/cardWidth), 1)
end

function Card:drawCardAsSpace()
    setColor(white)
    -- bg
    love.graphics.draw(imgCardSpaceBg, self.x+self.tweenWidth/2, self.y, 0,
            1-(self.tweenWidth/cardWidth), 1)
    
    -- icon
    love.graphics.draw(self.space.icon, self.x+self.tweenWidth/2+4, self.y+4, 0,
            1-(self.tweenWidth/cardWidth), 1)
    
    -- effect
    love.graphics.draw(self.space.effectIcon, self.x+self.tweenWidth/2+4, self.y+40, 0,
            1-(self.tweenWidth/cardWidth), 1)
end

function Card:flip(caller, onFliped)
    flux.to(self, 0.1, {tweenWidth = cardWidth}):oncomplete(function()
        self.isShowAction = not self.isShowAction
        flux.to(self, 0.1, {tweenWidth = 0})
        if onFliped~= nil then onFliped(caller) end
    end)
end

function Card:moveTo(targetX, targetY, time, onComplete, method)
    time = time or 0.4
    method = method or 'linear'
    --print(self.action.name..'|'..tostring(self.deck)..' move to '..tostring(targetX)..','..tostring(targetY))
    timer.tween(time, self, {x = targetX, y = targetY}, method, onComplete)
end