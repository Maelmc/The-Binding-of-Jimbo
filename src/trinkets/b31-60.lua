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
  attributes = {"xmult"},
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
  end,
  attributes = {"hand_size"},
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
  loc_vars = function(self, info_queue, card)
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
  attributes = {"passive", "mod_chance"},
}

-- Burnt Penny
-- Flat Penny
-- Counterfeit Penny
TBOJ.Trinket {
  key = "counterfeit_penny",
  pos = { x = 6, y = 3 },
  cost = 4,
  config = {extra = {num = 1, den = 2, money = 1, triggered = false}},
  loc_vars = function(self, info_queue, card)
    local num, den = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.den, "tboj_counterfeit_penny")
    return { vars = { num, den, card.ability.extra.money } }
  end,
  calculate = function(self, card, context)
    if context.money_altered and context.amount > 0 and not context.tboj_from_counterfeit then
      if SMODS.pseudorandom_probability(card, "tboj_counterfeit_penny", card.ability.extra.num, card.ability.extra.den, "tboj_counterfeit_penny") then
        TBOJ.ease_dollars(card.ability.extra.money)
        card_eval_status_text(card, 'dollars', card.ability.extra.money, percent)
        return nil, true
      end
    end
  end,
  attributes = {"economy", "chance"},
}

-- Tick
-- Isaac's Head