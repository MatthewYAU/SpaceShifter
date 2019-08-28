return {
    Attack1 = {
        name = 'Attack 1',
        icon = 'attack1',
        score = 1,
        effect = function(self, enemy)
            enemy.life = enemy.life - 1
        end,
    },
    Heal3 = {
        name = 'Heal 3',
        icon = 'heal3',
        score = 1,
        effect = function(self, enemy)
            self.life = self.life + 1
        end,
    }
}