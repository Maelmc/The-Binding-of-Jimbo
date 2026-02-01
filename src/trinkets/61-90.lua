-- No! 88
TBOJ.Trinket {
  key = "no",
  pos = { x = 12, y = 5 },
  cost = 5,
  config = {extra = {}},
  loc_vars = function(self, info_queue, card)
    return {vars = {}}
  end,
  calculate = function(self, card, context)
  end,
  add_to_deck = function(self, card, from_debuff)
    G.GAME.tboj_active_rate = 0
  end,
  remove_from_deck = function(self, card, from_debuff)
    G.GAME.tboj_active_rate = 4
  end,
}