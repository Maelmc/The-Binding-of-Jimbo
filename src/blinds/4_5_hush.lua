SMODS.Blind {
  key = "hush",
  dollars = 12,
  mult = 8,
  boss = { tboj_final_boss = true },
  boss_colour = HEX("5871A3"),
  pos = { x = 0, y = 20 },
  atlas = "boss_blinds",
  discovered = false,
  debuff = { },
  config = {disabled = false},
  set_blind = function(self)
  end,
  calculate = function(self, blind, context)
    if context.blind_disabled then
      G.GAME.blind.chips = G.GAME.blind.chips / (self.mult/2)
      G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
    end
  end,
  in_pool = function (self)
    return G.GAME.modifiers.tboj_final_boss
      and G.GAME.round_resets.ante > 0
      and G.GAME.round_resets.ante % G.GAME.win_ante == 0
  end,
  tboj_artist = "Maelmc"
}