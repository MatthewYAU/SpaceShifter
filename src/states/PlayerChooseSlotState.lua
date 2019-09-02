local function setTargetSlot(next, playerNeighbours)
    if next ~= nil and hasValue(playerNeighbours, next) then
        player.targetSlot = next
    end
end

PlayerChooseSlotState = {}

function PlayerChooseSlotState:init()
    
end

function PlayerChooseSlotState:enter()
    -- auto choose enemy slot
    local neighbourId = map:isNeighbour(player.slot, currentEnemy.slot)
    if neighbourId == 0 then
        player.targetSlot = player.slot
    else
        player.targetSlot = currentEnemy.slot
    end
end

function PlayerChooseSlotState:draw()
    local slot = map.slots[player.targetSlot]
    
    setColor(white)
    love.graphics.draw(imgSlotSelect, mapX + slot.x, mapY + slot.y)
end

function PlayerChooseSlotState:keypressed(key)
    local playerNeighbours = map:getNeighbours(player.slot)
    -- add self slot
    playerNeighbours[#playerNeighbours+1] = player.slot
    
    local next
    if key == keys.DPad_up then
        next = map:getNeighbours(player.targetSlot)[1]
        if next == nil or not hasValue(playerNeighbours, next) then
            next = map:getNeighbours(player.targetSlot)[6]
        end
        if next == nil or not hasValue(playerNeighbours, next) then
            next = map:getNeighbours(player.targetSlot)[2]
        end
        setTargetSlot(next, playerNeighbours)
    elseif key == keys.DPad_down then
        next = map:getNeighbours(player.targetSlot)[4]
        if next == nil or not hasValue(playerNeighbours, next) then
            next = map:getNeighbours(player.targetSlot)[5]
        end
        if next == nil or not hasValue(playerNeighbours, next) then
            next = map:getNeighbours(player.targetSlot)[3]
        end
        setTargetSlot(next, playerNeighbours)
    elseif key == keys.DPad_left then
        next = map:getNeighbours(player.targetSlot)[6]
        if next == nil or not hasValue(playerNeighbours, next) then
            next = map:getNeighbours(player.targetSlot)[5]
        end
        setTargetSlot(next, playerNeighbours)
    elseif key == keys.DPad_right then
        next = map:getNeighbours(player.targetSlot)[2]
        if next == nil or not hasValue(playerNeighbours, next) then
            next = map:getNeighbours(player.targetSlot)[3]
        end
        setTargetSlot(next, playerNeighbours)
    end

    if key == keys.A then
        GameState.switch(ResolutionState)
    end
end