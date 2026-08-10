-- Fate's Reward
-- Lil Chest
-- Lil Chest
-- Sworn Protector
-- Friend Zone
SMODS.Joker {
  key = "friend_zone",
  pos = {x = 3, y = 24},
  config = {extra = {money = 1}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.money}}
  end,
  rarity = 1,
  cost = 4,
  atlas = "jokers",
  perishable_compat = true,
  eternal_compat = true,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play then
      local third = context.scoring_hand[3] or {}
      local fourth = context.scoring_hand[4] or {}
      if context.other_card == third or context.other_card == fourth then
        return {
          dollars = card.ability.extra.money,
        }
      end
    end
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end,
  attributes = {"tboj_familiar", "tboj_fly", "economy"}
}

-- Lost Fly
-- Scatter Bombs
-- Sticky Bombs
-- Epiphora
SMODS.Joker {
  key = "epiphora",
  pos = {x = 7, y = 24},
  config = {extra = {to_retrigger = 0, retrigg_scale = 1, repetitions = 1, hand = nil}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.to_retrigger, card.ability.extra.repetitions, card.ability.extra.retrigg_scale,
    G.GAME.last_hand_played and localize(G.GAME.last_hand_played, 'poker_hands') or localize("tboj_none"),
  }}
  end,
  rarity = 2,
  cost = 6,
  atlas = "jokers",
  perishable_compat = false,
  eternal_compat = true,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.before then
      if card.ability.extra.hand == context.scoring_name then
        SMODS.scale_card(card, {
          ref_value = 'to_retrigger',
          scalar_value = 'retrigg_scale',
        })
        return nil, true
      else
        card.ability.extra.to_retrigger = 0
        card.ability.extra.hand = G.GAME.last_hand_played
        return {
          message = localize("k_reset")
        }
      end
    end

    if context.repetition and card.ability.extra.to_retrigger > 0 and context.cardarea == G.play then
      for i = 1, card.ability.extra.to_retrigger do
        if context.other_card == context.scoring_hand[i] then
          return {
            repetitions = card.ability.extra.repetitions
          }
        end
      end
    end
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end,
  add_to_deck = function(self, card, from_debuff)
    card.ability.extra.hand = G.GAME.last_hand_played
  end,
  attributes = {"retrigger", "scaling"}
}

-- Continuum
SMODS.Joker {
  key = "continuum",
  pos = {x = 8, y = 24},
  config = {extra = {}},
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue+1] = {set = 'Other', key = 'tboj_shift'}
    return {vars = {}}
  end,
  rarity = 3,
  cost = 8,
  atlas = "jokers",
  perishable_compat = true,
  eternal_compat = true,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.before then
      card.ability.extra.og = nil
    end

    if context.individual and (context.cardarea == G.play) then
      if not card.ability.extra.og then
        card.ability.extra.og = {}
        for i, v in pairs(G.play.cards) do
          card.ability.extra.og[i] = v
        end
      end

      local moved = {}
      for i = 2, #G.play.cards do
        moved[i-1] = G.play.cards[i]
      end
      moved[#G.play.cards] = G.play.cards[1]
      G.play.cards = moved

      local target = context.other_card
      return {
        func = function ()
          G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1,
            func = function() 
              G.play.cards = moved
              return true 
            end 
          }))
          SMODS.calculate_effect({
            message = localize("tboj_shift_ex"),
          }, target )
        end
      }
    end

    if context.after and card.ability.extra.og then
      G.play.cards = card.ability.extra.og
      card.ability.extra.og = nil
    end
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end,
}

-- Mr. Dolly
-- Curse of the Tower
-- Charged Baby
-- Dead Eye
SMODS.Joker {
  key = "dead_eye",
  pos = {x = 12, y = 24},
  config = {extra = {Xmult = 1, Xmult_mod = 0.1}},
  loc_vars = function(self, info_queue, card)
    local ranks = ""
    if G.GAME.tboj_last_scored_hand then
      for _, v in pairs(G.GAME.tboj_last_scored_hand) do
        if v.value then ranks = ranks..localize(v.value,"ranks").." " end
      end
      ranks = ranks:gsub("%s+$", "")
    end
    if ranks == "" then ranks = localize("tboj_play_hand") end
    return {vars = {card.ability.extra.Xmult_mod, card.ability.extra.Xmult, ranks}}
  end,
  rarity = 2,
  cost = 7,
  atlas = "jokers",
  perishable_compat = false,
  eternal_compat = true,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.before then
      for _, v in pairs(context.scoring_hand) do
        for _, w in pairs(G.GAME.tboj_last_scored_hand) do
          if v:get_id() == w.id then
            SMODS.scale_card(card, {
              ref_value = 'Xmult',
              scalar_value = 'Xmult_mod',
            })
            return nil, true
          end
        end
      end
      if card.ability.extra.Xmult > 1 then
        card.ability.extra.Xmult = 1
        return {
          message = localize('k_reset'),
          colour = G.C.RED
        }
      end
    end

    if context.joker_main then
      return {
        x_mult = card.ability.extra.Xmult
      }
    end
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end,
  attributes = {"rank", "scaling", "reset"},
}

-- Holy Light
SMODS.Joker {
  key = "holy_light",
  pos = {x = 13, y = 24},
  config = {extra = {Xmult_multi = 2, num = 1, den = 5}},
  loc_vars = function(self, info_queue, card)
    local num, den = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.den, "tboj_holy_light")
    return {vars = {num, den, card.ability.extra.Xmult_multi}}
  end,
  rarity = 2,
  cost = 7,
  atlas = "jokers",
  perishable_compat = true,
  eternal_compat = true,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play and SMODS.pseudorandom_probability(card, "tboj_holy_light", card.ability.extra.num, card.ability.extra.den, "tboj_holy_light") then
      return {
        xmult = card.ability.extra.Xmult_multi
      }
    end
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end,
  attributes = {"tboj_angel", "chance", "xmult"}
}
-- Host Hat
-- Restock
-- Bursting Sack
-- Number Two
SMODS.Joker {
  key = "number_two",
  pos = {x = 2, y = 25},
  config = {extra = {every = 2, current = 0}},
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.m_tboj_poop
    info_queue[#info_queue + 1] = G.P_CENTERS.c_tboj_bomb
    return {vars = {card.ability.extra.every, card.ability.extra.current}}
  end,
  rarity = 2,
  cost = 5,
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
        card.ability.extra.current = card.ability.extra.current + 1
        if card.ability.extra.current == card.ability.extra.every then
          card.ability.extra.current = 0
          local _card = SMODS.add_card({ set = "tboj_loot", key = "c_tboj_bomb", edition = 'e_negative' })
          _card.states.visible = nil
          _card.ability.extra.fused = true
          G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1,
            func = function() 
              _card:start_materialize()
              card:juice_up()
              return true 
            end 
          }))
          SMODS.calculate_effect({message = localize('tboj_oops_dot'),}, context.other_card)
        end
      end
    end
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end,
  attributes = {"tboj_poop", "enhancements", "generation", "tboj_loot_attribute", "edition"},
}

-- Pupula Duplex
-- Pay To Play

-- Key Bum
-- Rune Bag
-- Seraphim
SMODS.Joker {
  key = "seraphim",
  pos = {x = 14, y = 25},
  config = {extra = {Xmult_multi = 2}},
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
    if context.pre_splash then
      local _card = SMODS.copy_card(G.play.cards[1], {area = G.play})
      _card.seraphim_target = true
      _card.states.visible = false
      --_card:add_to_deck()
      --G.deck.config.card_limit = G.deck.config.card_limit + 1
      --G.play:emplace(_card)
      --SMODS.add_to_deck(_card, {area = G.play})
      G.E_MANAGER:add_event(Event({
        func = function()
          _card:start_materialize()
          if context.blueprint_card then
            context.blueprint_card:juice_up()
          else
            card:juice_up()
          end
          return true
        end
      }))
      SMODS.calculate_context({playing_card_added = true, cards = {_card}})
    end

    if context.individual and context.other_card.seraphim_target then
      return {
        colour = G.C.MULT,
        Xmult = card.ability.extra.Xmult_multi
      }
    end

    if context.destroy_card and not context.blueprint then
      if context.destroy_card.seraphim_target then return {remove = true} end
    end
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end,
  attributes = {"tboj_angel", "tboj_familiar", "generation", "xmult"}
}