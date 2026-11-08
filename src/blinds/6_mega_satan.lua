SMODS.Blind {
  key = "mega_satan",
  dollars = 12,
  mult = 2,
  boss = { tboj_final_boss = true },
  boss_colour = HEX("474747"),
  pos = { x = 0, y = 23 },
  atlas = "boss_blinds",
  discovered = false,
  debuff = { },
  config = {disabled = false},
  calculate = function(self, blind, context)
    if not blind.disabled then
      if G.GAME.chips >= G.GAME.blind.chips then
        blind.triggered = true
        G.GAME.chips = 0
        G.GAME.modifiers.tboj_mega_satan_first_phase = true
      end
    end

    if not blind.disabled then
      if context.drawing_cards and G.GAME.modifiers.tboj_mega_satan_first_phase then
        G.GAME.modifiers.tboj_mega_satan_first_phase = nil
        blind:disable()
      end
    end
  end,
  defeat = function(self)
    G.GAME.modifiers.tboj_mega_satan_first_phase = nil
  end,
  in_pool = function (self)
    return G.GAME.modifiers.tboj_final_boss
      and G.GAME.round_resets.ante > 0
      and G.GAME.round_resets.ante % G.GAME.win_ante == 0
  end
}