-- Push Pin
-- Liberty Cap
-- Umbilical Cord
-- Child's Heart
-- Curved Horn
TBOJ.Trinket {
  key = "curved_horn",
  pos = { x = 4, y = 2 },
  cost = 5,
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
}

-- Rusted Key
-- Goat Hoof
TBOJ.Trinket {
  key = "goat_hoof",
  pos = { x = 6, y = 2 },
  cost = 4,
  config = {extra = {h_size = 1}},
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.h_size } }
  end,
  add_to_deck = function(self, card, from_debuff)
    G.hand:change_size(card.ability.extra.h_size)
  end,
  remove_from_deck = function(self, card, from_debuff)
    G.hand:change_size(-card.ability.extra.h_size)
  end
}

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
    return {vars = {card.ability.extra.plus_odds, 1 + card.ability.extra.plus_odds}}
  end,
  calculate = function(self, card, context)
    if context.mod_probability and not context.blueprint then
      return 
      {
        numerator = context.numerator + card.ability.extra.plus_odds
      }
    end
  end,
}