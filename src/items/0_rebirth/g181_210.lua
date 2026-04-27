-- White Pony
-- Sacred Heart
SMODS.Joker {
  key = "sacred_heart",
  pos = {x = 2, y = 12},
  config = {extra = {Xmult_multi = 3}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.Xmult_multi}}
  end,
  rarity = 4,
  cost = 20,
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
  end,
  attributes = {"tboj_angel", "xmult"}
}

-- Tooth Picks
-- Holy Grail
-- Dead Dove
SMODS.Joker {
  key = "dead_dove",
  pos = {x = 5, y = 12},
  config = {extra = {to_draw = 50, curr_draw = 0}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.to_draw, card.ability.extra.curr_draw}}
  end,
  rarity = 3,
  cost = 8,
  atlas = "jokers",
  perishable_compat = true,
  eternal_compat = true,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.hand_drawn then
      if not card.ability.extra.processing then
        card.ability.extra.processing = true
        card.ability.extra.curr_draw = card.ability.extra.curr_draw + #context.hand_drawn
      end
      local real_curr = card.ability.extra.curr_draw
      while real_curr >= card.ability.extra.to_draw do
        real_curr = real_curr - card.ability.extra.to_draw
        if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
          G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
          G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
              G.GAME.consumeable_buffer = 0
              play_sound('timpani')
              SMODS.add_card({ set = 'Spectral', key_append = "tboj_dead_dove" })
              return true
            end
          }))
          SMODS.calculate_effect({message = localize('k_plus_spectral'), colour = G.C.SECONDARY_SET.Spectral}, context.blueprint_card or card)
        end
      end

      if not context.blueprint then -- only change the counter after all blueprints proc
        G.E_MANAGER:add_event(Event({
          trigger = 'after',
          delay = 0.4,
          func = function()
            card.ability.extra.curr_draw = real_curr
            card.ability.extra.processing = nil
            return true
          end
        }))
      end
      return nil, true
    end
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end,
  attributes = {"tboj_angel", "generation", "spectral"},
}

-- Blood Rights
-- Guppy's Hairball

-- 3 Dollar Bill
-- Telepathy For Dummies
-- MEAT!
SMODS.Joker {
  key = "meat",
  pos = {x = 12, y = 12},
  config = {extra = {mult_mod = 5}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.mult_mod, card.ability.extra.mult_mod * G.GAME.current_round.hands_left}}
  end,
  rarity = 1,
  cost = 5,
  atlas = "jokers",
  perishable_compat = true,
  eternal_compat = true,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.joker_main then
      return {
        mult = card.ability.extra.mult_mod * G.GAME.current_round.hands_left
      }
    end
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end,
  attributes = {"mult", "hands"},
}

-- Magic 8 Ball
-- Mom's Purse

-- Mom's Key
-- Mom's Eyeshadow
-- Iron Bar
SMODS.Joker {
  key = "iron_bar",
  pos = {x = 5, y = 13},
  config = {extra = {Xmult_mult = 1.5}},
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.m_steel
    return {vars = {card.ability.extra.Xmult_mult}}
  end,
  rarity = 2,
  cost = 7,
  enhancement_gate = 'm_steel',
  atlas = "jokers",
  perishable_compat = true,
  eternal_compat = true,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play and SMODS.has_enhancement(context.other_card, 'm_steel') then
      return {
        x_mult = card.ability.extra.Xmult_multi
      }
    end
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end,
  attributes = {"xmult", "enhancements"},
}

-- Midas' Touch
-- Humbleing Bundle
-- Fanny Pack
-- Sharp Plug
-- Guillotine
-- Ball of Bandage
-- Champion Belt
SMODS.Joker {
  key = "champion_belt",
  pos = {x = 12, y = 13},
  config = {extra = {Xmult = 3}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.Xmult}}
  end,
  rarity = 2,
  cost = 7,
  atlas = "jokers",
  perishable_compat = true,
  eternal_compat = true,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.joker_main then
      return {
        x_mult = card.ability.extra.Xmult
      }
    end
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end,
  attributes = {"xmult", "passive"},
}

-- Butt Bombs
-- Gnawed Leaf