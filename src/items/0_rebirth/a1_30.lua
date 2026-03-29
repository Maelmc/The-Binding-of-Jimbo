-- The Sad Onion
SMODS.Joker {
  key = "the_sad_onion",
  pos = {x = 0, y = 0},
  config = {extra = {chips = 0, chips_mod = 3}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.chips_mod, card.ability.extra.chips}}
  end,
  rarity = 1,
  cost = 4,
  atlas = "jokers",
  perishable_compat = false,
  eternal_compat = true,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.before and not context.blueprint then
      SMODS.scale_card(card, {
        ref_value = 'chips',
        scalar_value = 'chips_mod',
      })
    end

    if context.joker_main then
      return {
        chips = card.ability.extra.chips
      }
    end
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end
}

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
  perishable_compat = true,
  eternal_compat = true,
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
  perishable_compat = true,
  eternal_compat = true,
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
  perishable_compat = true,
  eternal_compat = true,
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
  perishable_compat = true,
  eternal_compat = true,
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
SMODS.Joker {
  key = "blood_of_the_martyr",
  atlas = "jokers",
  pos = {x = 6, y = 0},
  perishable_compat = true,
  blueprint_compat = false,
  eternal_compat = true,
  rarity = 1,
  cost = 4,
  config = { extra = { } },
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue + 1] = G.P_CENTERS.m_mult
    return { vars = {} }
  end,
  calculate = function(self, card, context)
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end,
  angel = true,
}

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
  perishable_compat = true,
  eternal_compat = true,
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
SMODS.Joker {
  key = "skatole",
  pos = {x = 8, y = 0},
  config = {extra = {}},
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.m_tboj_poop
    info_queue[#info_queue + 1] = G.P_CENTERS.spiderfly_tboj_pretty_fly
    return {vars = {}}
  end,
  rarity = 1,
  cost = 4,
  atlas = "jokers",
  perishable_compat = true,
  eternal_compat = true,
  blueprint_compat = true,
  enhancement_gate = "m_tboj_poop",
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play then
      if not context.end_of_round and not context.before
      and not context.after and not context.other_card.debuff
      and SMODS.has_enhancement(context.other_card, "m_tboj_poop") then
        local _card = SMODS.create_card {
          set = "tboj_spiderfly",
          key = "spiderfly_tboj_pretty_fly",
          area = G.flies
        }
        _card:add_to_deck()
        G.flies:emplace(_card)
        SMODS.calculate_effect({message = localize('tboj_flies_ex'),}, card)
      end
    end
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end,
  poop = true,
}

-- Halo of Flies
SMODS.Joker {
  key = "halo_of_flies",
  pos = {x = 9, y = 0},
  config = {extra = {flies = 2}},
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue + 1] = G.P_CENTERS.spiderfly_tboj_pretty_fly
    return {vars = {card.ability.extra.flies}}
  end,
  rarity = 1,
  cost = 2,
  atlas = "jokers",
  perishable_compat = true,
  eternal_compat = false,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.selling_self and not context.blueprint then
      for _ = 1, card.ability.extra.flies do
        local _card = SMODS.create_card {
          set = "tboj_spiderfly",
          key = "spiderfly_tboj_pretty_fly",
          area = G.flies
        }
        _card:add_to_deck()
        G.flies:emplace(_card)
      end
      SMODS.calculate_effect({message = localize('tboj_flies_ex'),}, card)
    end
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end,
  fly = true,
}

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
  perishable_compat = true,
  eternal_compat = false,
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
SMODS.Joker {
  key = "a_dollar",
  pos = {x = 2, y = 1},
  config = {extra = {money = 100}},
  loc_vars = function(self, info_queue, card)
    return {vars = { card.ability.extra.money }}
  end,
  rarity = 3,
  cost = 1,
  atlas = "jokers",
  perishable_compat = true,
  eternal_compat = false,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.selling_self then
      TBOJ.ease_money(card.ability.extra.money)
    end
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end
}

-- Boom!
SMODS.Joker {
  key = "boom",
  pos = {x = 3, y = 1},
  config = {extra = {bombs= 10}},
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue + 1] = G.P_CENTERS.c_tboj_bomb
    return {vars = { card.ability.extra.bombs }}
  end,
  rarity = 1,
  cost = 5,
  atlas = "jokers",
  perishable_compat = true,
  eternal_compat = false,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.selling_self then
      for _ = 1, card.ability.extra.bombs do
        if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
          G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
          G.E_MANAGER:add_event(Event({
            func = (function()
              G.GAME.consumeable_buffer = 0
              play_sound('timpani')
              SMODS.add_card({ set = 'Loot', key = "c_tboj_bomb" })
              card:juice_up(0.3, 0.5)
              return true
            end)
          }))
        end
      end
    end
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end
}

-- Transcendence
-- The Compass
-- Lunch
-- Dinner
-- Dessert
-- Breakfast
SMODS.Joker {
  key = "breakfast",
  pos = {x = 9, y = 1},
  config = {extra = {to_draw = 5}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.to_draw}}
  end,
  rarity = 1,
  cost = 4,
  atlas = "jokers",
  perishable_compat = true,
  eternal_compat = false,
  blueprint_compat = false,
  calculate = function(self, card, context)
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end
}

-- Rotten Meat
-- Wooden Spoon
-- The Belt
-- Mom's Underwear
-- Mom's Heels