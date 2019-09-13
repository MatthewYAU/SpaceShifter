testsActions = {}

function testsActions:setUp()
    GameState = {switch = function()end}
    currentEnemy = enemies.container.banshee
    
    player.slot = 1
    player.playingCard = Card(actions.container.move)
    player.targetSlot = 2
    player.playingCardAsAction = true
    player.currentCardId = 1
    
    currentEnemy.playingCard = Card(actions.container.move)
    currentEnemy.playingCardAsAction = true
    currentEnemy.currentCardId = 1
    currentEnemy.slot = 7
    currentEnemy.targetSlot = 7
    currentEnemy.hand = {{action=actions.container.attack1}, {action=actions.container.attack1}
        , currentEnemy.playingCard}
end

function testsActions:testMove()
    currentEnemy.targetSlot = 5

    ResolutionState:move(player.playingCard.action, currentEnemy.playingCard.action)

    luaunit.assertEquals(player.slot, 2)
    luaunit.assertEquals(currentEnemy.slot, 5)
end

function testsActions:testIfBothSameTarget_NeitherMove()    
    currentEnemy.targetSlot = 2
    
    ResolutionState:move(player.playingCard.action, currentEnemy.playingCard.action)
    
    luaunit.assertEquals(player.slot, 1)
    luaunit.assertEquals(currentEnemy.slot, 7)
end

function testsActions:testDropCard()
    local playerPlayingCard = {action = actions.container.drop1}
    player.playingCard = playerPlayingCard
    player.targetSlot = 7
    player.hand = {playerPlayingCard, {action=actions.container.attack1}}

    ResolutionState:enter()

    luaunit.assertEquals(#currentEnemy.hand, 2)
end

function testsActions:testDropCard_NotSecondCardWhenFirstIsPlayingCard()
    local playerPlayingCard = {action = actions.container.drop1}
    player.playingCard = playerPlayingCard
    player.targetSlot = 7
    player.hand = {playerPlayingCard, {action=actions.container.attack1}}
    
    currentEnemy.hand = {currentEnemy.playingCard, {action=actions.container.attack1}}

    ResolutionState.cardsEffect(player.playingCard.action, currentEnemy.playingCard.action)
    luaunit.assertEquals(#currentEnemy.hand, 1)
    luaunit.assertEquals(currentEnemy.hand[1], currentEnemy.playingCard)
end

function testsActions:testDropCard_NotDropPlayingCardWhenOnly()
    local playerPlayingCard = {action = actions.container.drop1}
    player.playingCard = playerPlayingCard
    player.targetSlot = 7
    player.hand = {playerPlayingCard, {action=actions.container.attack1}}
    
    currentEnemy.hand = {currentEnemy.playingCard}

    ResolutionState:enter()
    luaunit.assertEquals(#currentEnemy.hand, 1)
end

function testsActions:testDropCard_MissSlot_NotDrop()
    local playerPlayingCard = {action = actions.container.drop1}
    player.playingCard = playerPlayingCard
    player.targetSlot = 2
    player.hand = {playerPlayingCard, {action=actions.container.attack1}}
    
    ResolutionState:enter()
    luaunit.assertEquals(#currentEnemy.hand, 3)
end

function testsActions:testSpaceRecover()
    map.slots[6].card = {space = spaces.container.plain, deck = decks.PlayerDeck}
    map.slots[6].baseCard = {space = spaces.container.graveyard, deck = decks.PublicDeck}
    
    currentEnemy.playingCard = {action = actions.container.spaceRecover}
    currentEnemy.targetSlot = 6

    ResolutionState:enter()
    luaunit.assertEquals(map.slots[6].card, map.slots[6].baseCard)
end

function testsActions:testUniverseRecover()
    for _, slot in pairs(map.slots) do
        slot.baseCard = {space = spaces.container.plain, deck = decks.PublicDeck}
        slot.card = slot.baseCard
    end
    map.slots[1].card = {space = spaces.container.plain, deck = decks.PlayerDeck}
    map.slots[3].card = {space = spaces.container.mountain, deck = decks.PlayerDeck}
    map.slots[6].card = {space = spaces.container.graveyard, deck = decks.PlayerDeck}

    currentEnemy.playingCard = {action = actions.container.universeRecover}

    ResolutionState:enter()
    
    for _, slot in pairs(map.slots) do
        luaunit.assertEquals(slot.card, slot.baseCard)
    end
end

function testsActions:testA1Drop1_DropCard()
    local playerPlayingCard = {action = actions.container.drop1}
    player.playingCard = playerPlayingCard
    player.targetSlot = 1
    player.life = 3
    player.hand = {playerPlayingCard, {action=actions.container.attack1}}

    currentEnemy.playingCard = {action = actions.container.a1drop1}
    currentEnemy.targetSlot = 1
    currentEnemy.life = 4

    ResolutionState:enter()

    luaunit.assertEquals(player.life, 2)
    luaunit.assertEquals(#player.hand, 0)
end