SMODS.Blind {
  key = "monstro",
  dollars = 5,
  mult = 2,
  boss = { showdown = false, min = 1, max = 80 },
  boss_colour = G.C.TBOJ.MOD_COLOR,
  pos = { x = 0, y = 0 },
  atlas = "boss_blinds",
  discovered = false,
  debuff = { },
  config = {amount = 14},
  collection_loc_vars = function (self)
    return {vars = {self.config.amount}}
  end,
  loc_vars = function (self)
    return {vars = {self.config.amount}}
  end,
  calculate = function(self, blind, context)
    if context.setting_blind then
      local available = {}
      for i, v in ipairs(G.playing_cards) do
        available[i] = v
      end
      for _ = 1, blind.effect.amount do
        if #available == 0 then break end
        local idx = pseudorandom('tboj_monstro', 1, #available)
        local card = table.remove(available, idx)
        card.ability.tboj_monstro = true
        SMODS.recalc_debuff(card)
      end
    end
  end,
  defeat = function(self)
    for _, v in pairs(G.playing_cards) do
      v.ability.tboj_monstro = nil
    end
  end,
  disable = function(self)
    self.config.disabled = true
    for _, v in pairs(G.playing_cards) do
      v.ability.tboj_monstro = nil
    end
  end,
  tboj_artist = "Maelmc"
}