-- Contract From Below
SMODS.Joker {
  key = "contract_from_below",
  pos = {x = 0, y = 16},
  config = {extra = {num = 1, den = 3}},
  loc_vars = function(self, info_queue, card)
    local num, den = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.den, "tboj_pill")
    return {vars = {num, den}}
  end,
  rarity = 1,
  cost = 6,
  atlas = "jokers",
  perishable_compat = true,
  eternal_compat = true,
  blueprint_compat = false,
  calculate = function(self, card, context)
  end,
  calc_dollar_bonus = function(self, card)
    local _m = G.GAME.blind.dollars * 2
    if SMODS.pseudorandom_probability(card, "tboj_contract_from_below", card.ability.extra.num, card.ability.extra.den, "tboj_contract_from_below") then
      _m = -G.GAME.blind.dollars
    end
    return _m
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end,
  devil = true,
}

-- Infamy
-- Trinity Shield
-- Tech .5
-- 20/20
SMODS.Joker {
  key = "20_20",
  pos = {x = 4, y = 16},
  config = {extra = {repetitions = 1}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.repetitions}}
  end,
  rarity = 3,
  cost = 8,
  atlas = "jokers",
  perishable_compat = true,
  eternal_compat = true,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.repetition and context.cardarea == G.play then
      return {
        repetitions = card.ability.extra.repetitions
      }
    end
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end,
}

-- Blue Map
-- BFFS!
-- Hive Mind
-- There's Options
-- BOGO Bombs
-- Starter Deck
-- Little Baggy
-- Magic Scab
-- Blood Clot
-- Screw
-- Hot Bombs
-- Fire Mind
-- Missing No.
-- Dark Matter
-- Black Candle
-- Proptosis
SMODS.Joker {
  key = "proptosis",
  pos = {x = 6, y = 17},
  config = {extra = {Xmult_multi = 3}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.Xmult_multi}}
  end,
  rarity = 2,
  cost = 6,
  atlas = "jokers",
  perishable_compat = true,
  eternal_compat = true,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play then
      for k, v in ipairs(G.play.cards) do
        if context.other_card == v and card.ability.extra.Xmult_multi / k ~= 1 then
          return {
            xmult = card.ability.extra.Xmult_multi / k
          }
        end
      end
    end
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end
}

-- Missing Page 2
-- Clear Rune
-- Smart Fly
-- Dry Baby
-- JuicySack
-- Robo-Baby 2.0
-- Rotten Baby
-- Headless Baby
-- Leech