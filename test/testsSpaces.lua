testsSpaces = {}

function testsSpaces:setUp()
    GameState = {switch = function()end}
    currentEnemy = enemies.container.banshee
    ResolutionState:reset()
    player.slot = 1
    player.playingCardAsAction = true
end

function testsSpaces:tearDown()
    ResolutionState:reset()
end

function testsSpaces:testFenceAffectDefence()
    player.playingCard = {action = actions.container.move}
    player.targetSlot = 1
    map.slots[1].card = {space = spaces.container.fence}
    currentEnemy.slot = 2
    map.slots[2].card = {space = spaces.container.fence}
    ResolutionState.extraDefence()

    luaunit.assertEquals(player.defence, 1)
    luaunit.assertEquals(currentEnemy.defence, 1)
end

function testsSpaces:testCircleAffectAttack()
    player.playingCard = Card(actions.container.attack1)
    map.slots[1].card = Card(nil, spaces.container.circle)
    player.playingCard.action:effect(player, currentEnemy)

    luaunit.assertEquals(player.attack, 2)
end

function testsSpaces:testGraveyardRunOnUpkeep()
    player.life = 3
    map.slots[1].card = {space = spaces.container.graveyard}

    UpkeepState:enter()

    luaunit.assertEquals(player.life, 2)
end

function testsSpaces:testGraveyard_ImmuneChar_Nothing()
    currentEnemy = enemies.container.ghost
    currentEnemy.life = 5
    currentEnemy.slot = 2
    map.slots[2].card = {space = spaces.container.graveyard}
    
    UpkeepState:enter()

    luaunit.assertEquals(currentEnemy.life, 5)
end

function testsSpaces:testCovePickCardOnDamaged()
    fillAllDecks()
    
    map.slots[1].card = {space = spaces.container.well}
    map.slots[1].card = {space = spaces.container.well}
    
    player.playingCard = {action = actions.container.move}
    player.life = 3
    player.targetSlot = 1
    player.currentCardId = 1
    player.hand = {player.playingCard}
    
    currentEnemy.playingCard = {action = actions.container.attack1}
    currentEnemy.targetSlot = 1
    currentEnemy.hand = {currentEnemy.playingCard, {action = actions.container.attack1}}

    ResolutionState:enter()

    luaunit.assertEquals(#player.hand, 1)
    luaunit.assertEquals(#currentEnemy.hand, 2)
end

function testsSpaces:testDesertDropCardOnAttack()
    map.slots[1].card = {space = spaces.container.desert}
    map.slots[2].card = {space = spaces.container.circle}

    player.playingCard = {action = actions.container.attack1}
    player.life = 3
    player.targetSlot = 2
    player.currentCardId = 1
    player.hand = {player.playingCard, {action = actions.container.attack1}}

    currentEnemy.playingCard = {action = actions.container.attack1}
    currentEnemy.targetSlot = 1
    currentEnemy.hand = {currentEnemy.playingCard, {action = actions.container.attack1}}

    ResolutionState.onAttack()

    luaunit.assertEquals(#player.hand, 2)
    luaunit.assertEquals(#currentEnemy.hand, 1)
end

function testsSpaces:testDesert_NotCorrectSlot_NoDropCard()
    map.slots[1].card = {space = spaces.container.desert}
    map.slots[2].card = {space = spaces.container.circle}

    player.playingCard = {action = actions.container.attack1}
    player.life = 3
    player.targetSlot = 3
    player.currentCardId = 1
    player.hand = {player.playingCard, {action = actions.container.attack1}}

    currentEnemy.playingCard = {action = actions.container.attack1}
    currentEnemy.targetSlot = 1
    currentEnemy.hand = {currentEnemy.playingCard, {action = actions.container.attack1}}

    ResolutionState.onAttack()

    luaunit.assertEquals(#player.hand, 2)
    luaunit.assertEquals(#currentEnemy.hand, 2)
end