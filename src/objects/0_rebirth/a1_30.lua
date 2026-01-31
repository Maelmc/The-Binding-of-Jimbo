-- The Sad Onion
-- The Inner Eye
SMODS.Joker {
  key = "the_inner_eye",
  pos = {x = 1, y = 0},
  config = {extra = {selection_limit_mod = 1}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.selection_limit_mod}}
  end,
  rarity = 3,
  cost = 8,
  atlas = "jokers",
  blueprint_compat = false,
  calculate = function(self, card, context)
  end,
  add_to_deck = function(self, card, from_debuff)
    SMODS.change_play_limit(card.ability.extra.selection_limit_mod)
    SMODS.change_discard_limit(card.ability.extra.selection_limit_mod)
  end,
  remove_from_deck = function(self, card, from_debuff)
    SMODS.change_play_limit(-card.ability.extra.selection_limit_mod)
    SMODS.change_discard_limit(-card.ability.extra.selection_limit_mod)
    if not G.GAME.before_play_buffer then
      G.hand:unhighlight_all()
    end
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end
}

-- Spoon Bender
SMODS.Joker {
  key = "spoon_bender",
  pos = {x = 2, y = 0},
  config = {extra = {Xmult_multi = 2}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.Xmult_multi}}
  end,
  rarity = 3,
  cost = 8,
  atlas = "jokers",
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.cardarea == "unscored" and context.individual then
      return {
        colour = G.C.MULT,
        Xmult = card.ability.extra.Xmult_multi
      }
    end
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end
}

-- Cricket's Head
SMODS.Joker {
  key = "cricket_head",
  pos = {x = 3, y = 0},
  config = {extra = {Xmult = 2.5, mult = 10}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.mult, card.ability.extra.Xmult}}
  end,
  rarity = 3,
  cost = 8,
  atlas = "jokers",
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.joker_main then
      return {
        colour = G.C.XMULT,
        mult = card.ability.extra.mult,
        Xmult = card.ability.extra.Xmult
      }
    end
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end
}

-- My Reflection
-- Number One
SMODS.Joker {
  key = "number_one",
  pos = {x = 5, y = 0},
  config = {extra = {chips = 100, card_limit = 3}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.chips, card.ability.extra.card_limit}}
  end,
  rarity = 1,
  cost = 4,
  atlas = "jokers",
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.joker_main and #context.full_hand <= card.ability.extra.card_limit then
      return {
        colour = G.C.CHIPS,
        chips = card.ability.extra.chips,
      }
    end
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end
}

-- Blood of the Martyr
-- Brother Bobby
SMODS.Joker {
  key = "brother_bobby",
  pos = {x = 7, y = 0},
  config = {extra = {chips = 40}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.chips}}
  end,
  rarity = 1,
  cost = 3,
  atlas = "jokers",
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.joker_main then
      return {
        colour = G.C.CHIPS,
        chips = card.ability.extra.chips,
      }
    end
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end,
  familiar = true
}

-- Skatole
-- Halo of Flies
-- 1up!
-- Magic Mushroom
-- The Virus
-- Roid Rage
-- <3
SMODS.Joker {
  key = "heart",
  pos = {x = 14, y = 0},
  config = {extra = {}},
  loc_vars = function(self, info_queue, card)
    return {vars = {}}
  end,
  rarity = 2,
  cost = 6,
  atlas = "jokers",
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.selling_self and not context.blueprint then
      if G.hand and G.hand.cards and #G.hand.cards > 0 then
        TBOJ.juice_flip_hand(card)
        for i=1, #G.hand.cards do
          G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function() G.hand.cards[i]:change_suit("Hearts");return true end }))
        end 
        TBOJ.juice_flip_hand(card, true)
      end
    end
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end,
}

-- Raw Liver
-- Skeleton Key
-- A Dollar
-- Boom!
-- Transcendence
-- The Compass
-- Lunch
-- Dinner
-- Dessert
-- Breakfast
-- Rotten Meat
-- Wooden Spoon
-- The Belt
-- Mom's Underwear
-- Mom's Heels