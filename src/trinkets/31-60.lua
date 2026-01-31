-- Push Pin
-- Liberty Cap
-- Umbilical Cord
-- Child's Heart
-- Curved Horn
TBOJ.Trinket {
  key = "curved_horn",
  pos = { x = 4, y = 2 },
  cost = 6,
  config = {extra = {Xmult = 2}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.Xmult}}
  end,
  calculate = function(self, card, context)
    if context.joker_main then
      return {
        colour = G.C.XMULT,
        Xmult = card.ability.extra.Xmult
      }
    end
  end,
  in_pool = function(self)
    return TBOJ.in_pool(self)
  end
}

-- Rusted Key
-- Goat Hoof
-- Mom's Pearl
-- Cancer
-- Red Patch
-- Match Stick
-- Lucky Toe
TBOJ.Trinket {
  key = "lucky_toe",
  pos = { x = 11, y = 2 },
  cost = 4,
  config = {extra = {plus_odds = 1}},
  loc_vars = function(self, info_queue, center)
    return {vars = {center.ability.extra.plus_odds}}
  end,
  calculate = function(self, card, context)
    if context.mod_probability and not context.blueprint then
      return 
      {
        numerator = context.numerator + card.ability.extra.plus_odds
      }
    end
  end,
  in_pool = function(self)
    return TBOJ.in_pool(self)
  end
}