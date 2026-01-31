SMODS.Stake { 
    key = 'void_stake',
    applied_stakes = {'gold'},
    above_stake = 'gold',
    prefix_config = {
      above_stake = {mod = false},
      applied_stakes = {mod = false}
    },
    modifiers = function()
        G.GAME.win_ante = (G.GAME.win_ante + 1)
    end,
    pos = {x = 1, y = 0},
    sticker_pos = {x = 1, y = 0},
    atlas = 'stakes',
    sticker_atlas = 'stake_stickers',
    colour = HEX("C81111"),
    shiny = true
}