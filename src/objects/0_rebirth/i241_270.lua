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
SMODS.Joker {
  key = "missing_no",
  pos = {x = 2, y = 17},
  config = {extra = {}},
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue+1] = {set = 'Other', key = 'tboj_reroll'}
    return {vars = {}}
  end,
  rarity = 1,
  cost = 4,
  atlas = "jokers",
  perishable_compat = true,
  eternal_compat = true,
  blueprint_compat = false,
  calculate = function(self, card, context)
    if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
      for k, v in ipairs(G.jokers.cards) do
        if v.config.center.key ~= "j_tboj_missing_no" then
          TBOJ.reroll(v,TBOJ.get_random_key({set = v.ability.set, seed = "tboj_missing_no" .. G.GAME.round_resets.ante}))
        end
      end
    end
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end
}

-- Dark Matter
-- Black Candle
SMODS.Joker {
  key = "black_candle",
  pos = {x = 4, y = 17},
  config = {extra = {}},
  loc_vars = function(self, info_queue, card)
    return {vars = {}}
  end,
  rarity = 3,
  cost = 8,
  atlas = "jokers",
  perishable_compat = true,
  eternal_compat = true,
  blueprint_compat = false,
  calculate = function(self, card, context)
    if context.modify_shop_card and context.card.ability then
      context.card.ability.perishable = false
      context.card.ability.perishable = nil
      context.card.ability.eternal = false
      context.card.ability.rental = false
    end
  end,
  in_pool = function (self, args)
    return (G.GAME.modifiers.enable_eternals_in_shop or G.GAME.modifiers.enable_perishables_in_shop or G.GAME.modifiers.enable_rentals_in_shop) and TBOJ.in_pool(self, args)
  end
}

-- Proptosis
SMODS.Joker {
  key = "proptosis",
  pos = {x = 6, y = 17},
  config = {extra = {Xmult_multi = 3}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.Xmult_multi}}
  end,
  rarity = 2,
  cost = 7,
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
SMODS.Joker {
  key = "headless_baby",
  pos = {x = 13, y = 17},
  config = {extra = {mult = 1}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.mult}}
  end,
  rarity = 1,
  cost = 4,
  atlas = "jokers",
  perishable_compat = true,
  eternal_compat = true,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.hand and not context.end_of_round and (not context.other_card:is_face()) then
      context.other_card.ability.perma_mult = (context.other_card.ability.perma_mult or 0) + card.ability.extra.mult
      return {
        message = localize('k_upgrade_ex')
      }
    end
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end,
  familiar = true,
  devil = true
}

-- Leech