-- NO! 88
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

-- Child Leash
TBOJ.Trinket {
  key = "child_leash",
  pos = { x = 13, y = 5 },
  cost = 6,
  config = {extra = {Xmult_multi = 1.2}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.Xmult_multi}}
  end,
  calculate = function(self, card, context)
    if context.other_joker and (context.other_joker.config.center.familiar) then
      return {
        xmult = card.ability.extra.Xmult_multi
      }
    end
  end,
}

-- Brown Cap