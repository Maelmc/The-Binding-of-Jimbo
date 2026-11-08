SMODS.Stake { 
    key = 'home_stake',
    applied_stakes = {'tboj_void_stake'},
    above_stake = 'tboj_void_stake',
    prefix_config = {
      above_stake = {mod = false},
      applied_stakes = {mod = false}
    },
    modifiers = function()
        G.GAME.modifiers.tboj_final_boss = true
    end,
    pos = {x = 2, y = 0},
    sticker_pos = {x = 2, y = 0},
    atlas = 'stakes',
    sticker_atlas = 'stake_stickers',
    colour = HEX("A5895A"),
    shiny = true
}