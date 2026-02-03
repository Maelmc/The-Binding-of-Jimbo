SMODS.Blind {
  key = "siren",
  dollars = 8,
  mult = 2,
  boss = { showdown = false, min = 4, max = 80 },
  boss_colour = HEX("515151"),
  pos = { x = 0, y = 0 },
  atlas = "boss_blinds",
  discovered = false,
  debuff = { },
  config = {disabled = false},
  set_blind = function(self)
  end,
  defeat = function(self)
  end,
  in_pool = function(self)
    return true
  end,
}